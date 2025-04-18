import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibez/Cubit/user/user_state.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/services/notification_services.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final ImagePicker picker = ImagePicker();
  bool isFollowing = false;
  bool isRequestSent = false;
  bool isPrivate = false;
  bool isConnected = false;
  List<UserModel> users = [];
  Future<void> fetchUserProfile(String userId) async {
    try {
      emit(UserLoading());
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        emit(UserUpdated(
            UserModel.fromJson(userDoc.data() as Map<String, dynamic>)));
      }
    } catch (e) {
      log("Error fetching user profile: $e");
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      emit(UserLoading());
      Reference ref = storage.ref().child("profile_images/$userId.jpg");
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      log("Error uploading image: $e");
      return null;
    }
  }

  Future<void> pickAndUploadImage(String userId) async {
    try {
      emit(UserLoading());
      final pickedFile =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        String? imageUrl = await uploadProfileImage(imageFile, userId);
        if (imageUrl != null) {
          await updateUserProfile(userId, {"image": imageUrl});
        }
      }
    } catch (e) {
      log("Error picking image: $e");
    }
  }

  Future<void> updateUserProfile(String userId, Map<String, dynamic> updatedData) async {
    try {
      if (updatedData.containsKey("username")) {
        String newUsername = updatedData["username"];

        QuerySnapshot querySnapshot = await firestore
            .collection("users")
            .where("username", isEqualTo: newUsername)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          for (var doc in querySnapshot.docs) {
            if (doc.id != userId) {
              Get.snackbar(
                "Username Taken",
                "The username '$newUsername' is already in use. Please choose a different one.",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppColors.to.alertColor,
                colorText: AppColors.to.white,
              );
              return;
            }
          }
        }
      }
      await firestore.collection('users').doc(userId).update(updatedData);
      fetchUserProfile(userId);
      Get.back();
    } catch (e) {
      log("Error updating profile: $e");
    }
  }

  Future<void> fetchChatUserProfile(String userId, String currentUserId) async {
    try {
      emit(UserLoading());

      DocumentSnapshot userSnapshot =
          await firestore.collection('users').doc(userId).get();
      Map<String, dynamic> targetUserData =
      userSnapshot.data() as Map<String, dynamic>;
      if (userSnapshot.exists) {
        var userData = userSnapshot.data() as Map<String, dynamic>;
        if ((userData['followers'] as List<dynamic>?)
                    ?.contains(currentUserId) ==
                null ||
            (userData['followers'] as List<dynamic>?)
                    ?.contains(currentUserId) ==
                false) {
          isFollowing = false;
        } else {
          isFollowing = true;
        }
        if (((userData['followers'] as List<dynamic>?)
                    ?.contains(currentUserId) ==
                true) ||
            ((userData['following'] as List<dynamic>?)
                    ?.contains(currentUserId) ==
                true)) {
          isConnected = true;
          isPrivate=false;
          log("is Connected ======$isConnected");
        } else {
          isConnected = false;
          isPrivate = targetUserData['isPrivate'] ?? false;
          log("is Connected ======$isConnected");
        }

        isRequestSent = (userData['followRequests'] as List<dynamic>?)
                ?.contains(currentUserId) ??
            false;
        log("is following $isFollowing");
        log("is Opp.User following have currentuser ${(userData['following'] as List<dynamic>?)?.contains(currentUserId)}");
        log("is Opp.User followers have currentuser ${(userData['followers'] as List<dynamic>?)?.contains(currentUserId)}");
        UserModel user = UserModel.fromJson(userData);
        emit(UserUpdated(user,
            isVibeLink: isFollowing, isRequestSent: isRequestSent));
      } else {
        emit(UserError("User not found"));
      }
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> toggleFollow(String currentUserId, String targetUserId) async {
    try {
      // emit(UserLoading());
      String currentUsername=ApiService.me.username;
      DocumentReference currentUserRef =
          firestore.collection('users').doc(currentUserId);
      DocumentReference targetUserRef =
          firestore.collection('users').doc(targetUserId);

      DocumentSnapshot currentUserSnapshot = await currentUserRef.get();
      DocumentSnapshot targetUserSnapshot = await targetUserRef.get();

      Map<String, dynamic> currentUserData =
          currentUserSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> targetUserData =
          targetUserSnapshot.data() as Map<String, dynamic>;
      UserModel targetUser = UserModel.fromJson(targetUserSnapshot.data() as Map<String, dynamic>);
      List<dynamic> currentFollowing = currentUserData['following'] ?? [];
      List<dynamic> targetVibeRequests = targetUserData['followRequests'] ?? [];
      bool isTargetPrivate = targetUserData['isPrivate'] ?? false;

      if (currentFollowing.contains(targetUserId)) {
        // Remove connection if already linked
        await currentUserRef.update({
          'following': FieldValue.arrayRemove([targetUserId])
        });
        await targetUserRef.update({
          'followers': FieldValue.arrayRemove([currentUserId])
        });
        isFollowing = false;
      } else {
        if (isTargetPrivate) {
          if (targetVibeRequests.contains(currentUserId)) {

            await targetUserRef.update({
              'followRequests': FieldValue.arrayRemove([currentUserId])
            });
            isRequestSent = false;
          } else {

            await targetUserRef.update({
              'followRequests': FieldValue.arrayUnion([currentUserId])
            });
            isRequestSent = true;

             ApiService.sendPushNotification(
              targetUser,
              "$currentUsername requested to follow you.",
            );
          }
        } else {

          await currentUserRef.update({
            'following': FieldValue.arrayUnion(
                [targetUserId])
          });
          await targetUserRef.update({
            'followers': FieldValue.arrayUnion(
                [currentUserId])
          });

          isFollowing = true;

          ApiService.sendPushNotification(
            targetUser,
            "$currentUsername started following you.",
          );
        }
      }

      // Fetch updated user data
      DocumentSnapshot updatedUserSnapshot = await currentUserRef.get();
      DocumentSnapshot updatedTargetSnapshot = await targetUserRef.get();

      // Emit updated state
      emit(UserUpdated(
        UserModel.fromJson(updatedUserSnapshot.data() as Map<String, dynamic>),
      ));

      emit(UserUpdated(
        UserModel.fromJson(
            updatedTargetSnapshot.data() as Map<String, dynamic>),
      ));
    } catch (e) {
      log("Error toggling follow: $e");
      emit(UserError(e.toString()));
    }
  }
}

///for user 7
/* [log] is following false
[log] is Opp.User vibeLink have currentuser true
[log] is Opp.User vibes have currentuser false
[log] =======check isUserInVibe=====false
*/
/// for dev.17
/*  [log] is following true
[log] is Opp.User vibeLink have currentuser false
[log] is Opp.User vibes have currentuser true
[log] =======check isUserInVibe=====true
* */

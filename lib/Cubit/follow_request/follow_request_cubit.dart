import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vibez/api_service/api_service.dart';
import 'dart:developer';
import 'package:vibez/model/user_model.dart';

import 'follow_request_state.dart';

class FollowRequestCubit extends Cubit<FollowRequestState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  String currentUsername=ApiService.me.username;
  StreamSubscription? followRequestSubscription; // Change to StreamSubscription

  FollowRequestCubit() : super(FollowRequestInitial());

  void listenToFollowRequests() {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    followRequestSubscription = firestore.collection('users').doc(currentUserId).snapshots().listen((userSnapshot) async {
      if (userSnapshot.exists) {
        List<String> requestIds = List<String>.from(userSnapshot['followRequests'] ?? []);
        List<UserModel> requests = [];

        for (String userId in requestIds) {
          DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
          if (userDoc.exists) {
            requests.add(UserModel.fromJson(userDoc.data() as Map<String, dynamic>));
          }
        }

        emit(FollowRequestLoaded(requests));
      } else {
        emit(FollowRequestLoaded([]));
      }
    });
  }

  Future<void> acceptFollowRequest(String requesterId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference currentUserRef = firestore.collection('users').doc(currentUserId);
      DocumentReference requesterRef = firestore.collection('users').doc(requesterId);

      /// Fetch the latest user data before updating
      DocumentSnapshot currentUserSnapshot = await currentUserRef.get();
      DocumentSnapshot requesterSnapshot = await requesterRef.get();
      UserModel targetUser = UserModel.fromJson(requesterSnapshot.data() as Map<String, dynamic>);
      Map<String, dynamic> currentUserData = currentUserSnapshot.data() as Map<String, dynamic>;
      Map<String, dynamic> requesterData = requesterSnapshot.data() as Map<String, dynamic>;

      List<dynamic> currentFollowRequests = currentUserData['followRequests'] ?? [];

      if (currentFollowRequests.contains(requesterId)) {
        await currentUserRef.update({
          'followRequests': FieldValue.arrayRemove([requesterId]),
          'followers': FieldValue.arrayUnion([requesterId])
        });
        await requesterRef.update({
          'following': FieldValue.arrayUnion([currentUserId])
        });
      }

      // Fetch updated data to confirm changes
      DocumentSnapshot updatedUserSnapshot = await currentUserRef.get();
      DocumentSnapshot updatedRequesterSnapshot = await requesterRef.get();
      ApiService.sendPushNotification(
        targetUser,
        "$currentUsername accepted your follow request.",
      );
      log("Request accepted successfully!");
      log("Updated Current User followers: ${(updatedUserSnapshot.data() as Map<String, dynamic>)['followers']}");
      log("Updated Requester following: ${(updatedRequesterSnapshot.data() as Map<String, dynamic>)['following']}");

    } catch (e) {
      log("Error accepting request: $e");
    }
  }

  Future<void> rejectFollowRequest(String requesterId) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference currentUserRef = firestore.collection('users').doc(currentUserId);

      await currentUserRef.update({
        'followRequests': FieldValue.arrayRemove([requesterId])
      });
    } catch (e) {
      log("Error rejecting request: $e");
    }
  }

  @override
  Future<void> close() {
    followRequestSubscription?.cancel();
    return super.close();
  }
}


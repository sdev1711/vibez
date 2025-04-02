import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/user_model.dart';
part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {

  UserProfileCubit() : super(UserProfileInitial());

  Future<void> fetchUserProfile() async {
    try {
      emit(UserProfileLoading());


      String? userId = ApiService.user.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc = await ApiService.firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        emit(UserProfileError("User profile not found."));
        return;
      }

      UserModel user = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
      log("username from cubit ${user.username}");
      log("username from cubit ${user.name}");
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserProfileError("Failed to fetch user profile: $e"));
    }
  }
}

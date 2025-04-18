import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  UserModel? _user;

  AuthCubit() : super(AuthInitial());
  UserModel? get user => _user;

  Future<void> checkUserLoggedIn() async {
    try {
      emit(AuthLoading());
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        Get.offAllNamed(AppRoutes.loginScreen);
        return;
      }
      DocumentSnapshot snapshot =
          await fireStore.collection('users').doc(currentUser.uid).get();

      if (snapshot.exists) {
        UserModel userModel =
            UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
        emit(AuthAuthenticated(userModel));
        log("User Model: $userModel"); //Print full user model
      }
    } catch (e) {
      log("Error fetching user: $e");
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String username,
    required String name,
    required String email,
    required String password,
    required String createdAt,
  }) async {
    emit(AuthLoading());
    try {
      QuerySnapshot querySnapshot = await fireStore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar(
          "Username Taken",
          "The username '$username' is already in use. Please choose a different one.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.to.alertColor,
          colorText: AppColors.to.white,
        );
        emit(AuthError("Username already taken"));
        return;
      }
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await fireStore.collection("users").doc(user.uid).set({
          "username": username,
          "name": name,
          "email": email,
          "uid": user.uid,
          "about" : '',
          "createdAt" :createdAt,
          "lastActive" : '',
          "pushToken" : '',
          "image" : '',
          "is_online":false,
          "isPrivate":false,
          "followers":[],
          "following":[],
          "followRequests":[],
        });
        _user = UserModel(
          username: username,
          name: name,
          email: email,
          uid: user.uid,
          about: '',
          createdAt: '',
          lastActive: '',
          pushToken: '',
          image: '',
          isOnline: false,
          isPrivate:false,
          postCount: 0,
          userScore: 0,
          lastOpenedDate: '',
        );
        ApiService.getSelfInfo();
        emit(AuthAuthenticated(_user!));
        Get.offAllNamed(AppRoutes.mainScreen);
      } else {
        emit(AuthError("Signup failed"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      QuerySnapshot userQuery = await fireStore
          .collection("users")
          .where("username", isEqualTo: username)
          .get();
      if (userQuery.docs.isEmpty) {
        emit(AuthError("User not found"));
        return;
      }
      String email = userQuery.docs.first["email"];
      String name = userQuery.docs.first["name"];
      String uid = userQuery.docs.first["uid"];
      await auth.signInWithEmailAndPassword(email: email, password: password);
      ApiService.getSelfInfo();
      _user = UserModel(
        username: username,
        name: name,
        email: email,
        uid: uid,
        about: '',
        createdAt: '',
        lastActive: '',
        pushToken: '',
        image: '',
        isOnline: false,
        isPrivate: false,
        postCount: 0,
        userScore: 0,
        lastOpenedDate: '',
      );
      emit(AuthAuthenticated(_user!));
      log("hello is user $_user");
      Get.offAllNamed(AppRoutes.mainScreen);
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      ApiService.updateUserActiveStatus(false);
      await auth.signOut();
      _user = null;
      emit(AuthInitial());
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      emit(AuthError("Logout failed: ${e.toString()}"));
    }
  }

}

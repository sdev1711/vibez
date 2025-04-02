part of 'user_profile_cubit.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserModel user;
  UserProfileLoaded(this.user);
}

class UserProfileError extends UserProfileState {
  final String message;
  UserProfileError(this.message);
}

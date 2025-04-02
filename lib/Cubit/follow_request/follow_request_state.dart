import 'package:vibez/model/user_model.dart';

abstract class FollowRequestState {}

class FollowRequestInitial extends FollowRequestState {}

class FollowRequestLoading extends FollowRequestState {}

class FollowRequestLoaded extends FollowRequestState {
  final List<UserModel> requests;
  FollowRequestLoaded(this.requests);
}

class FollowRequestError extends FollowRequestState {
  final String error;
  FollowRequestError(this.error);
}

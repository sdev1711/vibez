import 'package:equatable/equatable.dart';
import 'package:vibez/model/user_model.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserUpdated extends UserState {
  final UserModel user;
  final bool isVibeLink;
  final bool isRequestSent;

  UserUpdated(this.user, {this.isVibeLink = false, this.isRequestSent = false});

  @override
  List<Object> get props => [user, isVibeLink, isRequestSent];
}



class UserError extends UserState {
  final String message;

  UserError(this.message);

  @override
  List<Object> get props => [message];
}

class UserStatusUpdated extends UserState {
  final bool isStatus;
  UserStatusUpdated(this.isStatus);

  @override
  List<Object> get props => [isStatus];
}

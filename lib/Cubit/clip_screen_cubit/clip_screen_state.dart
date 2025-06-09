import 'package:vibez/model/post_model.dart';
import 'package:video_player/video_player.dart';

abstract class ClipViewScreenState {}

class ClipViewInitial extends ClipViewScreenState {}

class ClipViewLoading extends ClipViewScreenState {}

class ClipViewLoaded extends ClipViewScreenState {
  final PostModel post;
  final VideoPlayerController controller;

  ClipViewLoaded({required this.post, required this.controller});
}

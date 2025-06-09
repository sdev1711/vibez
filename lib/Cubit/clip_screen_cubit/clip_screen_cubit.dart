import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibez/repository/post_repository.dart';
import 'package:video_player/video_player.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/post_model.dart';
import 'clip_screen_state.dart';

class ClipViewScreenCubit extends Cubit<ClipViewScreenState> {
  ClipViewScreenCubit() : super(ClipViewInitial());

  VideoPlayerController? controller;

  Future<void> loadClip(PostModel post) async {
    emit(ClipViewLoading());
    controller = VideoPlayerController.network(post.imageUrl);
    await controller!.initialize();
    controller!.setLooping(true);
    controller!.play();

    emit(ClipViewLoaded(post: post, controller: controller!));
  }

  Future<void> toggleLike(PostModel post, String currentUser) async {
    if (post.likes.contains(currentUser)) {
      await PostRepository().removeLike(post.postId, currentUser);
    } else {
      await PostRepository().addLike(post.postId, currentUser, post.user);
    }

    final updatedPost = await ApiService().getPostById(post.postId);
    emit(ClipViewLoaded(post: updatedPost, controller: controller!));
  }

  Future<void> refreshPost(PostModel post) async {
    final updatedPost = await ApiService().getPostById(post.postId
    );
    emit(ClipViewLoaded(post: updatedPost, controller: controller!));
  }

  @override
  Future<void> close() {
    controller?.dispose();
    return super.close();
  }
}

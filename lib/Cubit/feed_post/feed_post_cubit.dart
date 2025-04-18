import 'package:bloc/bloc.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/repository/post_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:vibez/model/post_model.dart';
part 'feed_post_state.dart';

class FeedPostCubit extends Cubit<FeedPostState> {
  final PostRepository postRepository;
  FeedPostCubit({required this.postRepository}) : super(FeedPostInitial());
  /// Fetch All Users Posts
  Future<void> fetchAllPosts() async {
    emit(FeedPostLoading());
    try {
      final posts = await postRepository.allPosts();
      final filteredPosts = <PostModel>[];
      for (var post in posts) {
        final user = await postRepository.getUserById(post.userId);
        if (user != null && !user.isPrivate) {
          filteredPosts.add(post);
        }
      }
      emit(FeedPostLoaded(posts: filteredPosts));
    } catch (e) {
      emit(FeedPostError(message: e.toString()));
    }
  }

  Future<void>fetchFollowingPosts()async{
    emit(FeedPostLoading());
    try{
      final followedUserIds = await postRepository.getFollowedUserIds();
      final posts = await postRepository.allPosts();
      final filteredPosts=<PostModel>[];
      String myUserId=ApiService.user.uid;
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      for(var post in posts ){
        if(followedUserIds.contains(post.userId)|| post.userId == myUserId){
          filteredPosts.add(post);
        }
      }

      emit(FollowingPostLoaded(posts: filteredPosts));
    }catch(e){
      emit(FeedPostError(message: e.toString()));
    }
  }
}
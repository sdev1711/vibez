import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/comment_model.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/repository/post_repository.dart';
part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository postRepository;

  PostCubit({required this.postRepository}) : super(PostInitial());

  // Fetch User Posts
  Future<void> fetchPosts() async {
    emit(PostLoading());
    try {
      final posts = await postRepository.getPosts();
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
// Fetch Other User Posts
  Future<void> fetchOtherUserPosts(String otherUserId) async {
    emit(PostLoading());
    try {
      final posts = await postRepository.otherUserPosts(otherUserId);
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
  // Add Post
  Future<void> addPost({required String content,required File imageUrl,required PostType postType}) async {
    try {
      await postRepository.createPost(content,imageUrl,postType);
      fetchPosts(); // Refresh posts
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  // Add Comment
  // Future<void> addComment(String postId, CommentModel comment) async {
  //   try {
  //     await postRepository.addComment(postId, comment);
  //     fetchPosts(); // Refresh posts
  //   } catch (e) {
  //     emit(PostError(message: e.toString()));
  //   }
  // }
  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      await postRepository.addComment(postId, comment);

      if (state is PostLoaded) {
        final currentState = state as PostLoaded;

        // Find the post to update
        final updatedPosts = currentState.posts.map((post) {
          if (post.postId == postId) {
            // ✅ Just update the post's existing comments list
            post.comments.add(comment);
          }
          return post;
        }).toList();

        emit(PostLoaded(posts: updatedPosts)); // Emit updated posts list
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  Future<void>addLike(String postId,String username,UserModel postUser)async {
    try{
    await postRepository.addLike(postId, username,postUser);
    if (state is PostLoaded) {
      final currentState = state as PostLoaded;

      final updatedPosts = currentState.posts.map((post) {
        if (post.postId == postId) {
          post.likes.add(username);
        }
        return post;
      }).toList();
      emit(PostLoaded(posts: updatedPosts));
    }
  }catch(e){
      emit(PostError(message: e.toString()));
    }
  }
  Future<void> removeLike(String postId, String username) async {
    try {
      await postRepository.removeLike(postId, username);
      if (state is PostLoaded) {
        final currentState = state as PostLoaded;

        final updatedPosts = currentState.posts.map((post) {
          if (post.postId == postId){
            post.likes.remove(username);
          }
          return post;
        }).toList();
        emit(PostLoaded(posts: updatedPosts));
      }
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }


  Stream<List<CommentModel>> streamComments(String postId) {
    return postRepository.getCommentsStream(postId);
  }
  Stream<List<String>> getPostLikes(String postId) {
    return ApiService.firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        return List<String>.from(snapshot.data()?['likes'] ?? []);
      } else {
        return [];
      }
    });
  }

}

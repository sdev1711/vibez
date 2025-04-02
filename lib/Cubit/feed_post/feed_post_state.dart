part of 'feed_post_cubit.dart';


abstract class FeedPostState extends Equatable {
  const FeedPostState();

  @override
  List<Object> get props => [];
}

class FeedPostInitial extends FeedPostState {}

class FeedPostLoading extends FeedPostState {}

class FeedPostLoaded extends FeedPostState {
  final List<PostModel> posts;

  const FeedPostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}
class FollowingPostLoaded extends FeedPostState {
  final List<PostModel> posts;

  const FollowingPostLoaded({required this.posts});

  @override
  List<Object> get props => [posts];
}

class FeedPostError extends FeedPostState {
  final String message;

  const FeedPostError({required this.message});

  @override
  List<Object> get props => [message];
}
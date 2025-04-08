import 'package:vibez/model/comment_model.dart';
import 'package:vibez/model/user_model.dart';

class PostModel {
  PostModel({
    required this.postId,
    required this.userId,
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
    required this.user,
    required this.postType,
  });

  late String postId;
  late String userId;
  late String content;
  late String imageUrl;
  late String timestamp;
  late List<String> likes;
  late List<CommentModel> comments;
  late UserModel user;
  late final PostType postType;

  // Convert JSON to PostModel
  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'] ?? '';
    userId = json['userId'] ?? '';
    content = json['content'] ?? '';
    imageUrl = json['imageUrl'] ?? '';
    timestamp = json['timestamp'] ?? '';
    likes = List<String>.from(json['likes'] ?? []);
    comments = (json['comments'] as List<dynamic>?)
        ?.map((comment) => CommentModel.fromJson(comment))
        .toList() ??
        [];
    user = json['user'] != null
        ? UserModel.fromJson(json['user'])
        : UserModel(
      image: "image",
      about: "about",
      name: "name",
      createdAt: "createdAt",
      isOnline: false,
      uid: "uid",
      lastActive: "lastActive",
      email: "email",
      pushToken: "pushToken",
      username: "username",
      isPrivate: false,
      postCount: 0,
      userScore: 0,
      lastOpenedDate: '',
    );

    postType = PostType.values.firstWhere(
          (e) => e.name == json['postType'], // Match with stored string
      orElse: () => PostType.image, // Default value if not found
    );
  }

  // Convert PostModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'user': user.toJson(),
      'postType': postType.name,
    };
  }
}

enum PostType { image, video }

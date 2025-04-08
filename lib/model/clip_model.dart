import 'package:vibez/model/user_model.dart';
import 'comment_model.dart';

class ClipModel{
  ClipModel({
    required this.postId,
    required this.userId,
    required this.caption,
    required this.videoUrl,
    required this.timestamp,
    this.likes = const [],
    this.comments = const [],
    required this.user,
  });

  late String postId;
  late String userId;
  late String caption;
  late String videoUrl;
  late String timestamp;
  late List<String> likes;
  late List<CommentModel> comments;
  late UserModel user;

  // Convert JSON to ClipModel
  ClipModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'] ?? '';
    userId = json['userId'] ?? '';
    caption = json['caption'] ?? '';
    videoUrl = json['videoUrl'] ?? '';
    timestamp = json['timestamp'] ?? '';
    likes = List<String>.from(json['likes'] ?? []);
    comments = (json['comments'] as List<dynamic>?)
        ?.map((comment) => CommentModel.fromJson(comment))
        .toList() ??
        [];
    user = json['user'] != null ? UserModel.fromJson(json['user']) : UserModel(
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
  }

  // Convert ClipModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'caption': caption,
      'videoUrl': videoUrl,
      'timestamp': timestamp,
      'likes': likes,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'user':user.toJson(),
    };
  }
}
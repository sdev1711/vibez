class CommentModel {
  CommentModel({
    required this.commentId,
    required this.userId,
    required this.text,
    required this.timestamp,
    required this.profileImage,
  });

  late String commentId;
  late String userId;
  late String text;
  late String timestamp;
  late String profileImage;

  // Convert JSON to CommentModel
  CommentModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'] ?? '';
    userId = json['userId'] ?? '';
    text = json['text'] ?? '';
    timestamp = json['timestamp'] ?? '';
    profileImage = json['profileImage'] ?? '';
  }

  // Convert CommentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'userId': userId,
      'text': text,
      'timestamp': timestamp,
      'profileImage': profileImage,
    };
  }
}

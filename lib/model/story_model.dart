  class StoryModel {
    final String storyId;
    final String userId;
    final String mediaUrl;
    final String? caption;
    final List<String> viewedBy;
    final int timestamp;

    StoryModel({
      required this.storyId,
      required this.userId,
      required this.mediaUrl,
      this.caption,
      required this.viewedBy,
      required this.timestamp,
    });

    /// Convert to Map for Firestore
    Map<String, dynamic> toJson() {
      return {
        'storyId': storyId,
        'userId': userId,
        'mediaUrl': mediaUrl,
        'caption': caption,
        'viewedBy': viewedBy,
        'timestamp': timestamp,
      };
    }

    /// Convert Firestore document to StoryModel
    factory StoryModel.fromJson(Map<String, dynamic> json) {
      return StoryModel(
        storyId: json['storyId'] ?? '',
        userId: json['userId'] ?? '',
        mediaUrl: json['mediaUrl'] ?? '',
        caption: json['caption'],
        viewedBy: List<String>.from(json['viewedBy'] ?? []),
        timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      );
    }
  }
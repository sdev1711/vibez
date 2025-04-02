class UserModel {
  UserModel({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.uid,
    required this.lastActive,
    required this.email,
    required this.pushToken,
    required this.username,
    required this.isPrivate,
    required this.postCount,
    this.followers = const [],
    this.following = const [],
    this.followRequests = const [],
  });

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String uid;
  late String lastActive;
  late String email;
  late String pushToken;
  late String username;
  late bool isPrivate;
  late int postCount;
  late List<String> followers;
  late List<String> following;
  late List<String> followRequests;

  UserModel.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    uid = json['uid'] ?? '';
    lastActive = json['lastActive'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['pushToken'] ?? '';
    username = json['username'] ?? '';
    postCount =json['postCount'] != null ? json['postCount'] as int : 0;
    isPrivate = json['isPrivate'] ?? false;
    followers = List<String>.from(json['followers'] ?? []);
    following = List<String>.from(json['following'] ?? []);
    followRequests = List<String>.from(json['followRequests'] ?? []);
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'created_at': createdAt,
      'is_online': isOnline,
      'uid': uid,
      'lastActive': lastActive,
      'email': email,
      'pushToken': pushToken,
      'username': username,
      'isPrivate': isPrivate,
      'followers': followers,
      'following': following,
      'followRequests': followRequests,
      'postCount':postCount,
    };
  }
}

import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/story_model.dart';
import 'package:vibez/model/user_model.dart';

class StoryService {
  static Future<String> uploadMediaToFirebase(XFile media) async {
    File file = File(media.path);
    String fileName =
        "stories/${ApiService.user.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference ref = FirebaseStorage.instance.ref().child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  static Future<void> uploadStory(String mediaUrl, {String? caption}) async {
    String userId = ApiService.user.uid;

    String docId = ApiService.firestore.collection('stories').doc().id;
    log("doc id is ======$docId");
    StoryModel story = StoryModel(
      storyId: docId, // Use the same docId as storyId
      userId: userId,
      mediaUrl: mediaUrl,
      caption: caption ?? "",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      viewedBy: [],
    );
    log("story id is ======${story.storyId}");

    await ApiService.firestore
        .collection('stories')
        .doc(docId)
        .set(story.toJson());
  }


  Future<void> markStoryAsViewed(String storyId) async {
    String userId = ApiService.user.uid;

    await ApiService.firestore.collection('stories').doc(storyId).update({
      'viewedBy': FieldValue.arrayUnion([userId]),
    });
  }

  Future<void> deleteExpiredStories() async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final expirationTime = now - (24 * 60 * 60 * 1000); // 24 hours ago

    QuerySnapshot snapshot = await ApiService.firestore
        .collection('stories')
        .where('timestamp', isLessThan: expirationTime)
        .get();

    for (var doc in snapshot.docs) {
      await ApiService.firestore.collection('stories').doc(doc.id).delete();
      log("Deleted expired story: ${doc.id}");
    }
  }
  Future<UserModel> fetchUserDetails(String userId) async {
    DocumentSnapshot userDoc = await ApiService.firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } else {
      throw Exception("User not found");
    }
  }

}

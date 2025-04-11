import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/comment_model.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';

class PostRepository {
  ApiService apiService = ApiService();
  // Get current user's ID
  String getCurrentUserId() {
    return ApiService.user.uid;
  }

  // Fetch User Posts from Firestore
  Future<List<PostModel>> getPosts() async {
    String? userId = ApiService.user.uid;
    try {
      QuerySnapshot querySnapshot = await ApiService.firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get(); // No orderBy here

      List<PostModel> posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort manually by timestamp
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return posts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }
  //Fetch Other user posts
  Future<List<PostModel>> otherUserPosts(String userId) async {
    try {
      QuerySnapshot querySnapshot = await ApiService.firestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get(); // No orderBy here

      List<PostModel> posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Sort manually by timestamp
      posts.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      return posts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }
  // Fetch All Posts from Firestore
  Future<List<PostModel>> allPosts() async {
    try {
      QuerySnapshot querySnapshot =
          await ApiService.firestore.collection('posts').get();

      List<PostModel> posts = querySnapshot.docs
          .map((doc) => PostModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      return posts;
    } catch (e) {
      throw Exception("Failed to fetch posts: $e");
    }
  }
  // Create a new post (Automatically sets userId)
  Future<void> createPost(String content, File imageFile,PostType postType) async {
    try {
      log("hello from repository function start");
      String userId = getCurrentUserId();
      if (userId.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      // Generate a unique post ID
      String postId = ApiService.firestore.collection('posts').doc().id;
      log("Generated post ID: $postId");
      // Upload image to Firebase Storage
      String imageUrl = await uploadImageToStorage(imageFile, postId);
      log("Image uploaded: $imageUrl");
      // Ensure image URL is valid
      if (imageUrl.isEmpty) {
        throw Exception("Image upload failed. No URL received.");
      }
      // Create PostModel with userId
      PostModel post = PostModel(
        postId: postId,
        userId: userId,
        content: content,
        imageUrl: imageUrl, // Use the uploaded image URL
        timestamp: DateTime.now().toIso8601String(),
        likes: [],
        comments: [],
        user: ApiService.me,
        postType: postType,
      );
      log("Post JSON: ${post.toJson()}");
      // Save post details in Firestore
      await ApiService.firestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson());
      log("Post successfully added to Firestore!");
      Get.snackbar("Success", "Successfully posted!",
            backgroundColor: Colors.green, colorText: Colors.white);
      DocumentReference userRef = ApiService.firestore.collection('users').doc(userId);
      await userRef.update({
        'postCount': FieldValue.increment(1),
      }).then((_) {
        log("User's postCount successfully incremented!");
      }).catchError((error) {
        log("Error updating postCount: $error");
      });
    } catch (e) {
      log("Failed to create post: $e");
    }
  }
  Future<String> uploadImageToStorage(File imageFile, String postId) async {
    try {
      // Define storage path
      Reference storageRef =
          FirebaseStorage.instance.ref().child("post_images/$postId.jpg");

      // Upload file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
  // Add a comment to a post
  Future<void> addComment(String postId, CommentModel comment) async {
    try {
      await ApiService.firestore.collection('posts').doc(postId).update({
        'comments': FieldValue.arrayUnion([comment.toJson()])
      });
    } catch (e) {
      throw Exception("Failed to add comment: $e");
    }
  }
  //Delete a comment
  Future<void> deleteComment(String postId,CommentModel comment)async{
    try{
      await ApiService.firestore.collection('posts').doc(postId).update({
        'comments':FieldValue.arrayRemove([comment.toJson()])
      });
    }catch(e){
      throw Exception("Failed to delete comment: $e");
    }
  }
  //Add a like to a post
  Future<void> addLike(String postId, String username,UserModel postUser) async {
    try {
      await ApiService.firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([username])
      });
      ApiService.sendPushNotification(
        postUser,
        "$username liked your post.",
      );
    } catch (e) {
      throw Exception("Failed to like: $e");
    }
  }
  // Remove a like from a post
  Future<void> removeLike(String postId, String username) async {
    try {
      await ApiService.firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([username])
      });
    } catch (e) {
      throw Exception("Failed to remove like: $e");
    }
  }
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc =
          await ApiService.firestore.collection('users').doc(userId).get();

      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      log("Error fetching user: $e");
    }
    return null; // Return null if user is not found
  }
  Future<List<String>> getFollowedUserIds() async {
    final user = await apiService.getCurrentUser(); // Get current user data
    return user?.following ?? []; // Return the list of followed user IDs
  }
  // Stream comments for a specific post
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return ApiService.firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null || !data.containsKey('comments')) {
        return [];
      }
      return (data['comments'] as List)
          .map((json) => CommentModel.fromJson(json))
          .toList();
    });
  }
}

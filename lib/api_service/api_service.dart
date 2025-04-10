import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vibez/model/message_model.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'access_firebase_token.dart';

class ApiService {
  /// authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  /// access database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// access firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  /// current user
  static User get user => auth.currentUser!;

  /// access firebase messaging
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  /// store self information
  static late UserModel me;

  /// for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        //for setting user status to active
        ApiService.updateUserActiveStatus(true);
        // log('My Data: ${user.data()}');
      }
    });
  }

  /// for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return firestore.collection('users').snapshots();
  }

  /// get conversation id
    static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
        ? '${user.uid}_$id'
        : '${id}_${user.uid}';

  /// get all messages of specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(UserModel chatUser){
    return firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(UserModel chatUser, String msg, Type type) async {
    /// sending time of msg
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    /// msg to send
    final MessageModel message = MessageModel(
      toId: chatUser.uid,
      fromId: user.uid,
      msg: msg,
      read: "",
      type: type,
      sent: time,
    );

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.uid)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  /// for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(UserModel chatUser, String msg) async {
    try {
      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me.name, //our name should be send
            "body": msg,
          },
        }
      };

      /// Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'sign-up-lxh8y8';

      /// get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      /// handle null token
      if (bearerToken == null) return;

      var res = await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  /// to update user read data
  static Future<void> updateMessageReadStatus(MessageModel message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<Map<String, MessageModel>> getAllLastMessagesStream(List<UserModel> users) {
    List<Stream<Map<String, MessageModel>>> streams = users.map((user) {
      return firestore
          .collection('chats/${getConversationID(user.uid)}/messages/')
          .orderBy('sent', descending: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        Map<String, MessageModel> lastMessages = {};

        if (snapshot.docs.isNotEmpty) {
          MessageModel msg = MessageModel.fromJson(snapshot.docs.first.data());
          lastMessages[user.uid] = msg;
        }

        return lastMessages;
      });
    }).toList();

    return Rx.combineLatestList(streams).map((list) {
      Map<String, MessageModel> combinedMap = {};
      for (var map in list) {
        combinedMap.addAll(map);
      }
      return combinedMap;
    });
  }


  static Future<void> sendChatImage(UserModel user, File file) async {
    /// getting image file extension
    final ext = file.path.split('.').last;

    /// storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        'images/${getConversationID(user.uid)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    /// uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    /// updating image in firestore database
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(user, imageUrl, Type.image);
  }

  ///  get specific user info
  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel user) {
    return firestore
        .collection('users')
        .doc(user.uid)
        .snapshots();
  }

  /// update user active or not active status
  static Future<void> updateUserActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'lastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      'pushToken': me.pushToken,
    });
    log("user active status : $isOnline");
    // log("=======me pushToken==========${me.pushToken}");
  }

  /// get firebase msg token
  static Future<void> getFirebaseMessagingToken() async {
    await firebaseMessaging.requestPermission();

    await firebaseMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log("push token from get messagingToken======$t");
      }
    });
  }

  /// delete message
  static Future<void> deleteMsg(MessageModel message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }
  /// update message
  static Future<void> updateMessage(MessageModel message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }


  /// update caption
  static Future<void> updateCaption(PostModel post, String updatedCaption) async {
    await firestore
        .collection('posts')
        .doc(post.postId)
        .update({'content': updatedCaption});
  }
  /// list of all followers
  static Stream<UserModel> getUserStream(String userId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) => UserModel.fromJson(snapshot.data() as Map<String, dynamic>));
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) return null;

      return UserModel.fromJson(userDoc.data()!);
    } catch (e) {
      throw Exception("Error fetching current user: $e");
    }
  }
  Future<void> removeFollower(String userId) async {
    String currentUserId= ApiService.user.uid;
    try {
      // Reference to the current user's followers list
      DocumentReference userDoc =firestore.collection('users').doc(currentUserId);

      await userDoc.update({
        "followers": FieldValue.arrayRemove([userId])
      });

      log("Follower removed successfully");
    } catch (e) {
      log("Error removing follower: $e");
    }
  }
  // Future<UserModel?> getUserById(String userId) async {
  //   try {
  //     final doc =
  //     await firestore.collection('users').doc(userId).get();
  //
  //     if (doc.exists) {
  //       return UserModel.fromJson(doc.data()!);
  //     }
  //   } catch (e) {
  //     log("Error fetching user: $e");
  //   }
  //   return null; // Return null if user is not found
  // }

}

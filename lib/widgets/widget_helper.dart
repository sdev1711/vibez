import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:math';

import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_text.dart';

/// Widget for displaying error messages.
Widget errorText(String message) {
  return Center(
    child: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
  );
}

/// Fetches followers data using Firestore streams in batches.
Widget buildFollowersList(List<String> followerIds, String name) {
  List<List<String>> chunkedFollowerIds = chunkList(followerIds, 10);

  Stream<List<QueryDocumentSnapshot>> mergedStream = CombineLatestStream.list(
    chunkedFollowerIds.map((chunk) {
      return ApiService.firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }).toList(),
  ).map((listOfDocs) => listOfDocs.expand((docs) => docs).toList());

  return StreamBuilder<List<QueryDocumentSnapshot>>(
    stream: mergedStream,
    builder: (context, followersSnapshot) {
      if (followersSnapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      if (!followersSnapshot.hasData || followersSnapshot.data!.isEmpty) {
        return errorText("No $name found");
      }

      List<UserModel> followers = followersSnapshot.data!
          .map(
            (doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();

      return ListView.builder(
        shrinkWrap: true,
        itemCount: followers.length,
        itemBuilder: (context, index) => buildFollowerTile(followers[index]),
      );
    },
  );
}

/// Builds a single follower tile.
Widget buildFollowerTile(UserModel follower) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
    child: GestureDetector(
      onTap: (){
        Get.toNamed(AppRoutes.otherUserProfileScreen,arguments: follower);
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 30,
              backgroundImage: follower.image.isNotEmpty
                  ? NetworkImage(follower.image)
                  : AssetImage(ImagePath.profileIcon),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonSoraText(
                text: follower.username,
                color: AppColors.to.contrastThemeColor,
                textSize: 15,
              ),
              CommonSoraText(
                text: follower.name,
                color: AppColors.to.contrastThemeColor.withOpacity(0.6),
                textSize: 14,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// Helper function to split a list into chunks.
List<List<String>> chunkList(List<String> list, int chunkSize) {
  List<List<String>> chunks = [];
  for (int i = 0; i < list.length; i += chunkSize) {
    chunks.add(list.sublist(i, min(i + chunkSize, list.length)));
  }
  return chunks;
}

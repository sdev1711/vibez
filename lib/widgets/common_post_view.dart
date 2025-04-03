import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/widgets/post_card.dart';


class CommonPostView extends StatelessWidget {
  const CommonPostView({
    super.key,
    required this.postsData,
  });

  final PostModel postsData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(postsData.userId) // Fetch latest user data using userId
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            color: AppColors.to.darkBgColor,
          ),
          );
        }

        var userData = snapshot.data!.data() as Map<String, dynamic>;
        UserModel userDetails = UserModel.fromJson(userData);
        String username = userDetails.username;
        String profilePic = userDetails.image;

        return PostCard(
            postsData: postsData,
            userDetails: userDetails,
            profilePic: profilePic,
            username: username,
            userData: userData);
      },
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/widgets/post_card.dart';


class CommonPostView extends StatefulWidget {
  final PostModel postsData;
  const CommonPostView({super.key, required this.postsData});

  @override
  State<CommonPostView> createState() => _CommonPostViewState();
}

class _CommonPostViewState extends State<CommonPostView>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Prevents widget destruction

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required to keep the state alive

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.postsData.userId)
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
          postsData: widget.postsData,
          userDetails: userDetails,
          profilePic: profilePic,
          username: username,
          userData: userData,
        );
      },
    );
  }
}



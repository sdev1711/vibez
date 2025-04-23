import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/post/comment/comment_screen.dart';

Future<dynamic> commentBottomShit(BuildContext context,PostModel postData,UserModel userData) {
  return Get.bottomSheet(
    Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: BoxDecoration(
        color: AppColors.to.darkBgColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: CommentScreen(
        postData: postData,
        userData: userData,
      ),
    ),
    isScrollControlled: true,
  );
}
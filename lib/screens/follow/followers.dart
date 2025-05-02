import 'dart:developer';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/widget_helper.dart';

class Followers extends StatefulWidget {
  const Followers({super.key});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  late String userId;
  @override
  void initState() {
    userId=Get.arguments;
    debugPrint(userId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          text: LocaleKeys.followers.tr,
          color: AppColors.to.contrastThemeColor,
          textSize: 15.sp,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded,
              color: AppColors.to.contrastThemeColor),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          StreamBuilder<DocumentSnapshot>(
            stream: ApiService.firestore.collection('users').doc(userId).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return errorText("Error: ${snapshot.error}");
              }
              if (!snapshot.hasData || snapshot.data?.data() == null) {
                return errorText("No data found");
              }

              Map<String, dynamic>? userData = snapshot.data!.data() as Map<String, dynamic>?;
              List<String> followerIds = List<String>.from(userData?['followers'] ?? []);

              if (followerIds.isEmpty) {
                return errorText("No followers found");
              }

              return buildFollowersList(followerIds,"followers");
            },
          ),
        ],
      ),
    );
  }
}

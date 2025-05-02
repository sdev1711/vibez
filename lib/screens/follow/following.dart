import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/widget_helper.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  String? userId;
  @override
  void initState() {
    userId=Get.arguments;
    log(userId??"");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          text: LocaleKeys.following.tr,
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
              List<String> followerIds = List<String>.from(userData?['following'] ?? []);

              if (followerIds.isEmpty) {
                return errorText("No following found");
              }

              return buildFollowersList(followerIds,"following");
            },
          ),
        ],
      ),
    );
  }
}

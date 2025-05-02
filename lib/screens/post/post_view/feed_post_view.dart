import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_post_view.dart';
import 'package:vibez/widgets/common_text.dart';

class FeedPostView extends StatefulWidget {
  const FeedPostView({super.key});

  @override
  State<FeedPostView> createState() => _FeedPostViewState();
}

class _FeedPostViewState extends State<FeedPostView> {
  late PostModel postData;
  @override
  void initState() {
    postData=Get.arguments;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 15.sp,
            text: "Feed Post", color: AppColors.to.contrastThemeColor),
        leading: CommonIconButton(
          onTap: () {
            Navigator.of(context).pop();
            context.read<PostCubit>().fetchPosts();
          },
          iconData: Icons.arrow_back_rounded, size: 25,color: AppColors.to.contrastThemeColor,
        ),
      ),
      body: CommonPostView(
          postsData: postData,
      ),
    );
  }
}


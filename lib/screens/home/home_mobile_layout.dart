import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/database/shared_preference.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_post_view.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/story_view_widget.dart';
import 'package:vibez/widgets/suggested_user_widget.dart';

class HomeMobileLayout extends StatefulWidget {
  const HomeMobileLayout({super.key});

  @override
  State<HomeMobileLayout> createState() => _HomeMobileLayoutState();
}

class _HomeMobileLayoutState extends State<HomeMobileLayout> {

  late List<PostModel> postsData;
   UserModel? me;

  @override
  void initState() {
    ApiService.getSelfInfo();
    getCurrentUserData();
    context.read<FeedPostCubit>().fetchFollowingPosts();
    context.read<PostCubit>().fetchPosts();
    super.initState();
  }
Future<void> getCurrentUserData()async{
  String? userDataString = SharedPrefs.getUserData();
  log("userDataString is $userDataString");
  if (userDataString != null) {
    Map<String, dynamic> userMap = jsonDecode(userDataString);
    me = UserModel.fromJson(userMap);
    log("following============ ${me?.following}");
  }
  else{
    log("User data is null");
  }
}
  @override
  Widget build(BuildContext context) {
    log("following============ ${me?.following}");
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonTitle(
          text: LocaleKeys.vibez.tr,
          gradientColors: [AppColors.to.titleLightColor,AppColors.to.titleDarkColor],
          textSize: 25.sp,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.messageScreen);
              },
              child: Container(
                color: Colors.transparent,
                width: 40.w,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ImageIcon(
                    AssetImage(ImagePath.messageIcon),
                    color: AppColors.to.contrastThemeColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.to.contrastThemeColor,
        onRefresh: _refreshHome,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              StoryViewWidget(),
              if (me?.following.isEmpty??false) ...[
                Column(
                  children: [
                    SuggestedUserWidget(),
                    CommonSoraText(
                      text: "Follow people\nfor content",
                      textSize: 15.sp,
                      color: AppColors.to.contrastThemeColor,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
              BlocBuilder<FeedPostCubit, FeedPostState>(
                builder: (context, state) {
                  if (state is FeedPostLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.to.contrastThemeColor,
                      ),
                    );
                  } else if (state is FollowingPostLoaded) {
                    postsData = state.posts;
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: postsData.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 5) {
                          return SuggestedUserWidget();
                        }
                        final postIndex = index > 5 ? index - 1 : index;
                        if (postIndex >= postsData.length) return SizedBox();
                        final postData = postsData[postIndex];
                        return CommonPostView(postsData: postData);
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshHome() async {
    await context
        .read<FeedPostCubit>()
        .fetchFollowingPosts();
    ApiService.getSelfInfo();
    getCurrentUserData();
    if(!mounted)return;
    await context.read<PostCubit>().fetchPosts();
  }
}
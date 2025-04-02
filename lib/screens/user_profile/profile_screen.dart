import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/language_controller.dart';
import 'package:vibez/drawer/profile_screen_drawer.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/screens/post/user_posts/user_videos.dart';
import 'package:vibez/screens/post/user_posts/users_posts.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:share_plus/share_plus.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  late ScrollController scrollController;
  final LanguageController languageController = Get.put(LanguageController());
  void shareProfile(String name, String userName) {
    final String shareText =
        "Check out my profile on MyApp! 👇\n\nName: $name\nUsername: $userName\n Profile: https://vibez.com/profile?id=${ApiService.user.uid}";
    Share.share(shareText);
  }

  @override
  void initState() {
    ApiService.getSelfInfo();
    tabController = TabController(length: 2, vsync: this);
    scrollController = ScrollController();
    context.read<UserProfileCubit>().fetchUserProfile();
    context.read<PostCubit>().fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      body: BlocBuilder<UserProfileCubit, UserProfileState>(
        builder: (context, state) {
          if (state is UserProfileLoaded) {
            return NestedScrollView(
              controller: scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 75.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                            color: AppColors.to.darkBgColor,
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CommonSoraText(
                                  text: state.user.username,
                                  color: AppColors.to.contrastThemeColor,
                                  textSize: 23,
                                ),
                                Builder(
                                  builder: (context) => CommonIconButton(
                                    onTap: () {
                                      Scaffold.of(context).openEndDrawer();
                                    },
                                    iconData: Icons.menu,
                                    color: AppColors.to.contrastThemeColor,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          color: AppColors.to.darkBgColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 70.w,
                                    height: 80.h,
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 37,
                                          backgroundColor: AppColors.to.contrastThemeColor,
                                          backgroundImage: state.user.image.isEmpty
                                              ? AssetImage(ImagePath.profileIcon)
                                              :  CachedNetworkImageProvider(state.user.image),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 10,
                                          child: CommonIconButton(
                                            onTap:(){
                                              Get.toNamed(AppRoutes.storyUploadScreen);
                                            },
                                            iconData: Icons.add_circle,
                                            size: 25,
                                            color: AppColors.to.contrastThemeColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 30.w),
                                  Row(
                                    spacing: 25.w,
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.followersScreen,
                                              arguments: state.user.uid);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              CommonSoraText(
                                                text: state.user.followers.length.toString(),
                                                color: AppColors.to.contrastThemeColor,
                                                textSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              CommonSoraText(
                                                text: LocaleKeys.followers.tr,
                                                color: AppColors.to.contrastThemeColor,
                                                textSize: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.toNamed(AppRoutes.followingScreen,
                                              arguments: state.user.uid);
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          child: Column(
                                            children: [
                                              CommonSoraText(
                                                text: state.user.following.length.toString(),
                                                color: AppColors.to.contrastThemeColor,
                                                textSize: 17,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              CommonSoraText(
                                                text: LocaleKeys.following.tr,
                                                color: AppColors.to.contrastThemeColor,
                                                textSize: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              CommonSoraText(
                                text: state.user.name,
                                color: AppColors.to.contrastThemeColor,
                                textSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              CommonSoraText(
                                text: state.user.about,
                                color: AppColors.to.contrastThemeColor,
                                textSize: 15,
                              ),
                              SizedBox(height: 30.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(AppRoutes.editProfileScreen,
                                          arguments: state.user);
                                    },
                                    child: Container(
                                      height: 30.h,
                                      width: 150.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.to.contrastThemeColor
                                        ,width: 2),
                                      ),
                                      child: Center(
                                        child: CommonSoraText(
                                          text: LocaleKeys.editProfile.tr,
                                          color: AppColors.to.contrastThemeColor,
                                          // fontWeight: FontWeight.w500,
                                          textSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      shareProfile(state.user.name, state.user.username);
                                    },
                                    child: Container(
                                      height: 30.h,
                                      width: 150.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: AppColors.to.contrastThemeColor
                                            ,width: 2),
                                      ),
                                      child: Center(
                                        child: CommonSoraText(
                                          text: LocaleKeys.shareProfile.tr,
                                          color: AppColors.to.contrastThemeColor,

                                          textSize: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      controller: tabController,
                      labelColor: AppColors.to.contrastThemeColor,
                      labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                      unselectedLabelColor: AppColors.to.contrastThemeColor,
                      indicatorColor: AppColors.to.contrastThemeColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: [
                        Tab(
                          child: CommonSoraText(
                            text: "Posts (${state.user.postCount})",
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15,
                          ),
                        ),
                        Tab(
                          child: CommonSoraText(
                            text: "Clips",
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15,
                          ),
                        ),
                      ],
                    ),
                    context,
                  ),
                ),
              ],
              body: TabBarView(
                controller: tabController,
                children: [
                  UsersPosts(),
                  UserVideos(),
                ],
              ),
            );
          } else if (state is UserProfileLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.to.contrastThemeColor,
            ));
          }
          return CommonSoraText(
            text: LocaleKeys.errorTryAgain.tr,
            color: AppColors.to.contrastThemeColor,
            textSize: 16,
          );
        },
      ),
      endDrawer: ProfileDrawer(
        languageController: languageController,
        context: context,
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.context);

  final TabBar _tabBar;
  final BuildContext context;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.to.darkBgColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

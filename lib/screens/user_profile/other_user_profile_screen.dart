import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user/user_cubit.dart';
import 'package:vibez/Cubit/user/user_state.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/bottom_navigation_controller.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/post/user_posts/user_videos.dart';
import 'package:vibez/screens/post/user_posts/users_posts.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/zoom_image.dart';

class OtherUserProfileScreen extends StatefulWidget {
  const OtherUserProfileScreen({super.key});

  @override
  State<OtherUserProfileScreen> createState() => _OtherUserProfileScreenState();
}

class _OtherUserProfileScreenState extends State<OtherUserProfileScreen>
    with TickerProviderStateMixin {

  late UserModel userData;
  late String currentUserId;
  OverlayEntry? _overlayEntry;
  late TabController tabController;
  late PageController pageController;
  final GlobalKey _attachmentButtonKey = GlobalKey();
  late ScrollController scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    userData = Get.arguments;
    currentUserId = ApiService.user.uid;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userData.uid == currentUserId) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        Get.find<BottomNavController>().changeIndex(4);
      }
    });
    context.read<UserCubit>().fetchChatUserProfile(userData.uid, currentUserId);
    context.read<PostCubit>().fetchOtherUserPosts(userData.uid);
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController();
    tabController.addListener(() {
      if (!pageController.position.isScrollingNotifier.value) {
        pageController.jumpToPage(tabController.index);
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    pageController.dispose();
    super.dispose();
  }

  void sharePost(String name, String userName) {
    final String shareText =
        "Check out my profile on Vibez! 👇\n Profile: $name\nUsername: $userName\n App: vibez.app";
    Share.share(shareText);
  }

  void _toggleAttachmentOptions(BuildContext context, GlobalKey key) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
    renderBox.localToGlobal(Offset.zero); // Button position

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 5,
          top: MediaQuery.of(context).viewInsets.top + 80.h, // Above keyboard
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 150.w,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.to.darkBgColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20.h,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                        Get.toNamed(AppRoutes.chatScreen, arguments: userData);
                      },
                      child: CommonSoraText(
                        text: LocaleKeys.sendChat.tr,
                        color: AppColors.to.contrastThemeColor,
                        textSize: 15,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                      },
                      child: CommonSoraText(
                        text: LocaleKeys.block.tr,
                        color: AppColors.to.contrastThemeColor,
                        textSize: 15,
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: () async {
                    //     _removeOverlay();
                    //   },
                    //   child: CommonSoraText(
                    //     text: LocaleKeys.report.tr,
                    //     color: AppColors.to.contrastThemeColor,
                    //     textSize: 15,
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        _removeOverlay();
                        sharePost(userData.name, userData.username);
                      },
                      child: CommonSoraText(
                        text: LocaleKeys.share.tr,
                        color: AppColors.to.contrastThemeColor,
                        textSize: 15,
                      ),
                    ),
                    BlocBuilder<UserCubit, UserState>(
                      buildWhen: (previous, current) => current is UserUpdated,
                      builder: (context, state) {
                        bool isFollow = context
                            .watch<UserCubit>()
                            .isFollowing; // Get the updated follow state
                        bool isFollowRequest =
                            context.watch<UserCubit>().isRequestSent;
                        if (state is UserUpdated) {
                          return GestureDetector(
                            onTap: () async {
                              _removeOverlay();
                              context
                                  .read<UserCubit>()
                                  .toggleFollow(currentUserId, state.user.uid);
                              context
                                  .read<FeedPostCubit>()
                                  .fetchFollowingPosts();
                            },
                            child: CommonSoraText(
                              text: isFollow
                                  ? LocaleKeys.unfollow.tr
                                  : (isFollowRequest
                                      ? LocaleKeys.cancelRequest.tr
                                      : LocaleKeys.follow.tr),
                              color: AppColors.to.contrastThemeColor,
                              textSize: 15,
                            ),
                          );
                        }
                        return Container();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);
    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (previous, current) => current is UserUpdated,
      builder: (context, state) {
        bool isFollow = context
            .watch<UserCubit>()
            .isFollowing; // Get the updated follow state
        bool isFollowRequest = context.watch<UserCubit>().isRequestSent;
        if (state is UserUpdated) {
          return GestureDetector(
            onTap: () {
              _removeOverlay();
            },
            child: Scaffold(
              appBar: CommonAppBar(
                title: CommonSoraText(
                  text: state.user.username,
                  color: AppColors.to.contrastThemeColor,
                  textSize: 20,
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<PostCubit>().fetchPosts();
                  },
                  icon: Icon(Icons.arrow_back_rounded,
                      color: AppColors.to.contrastThemeColor),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: CommonIconButton(
                      key: _attachmentButtonKey,
                      onTap: () {
                        _toggleAttachmentOptions(context, _attachmentButtonKey);
                      },
                      iconData: Icons.more_vert_rounded,
                      color: AppColors.to.contrastThemeColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.to.darkBgColor,
              body: WillPopScope(
                onWillPop: ()async{
                  context.read<PostCubit>().fetchPosts();
                  return true;
                },
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 15, right: 15),
                            child: Container(
                              color: AppColors.to.darkBgColor,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onLongPress: () {
                                          ZoomImage().showFullScreenImage(
                                              context, state.user.image);
                                        },
                                        child: CircleAvatar(
                                          radius: 45,
                                          backgroundColor:
                                              AppColors.to.contrastThemeColor,
                                          backgroundImage: state
                                                  .user.image.isEmpty
                                              ? AssetImage(ImagePath.profileIcon)
                                              : NetworkImage(state.user.image),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 40.w,
                                      ),
                                      Row(
                                        spacing: 25.w,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                  AppRoutes.followersScreen,
                                                  arguments: state.user.uid);
                                            },
                                            child: Column(
                                              children: [
                                                CommonSoraText(
                                                  text: state
                                                      .user.followers.length
                                                      .toString(),
                                                  // Updated followers count
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                  textSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                CommonSoraText(
                                                  text: LocaleKeys.followers.tr,
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                  AppRoutes.followingScreen,
                                                  arguments: state.user.uid);
                                            },
                                            child: Column(
                                              children: [
                                                CommonSoraText(
                                                  text: state
                                                      .user.following.length
                                                      .toString(),
                                                  // Updated following count
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                  textSize: 17,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                CommonSoraText(
                                                  text: LocaleKeys.following.tr,
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  CommonSoraText(
                                    text: state.user.name,
                                    color: AppColors.to.contrastThemeColor,
                                    textSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  CommonSoraText(
                                    text: state.user.about,
                                    color: AppColors.to.contrastThemeColor,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      state.user.uid != currentUserId
                                          ? GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<UserCubit>()
                                                    .toggleFollow(currentUserId,
                                                        state.user.uid);
                                                context
                                                    .read<FeedPostCubit>()
                                                    .fetchFollowingPosts();
                                                // context.read<UserProfileCubit>().fetchUserProfile(otherUserId: userData.uid);
                                              },
                                              child: Container(
                                                height: 30.h,
                                                width: 150.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: AppColors
                                                          .to.contrastThemeColor,
                                                      width: 2),
                                                ),
                                                child: Center(
                                                  child: state is UserLoading
                                                      ? SizedBox(
                                                          height: 17,
                                                          width: 17,
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: AppColors.to
                                                                .authCircularIndicatorColor,
                                                          ),
                                                        )
                                                      : CommonSoraText(
                                                          text: isFollow
                                                              ? LocaleKeys
                                                                  .unfollow.tr
                                                              : (isFollowRequest
                                                                  ? LocaleKeys
                                                                      .cancelRequest
                                                                      .tr
                                                                  : LocaleKeys
                                                                      .follow.tr),
                                                          color: AppColors.to
                                                              .contrastThemeColor,
                                                          // fontWeight: FontWeight.w500,
                                                        ),
                                                ),
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                      if (isFollow) ...[
                                        GestureDetector(
                                          onTap: () {
                                            Get.toNamed(AppRoutes.chatScreen,
                                                arguments: state.user);
                                          },
                                          child: Container(
                                            height: 30.h,
                                            width: 150.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: AppColors
                                                      .to.contrastThemeColor,
                                                  width: 2),
                                            ),
                                            child: Center(
                                              child: CommonSoraText(
                                                text: LocaleKeys.message.tr,
                                                color: AppColors
                                                    .to.contrastThemeColor,
                                                // fontWeight: FontWeight
                                                //     .w500,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.user.followers.contains(currentUserId) ||
                        !state.user.isPrivate)
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          TabBar(
                            controller: tabController,
                            labelColor: AppColors.to.contrastThemeColor,
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
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
                  body: state.user.followers.contains(currentUserId) ||
                          !state.user.isPrivate
                      ? TabBarView(
                          controller: tabController,
                          children: [
                            UsersPosts(),
                            UserVideos(),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 150),
                            Image.asset(
                              ImagePath.privateAccountIcon,
                              height: 80.h,
                              color: AppColors.to.contrastThemeColor,
                            ),
                            SizedBox(height: 15.h),
                            CommonSoraText(
                              text: "Private account",
                              color: AppColors.to.contrastThemeColor,
                              textSize: 20,
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        }
        return Center(
            child: CircularProgressIndicator(
          color: AppColors.to.contrastThemeColor,
        ));
      },
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

/*

                          state.user.followers.contains(currentUserId)?SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - 200.h,
                            child: NestedScrollView(
                              controller: scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              headerSliverBuilder: (context,
                                  innerBoxIsScrolled) =>
                              [
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                    TabBar(
                                      controller: tabController,
                                      labelColor: AppColors.to
                                          .contrastThemeColor,
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      unselectedLabelColor:
                                      AppColors.to.contrastThemeColor,
                                      indicatorColor: AppColors.to
                                          .contrastThemeColor,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabs: [
                                        Tab(
                                          child: CommonSoraText(
                                            text: "Posts (${state.user
                                                .postCount})",
                                            color: AppColors.to
                                                .contrastThemeColor,
                                            textSize: 15,),
                                        ),
                                        Tab(
                                          child: CommonSoraText(text: "Clips",
                                            color: AppColors.to
                                                .contrastThemeColor,
                                            textSize: 15,),
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
                            ),
                          ):
                          state.user.isPrivate?Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 15.h,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 150),
                                child: Image(
                                  image: AssetImage(ImagePath.privateAccountIcon),
                                  height: 80.h,
                                  color: AppColors.to.contrastThemeColor,
                                ),
                              ),
                              CommonSoraText(
                                text: "Private account",
                                color: AppColors.to.contrastThemeColor,
                                textSize: 20,
                              ),
                            ],
                          ):SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height - 200.h,
                            child: NestedScrollView(
                              controller: scrollController,
                              physics: const NeverScrollableScrollPhysics(),
                              headerSliverBuilder: (context,
                                  innerBoxIsScrolled) =>
                              [
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverAppBarDelegate(
                                    TabBar(
                                      controller: tabController,
                                      labelColor: AppColors.to
                                          .contrastThemeColor,
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      unselectedLabelColor:
                                      AppColors.to.contrastThemeColor,
                                      indicatorColor: AppColors.to
                                          .contrastThemeColor,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabs: [
                                        Tab(
                                          child: CommonSoraText(
                                            text: "Posts (${state.user
                                                .postCount})",
                                            color: AppColors.to
                                                .contrastThemeColor,
                                            textSize: 15,),
                                        ),
                                        Tab(
                                          child: CommonSoraText(text: "Clips",
                                            color: AppColors.to
                                                .contrastThemeColor,
                                            textSize: 15,),
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
                            ),
                          ),
 */

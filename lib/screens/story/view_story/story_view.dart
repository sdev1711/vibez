import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/story_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/services/story/story_service.dart';
import 'package:vibez/widgets/bottomshit_options.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';

class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({
    super.key,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _pageController;
  final StoryController _storyController = StoryController();
  List<List<StoryModel>>? userStoriesList;
  int? initialIndex;
  String currentUser = ApiService.user.uid;
  @override
  void initState() {
    super.initState();
    userStoriesList = Get.arguments['story'];
    userStoriesList = userStoriesList?.map((storyList) => storyList.reversed.toList()).toList();
    initialIndex = Get.arguments['index'];
    _pageController = PageController(initialPage: initialIndex ?? 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _storyController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    int currentStoryIndex = 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: _pageController,
          itemCount: userStoriesList?.length, // Iterate over users
          itemBuilder: (context, index) {
            List<StoryModel> userStories = userStoriesList![index];
            String userId = userStories.first.userId;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: FutureBuilder<UserModel?>(
                        future: StoryService().fetchUserDetails(userId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show loader
                          } else if (snapshot.hasData) {
                            UserModel? user = snapshot.data;
                            return CommonSoraText(
                              text: user?.username ??
                                  "", // Display fetched username
                              color: AppColors.to.contrastThemeColor,
                            );
                          } else {
                            return CommonSoraText(
                              text: "Unknown",
                              color: AppColors.to.contrastThemeColor,
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: CommonIconButton(
                        iconData: Icons.more_vert_rounded,
                        size: 20,
                        color: AppColors.to.contrastThemeColor,
                        onTap: () {
                          _storyController.pause();
                          _moreOptionsSheet(context,ApiService.user.uid,userStories[currentStoryIndex]);

                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: StoryView(
                    indicatorHeight: IndicatorHeight.small,
                    storyItems: userStories.map((story) {
                      return StoryItem.pageImage(
                        url: story.mediaUrl,
                        imageFit: BoxFit.contain,
                        controller: _storyController,
                      );
                    }).toList(),
                    controller: _storyController,
                    onStoryShow: (storyItem, index) {
                      if (mounted) {
                        currentStoryIndex = index;
                      }
                      StoryService().markStoryAsViewed(userStories[currentStoryIndex].storyId);
                    },
                    onComplete: () {
                      if (index < userStoriesList!.length - 1) {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                if (currentUser == userId)
                  GestureDetector(
                    onTap: () {
                      _storyController.pause();
                      _showViewersList(context, userStories[currentStoryIndex]);
                    },
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 60,
                        color: Colors.transparent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility_rounded, size: 20),
                            SizedBox(width: 5),
                            CommonSoraText(
                              text: "Views",
                              color: AppColors.to.white,
                              textSize: 17,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _viewersActionSheet(BuildContext context, UserModel otherUser, String userId) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: AppColors.to.darkBgColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            OptionItem(
              name: "View profile",
              onTap: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                Get.toNamed(AppRoutes.otherUserProfileScreen,
                    arguments: otherUser);
              },
            ),
            OptionItem(
              name: "Remove follower",
              onTap: () {
                ApiService().removeFollower(userId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: CommonSoraText(
                        text: "Removed", color: AppColors.to.darkBgColor),
                    backgroundColor: AppColors.to.contrastThemeColor,
                  ),
                );
                Navigator.pop(context);
              },
            ),
            OptionItem(
              name: "Block",
              onTap: () {},
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
  void _showViewersList(BuildContext context, StoryModel story) async {
    String myUserId = ApiService.me.uid;
    List<String> filteredViewers =
        story.viewedBy.where((id) => id != myUserId).toList();

    List<UserModel> users = await Future.wait(
      filteredViewers.map((userId) => StoryService().fetchUserDetails(userId)),
    );

    int count = story.viewedBy.length - 1;
    if (!context.mounted) return;

    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: AppColors.to.darkBgColor,
      context: context,
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 15),
              child: Row(
                spacing: 10.w,
                children: [
                  Icon(Icons.visibility_rounded, size: 20),
                  count==-1?CommonSoraText(text: "0", color: AppColors.to.contrastThemeColor):CommonSoraText(
                    text: count.toString(),
                    color: AppColors.to.contrastThemeColor,
                    textSize: 15,
                  ),
                ],
              ),
            ),
            Divider(
              color: AppColors.to.contrastThemeColor.withOpacity(0.2),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
              child: users.isEmpty
                  ? Center(
                      child: CommonSoraText(
                        text: "No Viewers Yet",
                        color: AppColors.to.contrastThemeColor,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return ListTile(
                          title: CommonSoraText(
                            text: user.name,
                            color: AppColors.to.contrastThemeColor,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.to.contrastThemeColor,
                            backgroundImage: user.image.isNotEmpty
                                ? NetworkImage(user.image)
                                : AssetImage('assets/images/profile_icon.png')
                                    as ImageProvider,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert_rounded,
                                color: AppColors.to.contrastThemeColor),
                            onPressed: () {
                              _viewersActionSheet(context, user, user.uid);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
  void _moreOptionsSheet(BuildContext context, String userId,StoryModel storyId) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: AppColors.to.darkBgColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            currentUser==storyId.userId?OptionItem(
              name: "Delete",
              onTap: () async {
                Navigator.pop(context);
                Navigator.pop(context);

                try {
                  await ApiService.firestore
                      .collection('stories')
                      .doc(storyId.storyId) // Replace with the actual storyId
                      .delete();
                  Get.snackbar("Success", "Story deleted successfully",
                      backgroundColor: Colors.green, colorText: Colors.white);
                } catch (e) {

                  Get.snackbar("Error", "Failed to delete story",
                      backgroundColor: Colors.red, colorText: Colors.white);
                }
              },
            ):Container(),
            currentUser==storyId.userId?OptionItem(
              name: "Edit",
              onTap: () {
                Navigator.pop(context);
              },
            ):Container(),
            currentUser==storyId.userId?OptionItem(
              name: "Add to highlight",
              onTap: () {
                Navigator.pop(context);
              },
            ):Container(),
            currentUser!=storyId.userId?OptionItem(
              name: "Report",
              onTap: () {
                Navigator.pop(context);
              },
            ):Container(),
            OptionItem(
              name: "Share",
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}

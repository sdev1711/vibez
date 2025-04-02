import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/story_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/services/story/story_service.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_text.dart';

class StoryViewWidget extends StatefulWidget {
  const StoryViewWidget({super.key});

  @override
  State<StoryViewWidget> createState() => _StoryViewWidgetState();
}

class _StoryViewWidgetState extends State<StoryViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        children: [
          // All Stories (Scrollable List)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: ApiService.firestore
                  .collection('stories')
                  .where('timestamp',
                  isGreaterThan:
                  DateTime.now().millisecondsSinceEpoch -
                      24 * 60 * 60 * 1000) // Last 24 hours
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();

                List<StoryModel> stories = snapshot.data!.docs
                    .map((doc) => StoryModel.fromJson(
                    doc.data() as Map<String, dynamic>))
                    .toList();

                Map<String, List<StoryModel>> groupedStories = {};
                for (var story in stories) {
                  if (!groupedStories.containsKey(story.userId)) {
                    groupedStories[story.userId] = [];
                  }
                  groupedStories[story.userId]!.add(story);
                }

                List<List<StoryModel>> userStoriesList =
                groupedStories.values.toList();

                //Check if the current user has a story
                bool hasUserStory =
                groupedStories.containsKey(ApiService.user.uid);
                List<StoryModel>? myStories =
                groupedStories[ApiService.user.uid];

                //If the user has a story, ensure it appears in index 0
                if (hasUserStory && myStories != null) {
                  userStoriesList.remove(
                      myStories); // Remove from current position
                  userStoriesList.insert(
                      0, myStories); // Add at index 0
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: userStoriesList.length +
                      (hasUserStory
                          ? 0
                          : 1), // Extra slot for camera icon
                  itemBuilder: (context, index) {
                    if (index == 0 && !hasUserStory) {
                      //Show camera icon if the user has no story
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.storyUploadScreen);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // border: Border.all(
                                      //   color: AppColors.to.contrastThemeColor,
                                      //   width: 3,
                                      // ),
                                    ),
                                    padding: EdgeInsets.all(3),
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundColor: AppColors
                                          .to.contrastThemeColor,
                                      backgroundImage:  ApiService.me.image.isEmpty
                                          ? AssetImage(ImagePath.profileIcon)
                                          : CachedNetworkImageProvider(ApiService.me.image),
                                      // child: Icon(Icons.camera_alt,
                                      //     color: Colors.black, size: 30),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Icon(
                                        Icons.add_circle,
                                        color: AppColors.to.contrastThemeColor
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width *
                                    0.21,
                                child: Center(
                                  child: CommonSoraText(
                                    text: "Your story",
                                    color:
                                    AppColors.to.contrastThemeColor,
                                    maxLine: 1,
                                    softWrap: true,
                                    textSize: 13,
                                    textOverflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    //Show user stories (normal behavior)
                    List<StoryModel> userStories =
                    userStoriesList[index - (hasUserStory ? 0 : 1)];
                    StoryModel latestStory = userStories.first;
                    bool isViewed = latestStory.viewedBy
                        .contains(ApiService.user.uid);

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.storyViewerScreen,
                            arguments: {
                              'story': userStoriesList,
                              'index': index - (hasUserStory ? 0 : 1),
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isViewed
                                      ? Colors.grey
                                      : AppColors.to.contrastThemeColor,
                                  width: 3,
                                ),
                              ),
                              padding: EdgeInsets.all(3),
                              child: FutureBuilder<UserModel?>(
                                future: StoryService().fetchUserDetails(
                                    latestStory.userId),
                                builder: (context, snapshot) {
                                  return CircleAvatar(
                                    radius: 35,
                                    backgroundColor:
                                    AppColors.to.contrastThemeColor,
                                    backgroundImage: snapshot.hasData &&
                                        snapshot
                                            .data!.image.isNotEmpty
                                        ? NetworkImage(
                                        snapshot.data!.image)
                                        : AssetImage(
                                        ImagePath.profileIcon),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.21,
                              child: Center(
                                child: FutureBuilder<UserModel?>(
                                  future: StoryService()
                                      .fetchUserDetails(
                                      latestStory.userId),
                                  builder: (context, snapshot) {
                                    return CommonSoraText(
                                      text: snapshot.hasData
                                          ? snapshot.data!.username
                                          : "",
                                      color: AppColors
                                          .to.contrastThemeColor,
                                      maxLine: 1,
                                      softWrap: true,
                                      textSize: 13,
                                      textOverflow:
                                      TextOverflow.ellipsis,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

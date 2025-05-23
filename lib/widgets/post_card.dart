import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/bottom_navigation_controller.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/post/comment/comment_screen.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/bottomshit_options.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_text_button.dart';
import 'package:vibez/widgets/common_textfield.dart';
import 'package:vibez/widgets/post_image_view.dart';
import 'package:vibez/widgets/post_video_view.dart';

import 'comment_bottom_shit.dart';

class PostCard extends StatelessWidget {
  final PostModel postsData;
  final UserModel userDetails;
  final  String profilePic;
  final  String username;
  final Map<String, dynamic> userData;
  const PostCard({
    super.key,
    required this.postsData,
    required this.userDetails,
    required this.profilePic,
    required this.username,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    String currentUser=ApiService.me.username;
    String userId = ApiService.user.uid;
    bool isMe = userId == postsData.userId;
    void sharePost(String name, String userName) {
      final String shareText =
          "Check out my post on Vibez! 👇\n Post: $name\nUsername: $userName\n App: vibez.app";
      Share.share(shareText);
    }
    void showMessageUpdateDialog() {
      String updatedMsg = postsData.content;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          // Use a separate context
          return AlertDialog(
            contentPadding:
            const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: CommonSoraText(
              text: "Edit caption",
              color: AppColors.to.contrastThemeColor,
              textSize: 20,
            ),
            content: CommonTextField(
              initialValue: updatedMsg,
              onChanged: (value) => updatedMsg = value,
            ),
            actions: [
              CommonTextButton(
                onPressed: () {
                  FocusScope.of(dialogContext).unfocus(); // Hide keyboard
                  Future.delayed(Duration(milliseconds: 100), () {
                    if (!context.mounted) return;
                    if (Navigator.canPop(dialogContext)) {
                      Navigator.of(dialogContext).pop();
                    }
                  });
                  log("Cancel button pressed");
                },
                child: CommonSoraText(
                  text: 'Cancel',
                  color: AppColors.to.contrastThemeColor,
                ),
              ),
              CommonTextButton(
                onPressed: () async {
                  FocusScope.of(dialogContext).unfocus(); // Hide keyboard

                  postsData.content = updatedMsg;

                  (context as Element).markNeedsBuild();
                  Future.delayed(Duration(milliseconds: 100), () async {
                    if (Navigator.canPop(dialogContext)) {
                      Navigator.pop(dialogContext);
                    }

                    // Update caption in backend
                    await ApiService.updateCaption(postsData, updatedMsg);
                  });
                },
                child: CommonSoraText(
                  text: 'Edit',
                  color: AppColors.to.contrastThemeColor,
                ),
              ),
            ],
          );
        },
      );
    }
    void showBottomSheetDialog(bool isMe) {
      showModalBottomSheet(
        isDismissible: true,
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
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 120.w),
                decoration: BoxDecoration(
                  color: AppColors.to.contrastThemeColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              if (isMe)
                OptionItem(
                  icon: Icons.edit,
                  name: "Edit",
                  onTap: () {
                    Navigator.pop(context);
                    showMessageUpdateDialog();
                  },
                ),
              OptionItem(
                icon: Icons.share,
                name: "Share",
                onTap: () {
                  sharePost(postsData.imageUrl, postsData.user.username);
                },
              ),
              OptionItem(
                icon: Icons.report_gmailerrorred,
                name: "Report",
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              if (isMe)
                OptionItem(
                  icon: Icons.delete_outline_rounded,
                  name: "Delete",
                  onTap: () async {
                    try {
                      await ApiService.firestore
                          .collection('posts')
                          .doc(postsData.postId)
                          .delete()
                          .then((_) {
                        // Check if context is mounted before navigating
                        if (context.mounted) {
                          Navigator.of(context).pop(); // Pop the current screen
                        }
                      });

                      // Ensure the widget is still mounted before performing UI updates
                      if (!context.mounted) return;

                      // Fetch updated posts and profile data
                      context.read<FeedPostCubit>().fetchFollowingPosts();
                      context.read<PostCubit>().fetchPosts();
                      context.read<UserProfileCubit>().fetchUserProfile();

                      // Decrement post count in Firestore
                      DocumentReference userRef =
                      ApiService.firestore.collection('users').doc(userId);
                      await userRef.update({
                        'postCount': FieldValue.increment(-1), // Decrement by 1
                      }).then((_) {
                        log("User's postCount successfully decremented!");
                      }).catchError((error) {
                        log("Error updating postCount: $error");
                      });

                      // Show success message
                      if (context.mounted) {
                        Get.snackbar("Success", "Post deleted successfully",
                            backgroundColor: Colors.green, colorText: Colors.white);
                        Navigator.pop(context); // Safely pop the screen
                      }
                    } catch (e) {
                      // Handle error
                      if (context.mounted) {
                        Get.snackbar("Error", "Failed to delete story",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    }
                  },
                ),
              const SizedBox(height: 20),
            ],
          );
        },
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.to.darkBgColor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (isMe) {
                            Get.find<BottomNavController>().changeIndex(4);
                            Get.back();
                          } else {
                            Get.toNamed(
                              AppRoutes.otherUserProfileScreen,
                              arguments:
                              userDetails, // Pass updated user data
                            );
                          }
                        },
                        child: CircleAvatar(
                          backgroundImage: profilePic.isNotEmpty
                              ? CachedNetworkImageProvider(profilePic,)
                              : AssetImage(ImagePath.profileIcon)
                          as ImageProvider,
                          backgroundColor: AppColors.to.contrastThemeColor,
                          radius: 20,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          if (isMe) {
                            Get.find<BottomNavController>().changeIndex(4);
                            Get.back();
                          } else {
                            Get.toNamed(
                              AppRoutes.otherUserProfileScreen,
                              arguments:
                              userDetails, // Pass updated user data
                            );
                          }
                        },
                        child: CommonSoraText(
                          text: username,
                          color: AppColors.to.contrastThemeColor,
                          textSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                  CommonIconButton(
                    onTap: () {
                      showBottomSheetDialog(isMe);
                    },
                    iconData: Icons.more_vert_rounded,
                    size: 25,
                    color: AppColors.to.contrastThemeColor,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            child: GestureDetector(
              onDoubleTap: () {
                final postCubit = context.read<PostCubit>();
                if (postsData.likes.contains(currentUser)) {
                  return;
                } else {
                  postCubit.addLike(
                      postsData.postId, currentUser, userDetails);
                  postsData.likes.add(currentUser);
                }
                (context as Element).markNeedsBuild();
              },
              child: postsData.postType == PostType.image
                  ? PostImageView(postsData: postsData,) // Show Image
                  : PostVideoView(postUrl: postsData.imageUrl,), // Show Video
            ),
          ),
          Visibility(
            visible: postsData.content.isNotEmpty,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (isMe) {
                        Get.find<BottomNavController>().changeIndex(4);
                        Get.back();
                      } else {
                        Get.toNamed(
                          AppRoutes.otherUserProfileScreen,
                          arguments: userData, // Pass updated user data
                        );
                      }
                    },
                    child: CommonSoraText(
                      text: username,
                      color: AppColors.to.contrastThemeColor,
                      fontWeight: FontWeight.bold,
                      textSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  GestureDetector(
                    onTap: () {
                      commentBottomShit(context,postsData,ApiService.me);
                    },
                    child: CommonSoraText(
                      text: postsData.content,
                      color: AppColors.to.contrastThemeColor,
                      textSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(color: AppColors.to.darkBgColor),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      final postCubit = context.read<PostCubit>();

                      if (postsData.likes.contains(currentUser)) {
                        postCubit.removeLike(postsData.postId, currentUser);
                        postsData.likes.remove(currentUser);
                      } else {
                        postCubit.addLike(
                            postsData.postId, currentUser, userDetails);
                        postsData.likes.add(currentUser);
                      }
                      (context as Element).markNeedsBuild();
                    },
                    child: ImageIcon(
                      AssetImage(postsData.likes.contains(currentUser)
                          ? ImagePath.likeIcon
                          : ImagePath.noLikeIcon),
                      color: postsData.likes.contains(currentUser)
                          ? AppColors.to.alertColor
                          : AppColors.to.contrastThemeColor,
                      size: 25.sp,
                    ),
                  ),
                  Visibility(
                    visible: postsData.likes.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: CommonSoraText(
                        text: postsData.likes.length.toString(),
                        color: AppColors.to.contrastThemeColor,
                        textSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  GestureDetector(
                    onTap: () {
                      commentBottomShit(context,postsData,ApiService.me);
                    },
                    child: ImageIcon(
                      AssetImage(ImagePath.commentIcon),
                      color: AppColors.to.contrastThemeColor,
                      size: 23.sp,
                    ),
                  ),
                  Visibility(
                    visible: postsData.comments.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: CommonSoraText(
                        text: postsData.comments.length.toString(),
                        color: AppColors.to.contrastThemeColor,
                        textSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  GestureDetector(
                    onTap: () {
                      sharePost(
                          postsData.imageUrl, postsData.user.username);
                    },
                    child: ImageIcon(
                      AssetImage(ImagePath.shareIcon),
                      color: AppColors.to.contrastThemeColor,
                      size: 23.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

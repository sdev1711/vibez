import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/follow_request/follow_request_cubit.dart';
import 'package:vibez/Cubit/follow_request/follow_request_state.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_text.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 17,
          text: LocaleKeys.notifications.tr,
          color: AppColors.to.contrastThemeColor,
        ),
      ),
      body: Column(
        children: [
          BlocBuilder<FollowRequestCubit, FollowRequestState>(
            builder: (context, state) {
              if (state is FollowRequestLoading) {
                return Center(
                    child: CircularProgressIndicator(
                        color: AppColors.to.contrastThemeColor));
              }

              if (state is FollowRequestError) {
                return Center(
                    child: CommonSoraText(
                        text: "Error: ${state.error}",
                        color: AppColors.to.contrastThemeColor));
              }

              if (state is FollowRequestLoaded) {
                if (state.requests.isEmpty) {
                  return Container();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: CommonSoraText(
                        text: "Follow requests",
                        color: AppColors.to.contrastThemeColor,
                        textSize: 13,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.requests.length,
                      itemBuilder: (context, index) {
                        UserModel user = state.requests[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.image.isEmpty
                                ? AssetImage(ImagePath.profileIcon)
                                : NetworkImage(user.image),
                          ),
                          title: CommonSoraText(text:user.username,color: AppColors.to.contrastThemeColor,textSize: 13,fontWeight: FontWeight.w500,),
                          subtitle: CommonSoraText(text:user.name,color: AppColors.to.contrastThemeColor.withOpacity(0.5),textSize: 13,),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CommonButton(
                                onPressed: () {
                                  log("user details======== ${user.name}");
                                  context
                                      .read<FollowRequestCubit>()
                                      .acceptFollowRequest(user.uid);
                                  context
                                      .read<UserProfileCubit>()
                                      .fetchUserProfile();
                                },
                                bgColor: AppColors.to.contrastThemeColor,
                                height: 30.h,
                                width: 70.w,
                                child: CommonSoraText(
                                  text: LocaleKeys.accept.tr,
                                  color: AppColors.to.darkBgColor,
                                  textSize: 13,
                                ),
                              ),
                              SizedBox(width: 8),
                              CommonButton(
                                onPressed: () {
                                  context
                                      .read<FollowRequestCubit>()
                                      .rejectFollowRequest(user.uid);
                                },
                                bgColor: AppColors.to.darkBgColor,
                                boxBorder: Border.all(
                                    color: AppColors.to.contrastThemeColor),
                                height: 30.h,
                                width: 70.w,
                                child: CommonSoraText(
                                  text: LocaleKeys.reject.tr,
                                  color: AppColors.to.contrastThemeColor,
                                  textSize: 13,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              }

              return Center(
                child: CommonSoraText(
                  text: LocaleKeys.noData.tr,
                  color: AppColors.to.contrastThemeColor,
                  textSize: 14,
                ),
              );
            },
          ),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.posts.isEmpty
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            child: CommonSoraText(
                              text: "Likes",
                              color: AppColors.to.contrastThemeColor,
                              textSize: 13,
                            ),
                          ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        final post = state.posts[index];
                        return Row(
                          children: [
                            // StreamBuilder to listen for real-time likes
                            StreamBuilder<List<String>>(
                              stream: context.read<PostCubit>().getPostLikes(
                                  post.postId), // Call the stream function
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Container();
                                }

                                // Filter out the current user's username
                                List<String> likedUsers = snapshot.data!
                                    .where((username) =>
                                        username != ApiService.me.username)
                                    .toList();

                                log("liked user length ${likedUsers.length}");

                                if (likedUsers.isEmpty) {
                                  return Container();
                                }

                                return likedUsers.length == 1
                                    ? Expanded(
                                        child: ListTile(
                                          title: CommonSoraText(
                                            text:
                                                "${likedUsers.first} liked your post",
                                            color:
                                                AppColors.to.contrastThemeColor,
                                          ),
                                          leading: _buildImage(post.imageUrl),
                                        ),
                                      )
                                    : likedUsers.length == 2
                                        ? Expanded(
                                            child: ListTile(
                                              title: CommonSoraText(
                                                text:
                                                    "${likedUsers[0]}, ${likedUsers[1]} liked your post",
                                                color: AppColors
                                                    .to.contrastThemeColor,
                                              ),
                                              leading:
                                                  _buildImage(post.imageUrl),
                                            ),
                                          )
                                        : Expanded(
                                            child: ListTile(
                                              title: CommonSoraText(
                                                text:
                                                    "${likedUsers[0]}, ${likedUsers[1]} and others liked your post",
                                                color: AppColors
                                                    .to.contrastThemeColor,
                                              ),
                                              leading:
                                                  _buildImage(post.imageUrl),
                                            ),
                                          );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                );
              }
              return CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }
}

Widget _buildImage(String imageUrl) {
  return Container(
    height: 40,
    width: 40,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      image: DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(imageUrl),
      ),
    ),
  );
}

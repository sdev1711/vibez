import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vibez/Cubit/clip_screen_cubit/clip_screen_cubit.dart';
import 'package:vibez/Cubit/clip_screen_cubit/clip_screen_state.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:video_player/video_player.dart';

class ClipView extends StatefulWidget {
  final PostModel clip;
  const ClipView({super.key, required this.clip});

  @override
  State<ClipView> createState() => _ClipViewState();
}

class _ClipViewState extends State<ClipView> {
  void sharePost(String name, String userName) {
    final String shareText =
        "Check out my post on Vibez! 👇\n Post: $name\nUsername: $userName\n App: vibez.app";
    Share.share(shareText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ClipViewScreenCubit()..loadClip(widget.clip),
        child: BlocBuilder<ClipViewScreenCubit, ClipViewScreenState>(
          builder: (context, state) {
            if (state is ClipViewLoading) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            if (state is ClipViewLoaded) {
              final post = state.post;
              final controller = state.controller;
              final currentUser = ApiService.me.username;
              return Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            child: controller.value.isInitialized
                                ? AspectRatio(
                                    aspectRatio: controller.value.aspectRatio,
                                    child: VideoPlayer(controller),
                                  )
                                : Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                        Positioned(
                          top: 80,
                          left: 10,
                          child: CommonSoraText(
                            text: "Clips",
                            color: AppColors.to.contrastThemeColor,
                            textSize: 15.sp,
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 15,
                          child: Column(
                            spacing: 10.h,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                spacing: 10.w,
                                children: [
                                  CircleAvatar(
                                    radius: 23,
                                    backgroundImage: post.user.image.isNotEmpty
                                        ? NetworkImage(post.user.image)
                                        : AssetImage(ImagePath.postImageIcon),
                                  ),
                                  CommonSoraText(
                                    text: post.user.username,
                                    color: AppColors.to.contrastThemeColor,
                                    textSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              CommonSoraText(
                                text: post.content,
                                color: AppColors.to.contrastThemeColor,
                                textSize: 16,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 50.h,
                          right: 120.w,
                          child: GestureDetector(
                            onTap: () {
                              context
                                  .read<ClipViewScreenCubit>()
                                  .toggleLike(post, currentUser);
                              context.read<PostCubit>().fetchPosts();
                            },
                            child: ImageIcon(
                              AssetImage(post.likes.contains(currentUser)
                                  ? ImagePath.likeIcon
                                  : ImagePath.noLikeIcon),
                              color: post.likes.contains(currentUser)
                                  ? AppColors.to.alertColor
                                  : AppColors.to.contrastThemeColor,
                              size: 30,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25.h,
                          right: 128.w,
                          child: Visibility(
                            visible: post.likes.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: CommonSoraText(
                                text: post.likes.length.toString(),
                                color: AppColors.to.contrastThemeColor,
                                textSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 80.w,
                          bottom: 50.h,
                          child: GestureDetector(
                            onTap: () async {
                              await Get.toNamed(AppRoutes.commentScreen,
                                  arguments: {
                                    "postData": post,
                                    "userData": ApiService.me,
                                  });
                              context
                                  .read<ClipViewScreenCubit>()
                                  .refreshPost(post);
                              context.read<PostCubit>().fetchPosts();
                            },
                            child: ImageIcon(
                              AssetImage(ImagePath.commentIcon),
                              color: AppColors.to.contrastThemeColor,
                              size: 27,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 25.h,
                          right: 88.w,
                          child: Visibility(
                            visible: post.comments.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: CommonSoraText(
                                text: post.comments.length.toString(),
                                color: AppColors.to.contrastThemeColor,
                                textSize: 16,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 40.w,
                          bottom: 50.h,
                          child: GestureDetector(
                            onTap: () {
                              sharePost(post.imageUrl, post.user.username);
                            },
                            child: ImageIcon(
                              AssetImage(ImagePath.shareIcon),
                              color: AppColors.to.contrastThemeColor,
                              size: 27,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

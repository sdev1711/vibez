import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
  late VideoPlayerController _controller;
  String currentUser=ApiService.me.username;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.clip.imageUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
  }
  void sharePost(String name, String userName) {
    final String shareText =
        "Check out my post on Vibez! 👇\n Post: $name\nUsername: $userName\n App: vibez.app";
    Share.share(shareText);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(_controller))
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
                              backgroundImage: widget.clip.user.image.isNotEmpty?NetworkImage(widget.clip.user.image):AssetImage(ImagePath.postImageIcon),
                            ),
                            CommonSoraText(
                              text: widget.clip.user.username,
                              color: AppColors.to.contrastThemeColor,
                              textSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        CommonSoraText(
                          text: widget.clip.content,
                          color: AppColors.to.contrastThemeColor,
                          textSize: 16,
                        ),
                      ],
                    )),
                // Positioned(
                //   bottom:50.h,
                //   right: 120.w,
                //   child: GestureDetector(
                //     onTap: () {
                //       final postCubit = context.read<PostCubit>();
                //
                //       if (widget.clip.likes.contains(currentUser)) {
                //         postCubit.removeLike(widget.clip.postId, currentUser);
                //         widget.clip.likes.remove(currentUser);
                //       } else {
                //         postCubit.addLike(
                //             widget.clip.postId, currentUser, widget.clip.user);
                //         widget.clip.likes.add(currentUser);
                //       }
                //       (context as Element).markNeedsBuild();
                //     },
                //     child: ImageIcon(
                //       AssetImage(widget.clip.likes.contains(currentUser)
                //           ? ImagePath.likeIcon
                //           : ImagePath.noLikeIcon),
                //       color: widget.clip.likes.contains(currentUser)
                //           ? AppColors.to.alertColor
                //           : AppColors.to.contrastThemeColor,
                //       size: 30,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom:25.h,
                //   right: 128.w,
                //   child:  Visibility(
                //     visible: widget.clip.likes.isNotEmpty,
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 15.0),
                //       child: CommonSoraText(
                //         text: widget.clip.likes.length.toString(),
                //         color: AppColors.to.contrastThemeColor,
                //         textSize: 16,
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   right: 80.w,
                //   bottom: 50.h,
                //   child:   GestureDetector(
                //     onTap: () {
                //       Get.toNamed(AppRoutes.commentScreen, arguments: {
                //         "postData": widget.clip,
                //         "userData": ApiService.me,
                //       });
                //     },
                //     child: ImageIcon(
                //       AssetImage(ImagePath.commentIcon),
                //       color: AppColors.to.contrastThemeColor,
                //       size: 27,
                //     ),
                //   ),
                // ),
                // Positioned(
                //   bottom:25.h,
                //   right: 88.w,
                //   child:   Visibility(
                //     visible: widget.clip.comments.isNotEmpty,
                //     child: Padding(
                //       padding: const EdgeInsets.only(left: 15.0),
                //       child: CommonSoraText(
                //         text: widget.clip.comments.length.toString(),
                //         color: AppColors.to.contrastThemeColor,
                //         textSize: 16,
                //       ),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   right: 40.w,
                //   bottom: 50.h,
                //   child: GestureDetector(
                //     onTap: () {
                //       sharePost(
                //           widget.clip.imageUrl, widget.clip.user.username);
                //     },
                //     child: ImageIcon(
                //       AssetImage(ImagePath.shareIcon),
                //       color: AppColors.to.contrastThemeColor,
                //       size: 27,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

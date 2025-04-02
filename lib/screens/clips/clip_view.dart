import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  @override
  void initState() {
    super.initState();
    log(widget.clip.imageUrl);
    _controller = VideoPlayerController.network(widget.clip.imageUrl)
      ..initialize().then((_) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
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
                    textSize: 20,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

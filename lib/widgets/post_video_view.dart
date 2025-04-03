import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibez/Cubit/video_visibility/video_visibility.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostVideoView extends StatefulWidget {
  final String postUrl;
  const PostVideoView({super.key,required this.postUrl, });

  @override
  State<PostVideoView> createState() => _PostVideoViewState();
}

class _PostVideoViewState extends State<PostVideoView> {
  late VideoPlayerController videoController;
  final StreamController<void> videoStreamController = StreamController<void>();
  bool isVisible = false;
  @override
  void initState() {
    videoController =
        VideoPlayerController.network(widget.postUrl);
    videoController.initialize().then((_) {
      videoController.setLooping(true);
      videoController.play();
      videoStreamController.add(null);
    });

    videoController.addListener(() {
      if (!videoStreamController.isClosed) {
        videoStreamController.add(null);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    videoController.pause();
    videoController.dispose();
    videoStreamController.close();
    super.dispose();
  }


  void handleVisibility(BuildContext context, bool visible) {
    if (context.mounted) {
      context.read<VideoVisibilityCubit>().setVisibility(visible);
      if (visible) {
        videoController.play();
      } else {
        videoController.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoVisibilityCubit, bool>(
      builder: (context,isVisible){
        return VisibilityDetector(
          key: Key(widget.postUrl),
          onVisibilityChanged: (visibilityInfo) {
            handleVisibility(context, visibilityInfo.visibleFraction > 0.5);
          },
          child: StreamBuilder(
            stream: videoStreamController.stream,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () {
                  if (videoController.value.isPlaying) {
                    videoController.pause();
                  } else {
                    videoController.play();
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: VideoPlayer(videoController),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(
                          videoController.value.volume > 0
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (videoController.value.volume > 0) {
                            videoController.setVolume(0);
                          } else {
                            videoController.setVolume(1.0);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

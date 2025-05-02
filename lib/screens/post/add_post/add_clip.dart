import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibez/Cubit/post/image_picker_cubit/image_picker_cubit.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/bottom_navigation_controller.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';
import 'package:video_player/video_player.dart';

class AddClipScreen extends StatefulWidget {
  const AddClipScreen({super.key});

  @override
  AddClipScreenState createState() => AddClipScreenState();
}

class AddClipScreenState extends State<AddClipScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    context.read<ImagePickerCubit>().pickVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 15.sp,
          text: "Pick clip",
          color: AppColors.to.contrastThemeColor,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_rounded,
              color: AppColors.to.contrastThemeColor),
        ),
        actions: [
          IconButton(onPressed: (){
            context.read<ImagePickerCubit>().pickVideoFromCamera();
          }, icon: Icon(Icons.camera_alt_outlined)),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              File? selectedFile = context.read<ImagePickerCubit>().state;
              log("clip file=======$selectedFile");
              if (selectedFile != null) {
                context.read<PostCubit>().addPost(
                  content: _postController.text.trim(),
                  imageUrl: selectedFile,
                  postType: PostType.video,
                );
                _postController.clear();
                context.read<PostCubit>().fetchPosts();
                context.read<UserProfileCubit>().fetchUserProfile();
                Get.find<BottomNavController>().changeIndex(0);
                Get.back();
                context.read<ImagePickerCubit>().clearImage();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.to.darkBgColor,
                    content: CommonSoraText(
                      text: "Please select an clip",
                      color: Colors.red,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          spacing: 20.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ImagePickerCubit, File?>(
              builder: (context, videoFile) {
                final videoController =
                    context.read<ImagePickerCubit>().videoController;
                return Expanded(
                  child: Container(

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: videoFile==null?Container():
                    Stack(
                            children: [
                              videoController != null &&
                                      videoController.value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          videoController.value.aspectRatio,
                                      child: VideoPlayer(videoController),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator()),

                              Align(
                                alignment: Alignment.bottomCenter,
                                child: IconButton(
                                  icon: Icon(
                                    videoController?.value.isPlaying == true
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  onPressed: () {
                                    if (videoController!.value.isPlaying) {
                                      videoController.pause();
                                    } else {
                                      videoController.play();
                                    }
                                  },
                                ),
                              ),
                              // Close Button
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    context.read<ImagePickerCubit>().clearVideo();
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              },
            ),
            // SizedBox(
            //   height: 50.h,
            //   child: CommonTextField(
            //     controller: _postController,
            //     contentPadding: EdgeInsets.symmetric(
            //       vertical: 3, horizontal: 10,
            //     ),
            //     hintText: "Add a caption...",
            //     focusedBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //       borderSide: BorderSide.none,
            //     ),
            //     fillColor: AppColors.to.contrastThemeColor.withOpacity(0.5),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10),
            //       borderSide: BorderSide.none,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

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

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // context.read<PostCubit>().fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 17,
          text: "Add post",
          color: AppColors.to.contrastThemeColor,
        ),
        actions: [
          IconButton(onPressed: (){
            context.read<ImagePickerCubit>().pickImageFromCamera();
          }, icon: Icon(Icons.camera_alt_outlined)),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              File? selectedFile = context.read<ImagePickerCubit>().state;
              log("image file=======$selectedFile");
              if (selectedFile != null) {
                context.read<PostCubit>().addPost(
                  content: _postController.text.trim(),
                  imageUrl: selectedFile,
                  postType: PostType.image,
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
                      text: "Please select an image",
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
              builder: (context, imageFile) {
                return Container(
                  height: 300.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: imageFile != null
                        ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: Center(
                    child: imageFile == null
                        ? CommonButton(
                      onPressed: () {
                        context.read<ImagePickerCubit>().pickImage();
                      },
                      bgColor: AppColors.to.darkBgColor,
                      boxBorder: Border.all(width: 1,color:AppColors.to.contrastThemeColor),
                      height: 40.h,
                      width: 80.w,
                      child: CommonSoraText(
                        text: "Add post",
                        color: AppColors.to.contrastThemeColor,
                      ),
                    )
                        : Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () =>
                            context.read<ImagePickerCubit>().clearImage(),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 50.h,
              child: CommonTextField(
                controller: _postController,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 3, horizontal: 10,
                ),
                hintText: "Add a caption...",
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: AppColors.to.contrastThemeColor.withOpacity(0.5),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
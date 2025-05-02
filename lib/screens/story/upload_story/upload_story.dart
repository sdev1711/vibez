import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/bottom_navigation_controller.dart';
import 'package:vibez/services/story/story_service.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';

class UploadStoryScreen extends StatefulWidget {
  const UploadStoryScreen({super.key});

  @override
  UploadStoryScreenState createState() => UploadStoryScreenState();
}

class UploadStoryScreenState extends State<UploadStoryScreen> {
  XFile? _selectedMedia;
  final TextEditingController _captionController = TextEditingController();

  Future<void> _pickMedia() async {
    final ImagePicker picker = ImagePicker();
    final XFile? media = await picker.pickImage(source:ImageSource.gallery);
    if (media != null) {
      setState(() {
        _selectedMedia = media;
      });
    }
  }

  Future<void> _uploadStory() async {
    if (_selectedMedia == null) {
      return; // No media selected
    }
    String mediaUrl = await StoryService.uploadMediaToFirebase(_selectedMedia!);
    await StoryService.uploadStory(mediaUrl, caption: _captionController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: CommonSoraText(
            text: "Story uploaded",
            color: AppColors.to.darkBgColor,
          ),
          backgroundColor: AppColors.to.contrastThemeColor,
        ),
      );
    Get.find<BottomNavController>().changeIndex(0);
    Navigator.of(context).pop();
  }
@override
  void initState() {
  _pickMedia();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonSoraText(
          text: "Upload Story",
          color: AppColors.to.contrastThemeColor,
          textSize: 15.sp,
        ),
        leading:  CommonIconButton(
          iconData: Icons.arrow_back_rounded,
          size: 25,
          color: AppColors.to.contrastThemeColor,
          onTap: Navigator.of(context).pop,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _uploadStory();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          _selectedMedia != null
              ? Expanded(
                child: Image.file(File(_selectedMedia!.path),
                fit: BoxFit.cover),
              )
              : SizedBox(
                  height: 200.h,
                  child: Center(
                    child: CommonSoraText(
                      text: "Select photo/video",
                      color: AppColors.to.contrastThemeColor,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

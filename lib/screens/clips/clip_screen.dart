import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/clip_model.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/screens/clips/clip_view.dart';
import 'package:vibez/utils/image_path/image_path.dart';

class ClipScreen extends StatefulWidget {
  const ClipScreen({super.key});

  @override
  State<ClipScreen> createState() => _ClipScreenState();
}

class _ClipScreenState extends State<ClipScreen> {
  late List<PostModel> clips;

  @override
  void initState() {
    clips=Get.arguments;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        itemCount: clips.length,
        itemBuilder: (context, index) {
          return ClipView(clip: clips[index]);
        },
      ),
    );
  }
}


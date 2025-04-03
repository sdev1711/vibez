import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/widgets/common_cached_widget.dart';

class PostImageView extends StatelessWidget {
  final PostModel postsData;
  const PostImageView({super.key,required this.postsData});

  @override
  Widget build(BuildContext context) {
    return CommonCachedWidget( imageUrl: postsData.imageUrl,height: 400.h,width: 390.w,);
  }
}

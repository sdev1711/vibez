import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_post_view.dart';
import 'package:vibez/widgets/common_text.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  late List<PostModel> posts;
  late int postIndex;
  late UserModel user;
  late ScrollController _scrollController;
  TextEditingController commentController= TextEditingController();
  @override
  void initState() {
    posts = Get.arguments["posts"];
    postIndex = Get.arguments["index"];
    user = Get.arguments["userData"];
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.minScrollExtent +
              postIndex * 500.h, // Prevents unwanted jumps
        );
      }
    });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
            text: "Posts", color: AppColors.to.contrastThemeColor),
        leading: CommonIconButton(
          onTap: () {
            Navigator.of(context).pop();
           context.read<PostCubit>().fetchPosts();
          },
          iconData: Icons.arrow_back_rounded, size: 25,color: AppColors.to.contrastThemeColor,
        ),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final postsData = posts[index];
          return CommonPostView(
              key: ValueKey(postsData.postId),
              postsData: postsData);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
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
  late ScrollController _scrollController;
  TextEditingController commentController= TextEditingController();
  @override
  void initState() {
    postIndex = Get.arguments["index"];
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.minScrollExtent +
              postIndex * 500.h, // Prevents unwanted jumps
        );
      }
    });
    // context.read<PostCubit>().fetchOtherUserPosts(ApiService.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 12.sp,
            text: "Posts", color: AppColors.to.contrastThemeColor),
        leading: CommonIconButton(
          onTap: () {
            Navigator.of(context).pop();
           context.read<PostCubit>().fetchPosts();
          },
          iconData: Icons.arrow_back_rounded, size: 25,color: AppColors.to.contrastThemeColor,
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context,state){
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          else if(state is PostLoaded) {
            posts = state.posts;
            final reversedPosts = posts.reversed.toList();
            return ListView.builder(
              controller: _scrollController,
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final postsData = reversedPosts[index];
                return CommonPostView(
                    key: ValueKey(postsData.postId),
                    postsData: postsData);
              },
            );
          }
          else {
            return const Center(child: Text("No posts found."));
          }
        },
      ),
    );
  }
}

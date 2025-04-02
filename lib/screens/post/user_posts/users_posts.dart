import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_cached_widget.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class UsersPosts extends StatefulWidget {
  const UsersPosts({super.key});

  @override
  State<UsersPosts> createState() => _UsersPostsState();
}

class _UsersPostsState extends State<UsersPosts> {
  List<PostModel> posts = [];
  UserModel? user;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoaded) {
          posts = state.posts;
          if (state.posts.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 15.h,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Image(
                    image: AssetImage(ImagePath.noPostIcon),
                    height: 80.h,
                    color: AppColors.to.contrastThemeColor,
                  ),
                ),
                CommonSoraText(
                  text: "No post",
                  color: AppColors.to.contrastThemeColor,
                  textSize: 20,
                ),
              ],
            );
          }
          return BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                user = state.user;
              }
              final reversedPosts = posts.reversed.toList(); // Reverse to show last first
              return GridView.custom(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  repeatPattern: QuiltedGridRepeatPattern.inverted, // Inverted pattern
                  pattern: [
                    QuiltedGridTile(2, 2),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 1),
                    QuiltedGridTile(1, 2),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final post = reversedPosts[index];

                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.postViewScreen, arguments: {
                          "posts": reversedPosts,
                          "index": index,
                          "userData": user,
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: post.postType==PostType.image?CommonCachedWidget(imageUrl: post.imageUrl):Image.asset(ImagePath.defaultVideoCover,fit: BoxFit.cover,),
                      ),
                    );
                  },
                  childCount: reversedPosts.length,
                ),
              );
            },
          );
        } else {
          return const Center(child: Text("No posts found."));
        }
      },
    );
  }
}

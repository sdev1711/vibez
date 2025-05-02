import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_text.dart';

class UserVideos extends StatefulWidget {
  const UserVideos({super.key});

  @override
  State<UserVideos> createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {
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
                  textSize: 15.sp,
                ),
              ],
            );
          }
          return BlocBuilder<UserProfileCubit, UserProfileState>(
            builder: (context, state) {
              if (state is UserProfileLoaded) {
                user = state.user;
              }
              final videoPosts = posts.where((post) => post.postType == PostType.video).toList();
              final reversedPosts = videoPosts.reversed.toList();
              return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  mainAxisExtent: 200.h
                ),
                  itemCount:reversedPosts.length,
                  itemBuilder: (context, index){
                    final post = reversedPosts[index];
                    return GestureDetector(
                      onTap: () {
                       Get.toNamed(AppRoutes.clipViewScreen,arguments: reversedPosts);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: post.postType==PostType.image?Image.network(
                          post.imageUrl,
                          fit: BoxFit.cover,
                        ):Image.asset(ImagePath.defaultVideoCover,fit: BoxFit.cover,),
                      ),
                    );
                  }
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

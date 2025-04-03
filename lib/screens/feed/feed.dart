import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_textfield.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<PostModel> postData;

  @override
  void initState() {
   context.read<FeedPostCubit>().fetchAllPosts();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          SizedBox(
            height: 50.h,
          ),
          Row(
            spacing: 5.w,
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: CommonTextField(
                    readOnly: true,
                    hintText: "${LocaleKeys.search.tr}...",
                    prefixIcons: Image.asset(
                      ImagePath.searchIcon,
                      color: AppColors.to.contrastThemeColor,
                      scale: 25,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    fillColor: AppColors.to.contrastThemeColor.withOpacity(0.5),
                    maxLines: 1,
                    textInputAction: TextInputAction.go,
                    onTap: () {
                      Get.toNamed(AppRoutes.searchScreen,arguments: {'openKeyBoard':true});
                    },
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          BlocBuilder<FeedPostCubit, FeedPostState>(
            builder: (context,state){
              if (state is FeedPostLoading) {
                return Center(child: CircularProgressIndicator(color: AppColors.to.contrastThemeColor,));
              }else if (state is FeedPostLoaded){
                postData=state.posts;
                return GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 150,
                  ),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: postData.length,
                  itemBuilder: (context, index) {
                    final post = postData[index];
                    return GestureDetector(
                      onTap: () {
                      Get.toNamed(AppRoutes.feedPostViewScreen,arguments: post);
                      },
                      child: Container(
                        width: 200.w,
                        decoration: BoxDecoration(
                            color: AppColors.to.contrastThemeColor,
                            image: DecorationImage(
                                image: NetworkImage(
                                  post.imageUrl,
                                ),
                                fit: BoxFit.cover,
                            ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                );
              }
               return SizedBox();
            },
          ),
        ],
      ),
    );
  }
}

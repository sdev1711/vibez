import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/feed_post/feed_post_cubit.dart';
import 'package:vibez/Cubit/post/post_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/comment_model.dart';
import 'package:vibez/model/post_model.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/repository/post_repository.dart';
import 'package:vibez/widgets/common_alert_dialog.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';

class CommentScreen extends StatefulWidget {
  final PostModel? postData;
  final UserModel? userData;
  const CommentScreen({super.key,this.postData,this.userData});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  late PostModel postData;
  late UserModel userData;
  ApiService apiService = ApiService();
  @override
  void initState() {
    postData = widget.postData ?? Get.arguments["postData"];
    userData = widget.userData ?? Get.arguments["userData"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.to.darkBgColor,
        body: Column(
          children: [
            CommonSoraText(text: "Comment",color:AppColors.to.contrastThemeColor ,textSize: 12.sp,),
            Expanded(
              child: SingleChildScrollView(
                // reverse: true,
                child: StreamBuilder<List<CommentModel>>(
                  stream: context.read<PostCubit>().streamComments(postData.postId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("No comments yet"));
                    }

                    final comments = snapshot.data!.reversed;

                    return Column(
                      children: comments.map((comment) {
                        return GestureDetector(
                          onLongPress: (){
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => CommonAlertDialog(
                                title: Center(
                                  child: CommonSoraText(
                                    text: "Delete comment",
                                    textSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.to.contrastThemeColor,
                                  ),
                                ),
                                actions: [
                                  Row(
                                    children: [
                                      CommonButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        bgColor: Colors.transparent,
                                        boxBorder: Border.all(
                                            width: 2,
                                            color: AppColors.to.contrastThemeColor),
                                        height: 40.h,
                                        width: 100.w,
                                        child: CommonSoraText(
                                          text: LocaleKeys.no.tr,
                                          color: AppColors.to.contrastThemeColor,
                                          textSize: 15,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      CommonButton(
                                        onPressed: () {
                                          PostRepository().deleteComment(postData.postId, comment);
                                          Navigator.of(context).pop();
                                        },
                                        bgColor: AppColors.to.contrastThemeColor,
                                        height: 40.h,
                                        width: 100.w,
                                        child: CommonSoraText(
                                          text: LocaleKeys.yes.tr,
                                          color: AppColors.to.darkBgColor,
                                          textSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(comment.profileImage),
                            ),
                            title: Row(
                              children: [
                                CommonSoraText(
                                  text: userData.username,
                                  color: AppColors.to.contrastThemeColor,
                                  fontWeight: FontWeight.w500,
                                  textSize: 16,
                                ),
                                SizedBox(width: 10),
                                CommonSoraText(
                                  text: timeago.format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      int.parse(comment.timestamp),
                                    ),
                                    locale: 'en_short',
                                  ).replaceAll("~", ""),
                                  color: AppColors.to.contrastThemeColor,
                                  textSize: 12,
                                ),
                              ],
                            ),
                            subtitle: CommonSoraText(
                              text: comment.text,
                              color: AppColors.to.contrastThemeColor,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right:10.0),
                      child: CommonTextField(
                        controller: _commentController,
                        hintText: "Add a comment",
                      ),
                    ),
                  ),
                  CommonIconButton(
                    iconData:Icons.send,
                    onTap: () {
                      if (_commentController.text.isNotEmpty) {
                        final newComment = CommentModel(
                          commentId: DateTime.now().millisecondsSinceEpoch.toString(),
                          userId: ApiService.user.uid,
                          text: _commentController.text.trim(),
                          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                          profileImage: ApiService.me.image,
                        );

                        context.read<PostCubit>().addComment(postData.postId, newComment);
                        context.read<FeedPostCubit>().fetchFollowingPosts();
                        _commentController.clear();
                      }
                    }, size: 25, color: AppColors.to.contrastThemeColor,
                  ),
                ],
              ),
            ),
          ],
        ),


      ),
    );
  }
}

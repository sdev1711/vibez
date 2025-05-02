import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/user/user_cubit.dart';
import 'package:vibez/Cubit/user/user_state.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/widget_helper.dart';

class SuggestedUserWidget extends StatelessWidget {
  const SuggestedUserWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: ApiService.firestore
            .collection('users')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return errorText("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {
            return errorText("No users found");
          }
          String myId = ApiService.user.uid;
          List<UserModel> users = snapshot.data!.docs
              .map((doc) => UserModel.fromJson(
              doc.data() as Map<String, dynamic>))
              .where(
                  (user) => !user.followers.contains(myId))
              .toList();
          return SizedBox(
            height: 80.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if (user.uid == myId) {
                  return const SizedBox(); // Return an empty widget
                }
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(
                        AppRoutes.otherUserProfileScreen,
                        arguments: user);
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 10.0),
                    child: Container(
                      width: 220.w,
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color:
                        AppColors.to.contrastThemeColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                spacing: 10.w,
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors
                                        .to
                                        .contrastThemeColor,
                                    backgroundImage: user
                                        .image
                                        .isNotEmpty
                                        ? NetworkImage(
                                        user.image)
                                        : AssetImage(ImagePath
                                        .profileIcon),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(
                                        context)
                                        .size
                                        .width *
                                        0.24,
                                    child: CommonSoraText(
                                      text: user.username,
                                      color: AppColors
                                          .to.darkBgColor,
                                      maxLine: 1,
                                      softWrap: true,
                                      textSize: 12.sp,
                                      textOverflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            BlocBuilder<UserCubit,
                                UserState>(
                              builder:
                                  (context, userState) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<UserCubit>()
                                        .toggleFollow(
                                        myId, user.uid);
                                    context
                                        .read<
                                        UserProfileCubit>()
                                        .fetchUserProfile();
                                    (context as Element)
                                        .markNeedsBuild();
                                  },
                                  child: Container(
                                    height: 25.h,
                                    width: 100.h,
                                    decoration:
                                    BoxDecoration(
                                      color: AppColors
                                          .to.darkBgColor,
                                      borderRadius:
                                      BorderRadius
                                          .circular(10),
                                    ),
                                    child: Center(
                                      child: userState
                                      is UserLoading
                                          ? SizedBox(
                                        height: 17,
                                        width: 17,
                                        child:
                                        CircularProgressIndicator(
                                          color: AppColors
                                              .to
                                              .contrastThemeColor,
                                        ),
                                      )
                                          : CommonSoraText(
                                        text: user
                                            .followers
                                            .contains(
                                            myId)
                                            ? LocaleKeys
                                            .unfollow
                                            .tr
                                            : (user.followRequests.contains(
                                            myId)
                                            ? 'Cancel req.'
                                            : LocaleKeys
                                            .follow
                                            .tr),
                                        color: AppColors
                                            .to
                                            .contrastThemeColor,
                                        fontWeight:
                                        FontWeight
                                            .w500,
                                        textSize: 12.sp,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

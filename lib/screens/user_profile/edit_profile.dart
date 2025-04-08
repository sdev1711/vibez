import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/user/user_cubit.dart';
import 'package:vibez/Cubit/user/user_state.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_icon_button.dart';
import 'package:vibez/widgets/common_text.dart';
import 'package:vibez/widgets/common_textfield.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserModel userModel;
  final formKey=GlobalKey<FormState>();
  @override
  void initState() {
    userModel = Get.arguments ??
        UserModel(
            username: "",
            name: "name",
            email: "email",
            uid: "uid",
            about: 'about',
            createdAt: "createdAt",
            lastActive: "lastActive",
            pushToken: "pushToken",
            image: "image",
            isOnline: false,
            isPrivate: false,
          postCount: 0,
          userScore: 0,
          lastOpenedDate: '',
        );
    log(userModel.username);
    context.read<UserCubit>().fetchUserProfile(userModel.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserUpdated) {
            final nameController = TextEditingController(text: state.user.name);
            final userNameController =
                TextEditingController(text: state.user.username);
            final aboutController =
                TextEditingController(text: state.user.about);
            log("image if user ${state.user.image}");
            log("image if user ${state.user.username}");
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 75.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        color: AppColors.to.darkBgColor, // color:Colors.white,
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Row(
                                children: [
                                  CommonIconButton(
                                    iconData: Icons.arrow_back_rounded,
                                    size: 25,
                                    color: AppColors.to.contrastThemeColor,
                                    onTap: Navigator.of(context).pop,
                                  ),
                                  SizedBox(width: 15.w),
                                  CommonSoraText(
                                    text: LocaleKeys.editProfile.tr,
                                    color: AppColors.to.contrastThemeColor,
                                    textSize: 20,
                                  ),
                                ],
                              ),
                            ),
                            CommonIconButton(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  userCubit.updateUserProfile(userModel.uid, {
                                    "name": nameController.text.trim(),
                                    "username": userNameController.text.trim(),
                                    "about": aboutController.text.trim(),
                                  });
                                  context.read<UserProfileCubit>()
                                      .fetchUserProfile();
                                }
                              },
                              iconData: Icons.done_rounded,
                              size: 30,
                              color: AppColors.to.contrastThemeColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),

                    /// **Profile Image**
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: state.user.image.isNotEmpty
                                ? NetworkImage(state.user.image)
                                : AssetImage(ImagePath.profileIcon)
                                    as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                userCubit.pickAndUploadImage(userModel.uid);
                              },
                              child: Icon(
                                Icons.add_circle,
                                color: AppColors.to.contrastThemeColor,
                                size: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// **Name Field**
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:5.0),
                            child: CommonSoraText(text: LocaleKeys.enterName.tr, color: AppColors.to.contrastThemeColor),
                          ),
                          CommonTextField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),

                          /// **Username Field**
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:5.0),
                            child: CommonSoraText(text: LocaleKeys.userName.tr, color: AppColors.to.contrastThemeColor),
                          ),
                          CommonTextField(
                            controller: userNameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a username';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20.h),

                          /// **Bio Field**
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical:5.0),
                            child: CommonSoraText(text: LocaleKeys.bio.tr, color: AppColors.to.contrastThemeColor),
                          ),
                          CommonTextField(
                            controller: aboutController,
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            );
          } else if (state is UserLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppColors.to.contrastThemeColor,
            ));
          }
          return Container();
        },
      ),
    );
  }
}

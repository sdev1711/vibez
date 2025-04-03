import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/Cubit/user_profile_data/user_profile_cubit.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/controllers/bottom_navigation_controller.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/model/user_model.dart';
import 'package:vibez/screens/clips/clip_screen.dart';
import 'package:vibez/screens/feed/feed.dart';
import 'package:vibez/screens/home/home_screen.dart';
import 'package:vibez/screens/notifications/notifications_screen.dart';
import 'package:vibez/screens/post/add_post/add_post_screen.dart';
import 'package:vibez/screens/post/select_post_type.dart';
import 'package:vibez/screens/user_profile/profile_screen.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_alert_dialog.dart';
import 'package:vibez/widgets/common_button.dart';
import 'package:vibez/widgets/common_text.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;
  int iconIndex = 0;
  final List<Widget> pageList = [
    const HomeScreen(),
    const FeedScreen(),
    const SelectPostType(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  UserModel? userModel;
  ApiService apiService = ApiService();
  final BottomNavController bottomNavController = Get.find<BottomNavController>();
  @override
  void initState() {
    SystemChannels.lifecycle.setMessageHandler((message) {
      log("main screen message $message ");
      if (ApiService.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          ApiService.updateUserActiveStatus(true);
        }
        if (message.toString().contains('paused')) {
          ApiService.updateUserActiveStatus(false);
        }if (message.toString().contains('inactive')) {
          ApiService.updateUserActiveStatus(false);
        }
      }
      return Future.value(message);
    });
    ApiService.getSelfInfo();
    context.read<UserProfileCubit>().fetchUserProfile();
    super.initState();
    // SharedPrefs.setOnBoard(false);
  }

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitDialog(context);
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.to.darkBgColor,
        body: Obx(() => pageList[bottomNavController.pageIndex.value]),
        bottomNavigationBar: Container(
          height: 60.h,
          decoration: BoxDecoration(
            color: AppColors.to.darkBgColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                // text: LocaleKeys.home.tr,
                iconPath: ImagePath.homeIcon,
                index: 0,
                screenHeight: 23.h,
              ),
              _buildNavItem(
                // text: LocaleKeys.search.tr,
                iconPath: ImagePath.searchIcon,
                index: 1,
                screenHeight: 23.h,
              ),
              _buildNavItem(
                // text: "Post",
                iconPath: ImagePath.postIcon,
                index: 2,
                screenHeight: 27.h,
              ),
              _buildNavItem(
                // text: LocaleKeys.notification.tr,
                iconPath: ImagePath.notificationIcon,
                index: 3,
                screenHeight: 23.h,
              ),
              _buildNavItem(
                // text: LocaleKeys.profile.tr,
                iconPath: ImagePath.profileIcon,
                index: 4,
                screenHeight: 23.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required int index,
    required double screenHeight,
  }) {
    final BottomNavController bottomNavController = Get.find<BottomNavController>();
    return GestureDetector(
      onTap: () {
        bottomNavController.changeIndex(index);
      },
      child: Obx((){
        bool isSelected = bottomNavController.pageIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isSelected
                ? Column(
              children: [
                Container(
                  width: 60.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      color: AppColors.to.primaryBgColor.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ImageIcon(
                      AssetImage(iconPath),
                      color: isSelected
                          ? AppColors.to.contrastThemeColor
                          : AppColors.to.contrastThemeColor.withOpacity(0.5),
                      size: screenHeight,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 3.0),
                //   child: CommonSoraText(
                //     text: text??"",
                //     color: AppColors.to.contrastThemeColor,
                //     textSize: 12,
                //     fontWeight: FontWeight.bold,
                //   ),
                // )
              ],
            )
                : Column(
              children: [
                Container(
                  width: 60.w,
                  height: 35.h,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: ImageIcon(
                      AssetImage(iconPath),
                      color: isSelected
                          ? AppColors.to.contrastThemeColor
                          : AppColors.to.contrastThemeColor.withOpacity(0.5),
                      size: screenHeight,
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 3.0),
                //   child: CommonSoraText(
                //     text: text??"",
                //     color: AppColors.to.contrastThemeColor,
                //     textSize: 12,
                //     fontWeight: FontWeight.w400,
                //   ),
                // )
              ],
            )
          ],
        );
      }),
    );
  }
}

Future<bool?> _showExitDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => CommonAlertDialog(
      title: Center(
        child: CommonSoraText(
          text: LocaleKeys.exitApp.tr,
          textSize: 18,
          fontWeight: FontWeight.w500,
          color: AppColors.to.contrastThemeColor,
        ),
      ),
      content: CommonSoraText(
        text: LocaleKeys.exitFromApp.tr,
        color: AppColors.to.contrastThemeColor,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            CommonButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              bgColor: Colors.transparent,
              boxBorder:
                  Border.all(width: 2, color: AppColors.to.contrastThemeColor),
              height: 40.h,
              width: 100.w,
              child: CommonSoraText(
                text: LocaleKeys.no.tr,
                color: AppColors.to.contrastThemeColor,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            CommonButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              bgColor: AppColors.to.contrastThemeColor,
              height: 40.h,
              width: 100.w,
              child: CommonSoraText(
                text: LocaleKeys.yes.tr,
                color: AppColors.to.darkBgColor,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/generated/locales.g.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';

class HomeTabletLayout extends StatefulWidget {
  const HomeTabletLayout({super.key});

  @override
  State<HomeTabletLayout> createState() => _HomeTabletLayoutState();
}

class _HomeTabletLayoutState extends State<HomeTabletLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonTitle(
          text: LocaleKeys.vibez.tr,
          color: AppColors.to.contrastThemeColor,
          textSize: 25,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.messageScreen);
              },
              child: Container(
                color: Colors.transparent,
                width: 40.w,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ImageIcon(
                    AssetImage(ImagePath.messageIcon),
                    color: AppColors.to.contrastThemeColor,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 250.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.to.contrastThemeColor,
                      ),
                      child: Center(
                        child: CommonSoraText(
                          text: "Home tablet",
                          color: AppColors.to.darkBgColor,
                          textSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Container(
                      height: 500.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.to.contrastThemeColor,
                      ),
                      child: Center(
                        child: CommonSoraText(
                          text: "Home tablet",
                          color: AppColors.to.darkBgColor,
                          textSize: 30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              height: 100.h,
                              width: 300.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.to.contrastThemeColor
                                    .withOpacity(0.5),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

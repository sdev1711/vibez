import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vibez/app/app_route.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/utils/image_path/image_path.dart';
import 'package:vibez/widgets/common_appBar.dart';
import 'package:vibez/widgets/common_text.dart';

class SelectPostType extends StatelessWidget {
  const SelectPostType({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.to.darkBgColor,
      appBar: CommonAppBar(
        title: CommonSoraText(
          textSize: 17,
          text: "Select post type",
          color: AppColors.to.contrastThemeColor,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 50.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.addPostScreen);
                },
                child: Column(
                  spacing: 5,
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.to.contrastThemeColor, width: 2),
                      ),
                      child: Center(
                        child: ImageIcon(
                          AssetImage(ImagePath.postImageIcon),
                          color: AppColors.to.contrastThemeColor,
                          size: 40,
                        ),
                      ),
                    ),
                    CommonSoraText(
                      text: "Image",
                      color: AppColors.to.contrastThemeColor,
                      textSize: 15,
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.toNamed(AppRoutes.addClipScreen);
                },
                child: Column(
                  spacing: 5,
                  children: [
                    Container(
                      height: 100.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.to.contrastThemeColor, width: 2),
                      ),
                      child: Center(
                        child: ImageIcon(
                          AssetImage(ImagePath.postClipIcon),
                          color: AppColors.to.contrastThemeColor,
                          size: 40,
                        ),
                      ),
                    ),
                    CommonSoraText(
                      text: "Clip",
                      color: AppColors.to.contrastThemeColor,
                      textSize: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

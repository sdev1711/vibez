import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vibez/app/colors.dart';
import 'common_text.dart';

class OnBoardingWidget extends StatelessWidget {
  const OnBoardingWidget({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });
  final String title;
  final String description;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 800.h,
          width: 312.w,
          color: AppColors.to.primaryBgColor,
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
              ),
              SizedBox(
                height: 300.h,
                width: 250.w,
                child: SvgPicture.asset(imagePath,),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top:400.h),
          child: Container(
            height: 800.h,
            decoration: BoxDecoration(
              color: AppColors.to.white,
              borderRadius: BorderRadius.only(topLeft:Radius.circular(50),topRight: Radius.circular(50)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CommonSoraText(
                    text: title,
                    color: AppColors.to.primaryBgColor,
                    textAlign: TextAlign.center,
                    textSize: 20,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: CommonSoraText(
                    text: description,
                    color: AppColors.to.primaryBgColor,
                    textAlign: TextAlign.center,
                    textSize: 13,
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}

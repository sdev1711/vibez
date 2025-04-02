import 'package:flutter/material.dart';
import 'package:vibez/app/colors.dart';
import 'package:vibez/widgets/common_text.dart';

class Dialogs{
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CommonSoraText(
            text: msg,
            color: AppColors.to.white,
        ),
        backgroundColor: AppColors.to.primaryBgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

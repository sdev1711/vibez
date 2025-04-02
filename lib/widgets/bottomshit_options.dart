import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vibez/app/colors.dart';
import 'common_text.dart';

class OptionItem extends StatelessWidget {
  final IconData? icon;
  final String name;
  final VoidCallback onTap;
  const OptionItem(
      {super.key, this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Row(
          spacing: 10.w,
          children: [
            if(icon != null)Icon(
              icon,
              color: name == "Read at"
                  ? Colors.blue.shade400
                  : AppColors.to.contrastThemeColor,
              size: 25,
            ),
            Flexible(
              child: CommonSoraText(
                text: name,
                color: AppColors.to.contrastThemeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonIconButton extends StatelessWidget {
  const CommonIconButton({
    super.key,
    required this.iconData,
    required this.size,
    required this.color,
    this.onTap,
  });
  final IconData? iconData;
  final double? size;
  final Color? color;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap:onTap,
      child: SizedBox(
        width: 25.w,
        height: 30.h,
        child: Icon(
          iconData,
          size: size,
          color: color,
        ),
      ),
    );
  }
}

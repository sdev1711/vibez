import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    required this.onPressed,
    required this.bgColor,
    required this.height,
    required this.width,
    required this.child,
    this.boxBorder,
  });

  final VoidCallback onPressed;
  final Color bgColor;
  final double height;
  final double width;
  final Widget child;
  final BoxBorder? boxBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: GestureDetector(
        key: key,
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bgColor,
            border: boxBorder,
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common_text.dart';

class CommonTextButton extends StatelessWidget {
  const CommonTextButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final void Function()? onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        overlayColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
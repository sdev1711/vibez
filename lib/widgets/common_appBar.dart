import 'package:flutter/material.dart';
import 'package:vibez/app/colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.automaticallyImplyLeading,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final bool? automaticallyImplyLeading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: flexibleSpace,
      backgroundColor: AppColors.to.darkBgColor,
      title: title,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(15),
        ),
      ),
      automaticallyImplyLeading:automaticallyImplyLeading??true ,
      surfaceTintColor: Colors.transparent,
      leading:leading ?? SizedBox.shrink(),
      leadingWidth: leading == null ? 0 : kToolbarHeight,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

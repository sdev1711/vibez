import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibez/app/colors.dart';


class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final String? hintText;
  final String? labelText;
  final bool? obscured;
  final bool? readOnly;
  final AutovalidateMode? autovalidateMode;
  final bool? passSecured;
  final Widget? icons;
  final Image? prefixIcons;
  final TextStyle? labelTextStyle;
  final UnderlineInputBorder? underlineInputBorder;
  final String? obscuredCharacter;
  final InputDecoration? inputDecoration;
  final Widget? iconButton;
  final TextInputType? textInputType;
  final FormFieldValidator? validator;
  final TextInputType? keyboardType;
  final ValueChanged? nextField;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final BorderRadius? borderRadius;
  final OutlineInputBorder? outlineInputBorder;
  final int? maxLines;
  final String? initialValue;
  final Color? color;
  final bool? expand;
  final InputBorder? enabledBorder;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final InputBorder? focusedBorder;
  final List<TextInputFormatter>? textInputFormatter;
  final InputBorder? inputBorder;
  final GestureTapCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  ValueChanged<String>? onChanged;
  void Function(String)? onSubmitted;
  final Color? fillColor;
  CommonTextField({
    super.key,
    this.enabledBorder,
    this.contentPadding,
    this.errorBorder,
    this.focusedBorder,
    this.focusedErrorBorder,
    this.onSubmitted,
    this.fillColor,
    this.onChanged,
    this.inputBorder,
    this.onTap,
    this.autovalidateMode,
    this.readOnly,
    this.color,
    this.initialValue,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.obscured,
    this.icons,
    this.labelTextStyle,
    this.underlineInputBorder,
    this.obscuredCharacter,
    this.inputDecoration,
    this.textInputFormatter,
    this.iconButton,
    this.textInputType,
    this.passSecured,
    this.validator,
    this.prefixIcons,
    this.keyboardType,
    this.nextField,
    this.textInputAction,
    this.textCapitalization,
    this.borderRadius,
    this.outlineInputBorder,
    this.maxLines,
    this.autoFocus,
    this.expand,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      autofocus: autoFocus ?? false,
      autovalidateMode: autovalidateMode,
      inputFormatters: textInputFormatter,
      onTap: onTap,
      onChanged: onChanged,
      readOnly: readOnly ?? false,
      style: GoogleFonts.sora(
        color: AppColors.to.white,
      ),
      initialValue: initialValue,
      textInputAction: textInputAction,
      // textCapitalization:TextCapitalization.words,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      controller: controller,
      obscureText: obscured ?? false,
      keyboardType: keyboardType,
      obscuringCharacter: obscuredCharacter ?? "*",
      cursorColor: AppColors.to.white,
      cursorOpacityAnimates: true,
      expands: expand ?? false,
      maxLines: maxLines,
      textAlignVertical: TextAlignVertical.top,
      decoration: InputDecoration(
        border: inputBorder,
        filled: true,
        fillColor: fillColor ?? AppColors.to.authenticationBgColor,
        suffixIcon: icons,
        // prefix: Icon,
        labelText: labelText,
        labelStyle: labelTextStyle,
        hintText: hintText,
        hintStyle: GoogleFonts.sora(
          textStyle: TextStyle(fontSize: 13),
          color: AppColors.to.white.withOpacity(0.5),
        ),
        prefixIcon: prefixIcons,
        suffix: iconButton,
        contentPadding: contentPadding,
        enabledBorder: enabledBorder??OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.to.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: focusedBorder??OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.to.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: errorBorder??OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.to.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: focusedErrorBorder??OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: AppColors.to.white),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
    );
  }
}

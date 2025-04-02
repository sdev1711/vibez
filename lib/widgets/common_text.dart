import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonSoraText extends StatelessWidget {
  final String text;
  final double? textSize;
  final double? letterSpacing;
  final Color? color;
  final List<Color>? gradientColors;
  final TextDecoration? textDecoration;
  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  const CommonSoraText({
    super.key,
    required this.text,
    this.color,
    this.gradientColors,
    this.textAlign,
    this.textOverflow,
    this.fontWeight,
    this.textDecoration,
    this.maxLine,
    this.textSize,
    this.softWrap,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    if (gradientColors != null && gradientColors!.length > 1) {
      return ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          text,
          textAlign: textAlign,
          softWrap: softWrap,
          overflow: textOverflow,
          maxLines: maxLine,
          style: GoogleFonts.sora(
            color: Colors.white, // Required for ShaderMask to apply gradient
            fontWeight: fontWeight,
            fontSize: textSize,
            decoration: textDecoration,
            letterSpacing: letterSpacing,
          ),
        ),
      );
    } else {
      return Text(

        text,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: textOverflow,
        maxLines: maxLine,
        style: GoogleFonts.sora(
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          fontSize: textSize,
          decoration: textDecoration,
          letterSpacing: letterSpacing,
        ),
      );
    }
  }
}

class CommonTitle extends StatelessWidget {
  final String text;
  final double? textSize;
  final double? letterSpacing;
  final Color? color;
  final List<Color>? gradientColors;
  final TextDecoration? textDecoration;
  final FontWeight? fontWeight;
  final int? maxLine;
  final TextOverflow? textOverflow;
  final TextAlign? textAlign;
  final bool? softWrap;

  const CommonTitle({
    super.key,
    required this.text,
    this.color,
    this.gradientColors,
    this.textAlign,
    this.textOverflow,
    this.fontWeight,
    this.textDecoration,
    this.maxLine,
    this.textSize,
    this.softWrap,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    if (gradientColors != null && gradientColors!.length > 1) {
      return ShaderMask(
        shaderCallback: (bounds) {
          return LinearGradient(
            colors: gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: Text(
          text,
          textAlign: textAlign,
          softWrap: softWrap,
          overflow: textOverflow,
          maxLines: maxLine,
          style: GoogleFonts.merienda(
            color: Colors.white,
            fontWeight: fontWeight,
            fontSize: textSize,
            decoration: textDecoration,
            letterSpacing: letterSpacing,
          ),
        ),
      );
    } else {
      return Text(
        text,
        textAlign: textAlign,
        softWrap: softWrap,
        overflow: textOverflow,
        maxLines: maxLine,
        style: GoogleFonts.merienda(
          color: color ?? Colors.black,
          fontWeight: fontWeight,
          fontSize: textSize,
          decoration: textDecoration,
          letterSpacing: letterSpacing,
        ),
      );
    }
  }
}


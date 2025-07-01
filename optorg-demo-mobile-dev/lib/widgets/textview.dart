import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class TextView extends StatelessWidget {
  final String? text;
  final Color textColor;
  final String textFont;
  final bool textAllCaps;
  final double textSize;
  final bool isBold;
  final TextAlign textAlign;
  final bool underlined;
  final double? height;
  final int? maxLines;
  final TextOverflow? textOverflow;
  final FontWeight? fontWeight;

  TextView(
      {@required this.text,
      this.textColor = Colors.black,
      this.textFont = POPPINS_MEDIUM,
      this.textAllCaps = false,
      this.textSize = DEFAULT_TEXT_SIZE,
      this.isBold = false,
      this.textAlign = TextAlign.center,
      this.underlined = false,
      this.height,
      this.maxLines,
      this.fontWeight,
      this.textOverflow});

  @override
  Widget build(BuildContext context) {
    return Text(
      textAllCaps ? text!.toUpperCase() : text!,
      maxLines: maxLines,
      style: textStyle(
          underlined: underlined,
          textFont: textFont,
          textOverflow: textOverflow,
          textSize: textSize,
          textColor: textColor,
          fontWeight: fontWeight,
          isBold: isBold,
          height: height),
      textAlign: textAlign,
    );
  }

  static TextStyle textStyle(
      {bool underlined = false,
      String textFont = POPPINS_MEDIUM,
      TextOverflow? textOverflow,
      double textSize = DEFAULT_TEXT_SIZE,
      Color textColor = Colors.black,
      FontWeight? fontWeight,
      bool isBold = false,
      double? height}) {
    return TextStyle(
      decoration: underlined ? TextDecoration.underline : null,
      fontFamily: textFont,
      overflow: textOverflow,
      fontSize: textSize.spResponsive(),
      color: textColor,
      fontWeight: fontWeight != null
          ? fontWeight
          : isBold
              ? FontWeight.bold
              : FontWeight.normal,
      height: height != null ? height.heightResponsive() : null,
    );
  }
}

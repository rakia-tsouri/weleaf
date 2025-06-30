import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class AppIconButton extends StatelessWidget {
  final Function? onClickCallback;
  final Color buttonColor;
  final Color? buttonBackgroundColor;
  final Color? buttonBorderColor;
  final Color? buttonDisabledColor;
  final String svgIcon;
  final double? buttonWidth;
  final double? buttonHeight;
  final bool? isDisabled;
  final bool? withPicto;
  AppIconButton(
      {required this.onClickCallback,
      required this.buttonColor,
      this.buttonBackgroundColor,
      this.buttonDisabledColor,
      this.buttonBorderColor,
      required this.svgIcon,
      this.buttonHeight,
      this.buttonWidth,
      this.withPicto = false,
      this.isDisabled});

  @override
  Widget build(BuildContext context) {
    Color applyColor = (isDisabled == true)
        ? (buttonDisabledColor ?? Colors.grey.shade300)
        : buttonColor;
    Color borderColor = buttonBorderColor ?? applyColor;
    return InkWell(
      onTap: () {
        if (isDisabled != true) {
          onClickCallback?.call();
        }
      },
      child: Padding(
          padding: EdgeInsets.all(0),
          child: Container(
              width: buttonWidth ?? PADDING_70.widthResponsive(),
              height: buttonHeight ?? PADDING_35.heightResponsive(),
              padding: EdgeInsets.all(PADDING_5),
              decoration: BoxDecoration(
                color: buttonBackgroundColor ?? applyColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                border: Border.all(color: borderColor // border color
                    ),
              ),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Center(
                    child: SvgPicture.asset(
                      svgIcon,
                      width: PADDING_25.widthResponsive(),
                      colorFilter:
                          ColorFilter.mode(applyColor, BlendMode.srcIn),
                    ),
                  ),
                  (withPicto == true)
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: SvgPicture.asset(
                            POINT_ORDER_ITEM_ICON,
                            width: PADDING_8.widthResponsive(),
                            colorFilter: ColorFilter.mode(
                                Colors.red.shade800, BlendMode.srcIn),
                          ))
                      : Container(),
                ],
              ))),
    );
  }
}

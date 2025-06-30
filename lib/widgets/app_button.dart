import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class AppButton extends StatelessWidget {
  final Function? onClickCallback;
  final String buttonText;
  final Color buttonColor;
  final double buttonWidth;
  final double buttonHeight;
  final double textSize;
  final bool textInUppercase;
  final bool outlined;
  final Color textColor;
  final Color? borderColor;
  final bool withNewStyle;
  final bool isDisabled;
  final bool isBold;
  final Widget? icon;
  final bool withSplashEffect;

  AppButton(
      {@required this.onClickCallback,
      this.buttonText = NEXT,
      this.buttonColor = PRIMARY_BLUE_COLOR,
      this.buttonWidth = BUTTON_WIDTH,
      this.buttonHeight = BUTTON_HEIGHT,
      this.textSize = MAIN_BUTTON_TITLE_SIZE,
      this.textInUppercase = false,
      this.outlined = false,
      this.isBold = false,
      this.textColor = Colors.white,
      this.borderColor,
      this.withNewStyle = false,
      this.isDisabled = false,
      this.icon,
      this.withSplashEffect = false});

  @override
  Widget build(BuildContext context) {
    Color newStyleTextColor =
        APP_PRIMARY_COLOR.withOpacity(isDisabled ? 0.4 : 1);
    Color newStyleBackgroundColor =
        isDisabled ? BOTTOM_BAR_BACKGROUND : APP_SECONDARY_COLOR;

    final double splashEffectSize = buttonWidth.widthResponsive() * 0.25;

    return InkWell(
      onTap: () {
        if (!isDisabled) {
          onClickCallback?.call();
        }
      },
      child: Container(
        width: buttonWidth.widthResponsive(),
        height: buttonHeight.heightResponsive(),
        decoration: BoxDecoration(
            color: outlined
                ? Colors.white
                : !withNewStyle
                    ? buttonColor.withOpacity(isDisabled ? 0.4 : 1)
                    : newStyleBackgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: outlined
                ? Border.all(color: buttonColor, width: 1)
                : borderColor != null
                    ? Border.all(color: borderColor!, width: 1)
                    : !withNewStyle
                        ? null
                        : Border.all(
                            color: APP_PRIMARY_COLOR
                                .withOpacity(isDisabled ? 0.2 : 0.6),
                            width: 1)),
        child: Stack(
          children: [
            Positioned.fill(
                child: Padding(
              padding: const EdgeInsets.all(PADDING_2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: _hasIcon() ? PADDING_15.widthResponsive() : 0,
                  ),
                  Expanded(
                    child: TextView(
                      text: buttonText,
                      textAlign: TextAlign.center,
                      textColor: outlined
                          ? buttonColor
                          : !withNewStyle
                              ? textColor
                              : newStyleTextColor,
                      textSize: textSize,
                    ),
                  ),
                  SizedBox(
                    width: _hasIcon() ? PADDING_3.widthResponsive() : 0,
                  ),
                  icon != null ? icon! : Container(),
                  SizedBox(
                    width: _hasIcon() ? PADDING_15.widthResponsive() : 0,
                  ),
                ],
              ),
            )),
            Positioned(
                bottom:
                    (buttonHeight.heightResponsive() - splashEffectSize) / 2,
                right: -(splashEffectSize * 0.1),
                width: splashEffectSize,
                height: splashEffectSize,
                child: withSplashEffect ? _renderSplashEffect() : Container()),
          ],
        ),
      ),
    );
  }

  Widget _renderSplashEffect() {
    final double splashWidth = buttonWidth * 0.2;
    return Container(
      width: splashWidth,
      height: splashWidth,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
    );
  }

  bool _hasIcon() {
    return icon != null;
  }
}

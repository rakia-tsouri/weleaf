import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/utils/utils.dart';
import 'package:optorg_mobile/widgets/textview.dart';

// ignore: must_be_immutable
class ShadowButton extends StatelessWidget {
  late Color background;
  final String text;
  final Function onPress;
  final bool disabled;
  late Color textColor;
  final bool uppercase;

  ShadowButton(
      {required this.text,
      required this.onPress,
      required this.background,
      required this.textColor,
      this.disabled = false,
      this.uppercase = true});

  ShadowButton.white(
      {required this.text,
      required this.onPress,
      this.disabled = false,
      this.uppercase = true}) {
    background = Colors.white;
    textColor = PRIMARY_BLUE_COLOR;
  }

  ShadowButton.blue(
      {required this.text,
      required this.onPress,
      this.disabled = false,
      this.uppercase = true}) {
    background = PRIMARY_SKY_BLUE_COLOR;
    textColor = Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!disabled) {
          unfocus();
          onPress.call();
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: APP_BUTTON_SHADOW_WIDTH.widthResponsive(),
              height: APP_BUTTON_HEIGHT.heightResponsive(),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 10,
                  blurRadius: 30,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ]),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: APP_BUTTON_WIDTH.widthResponsive(),
              height: APP_BUTTON_HEIGHT.heightResponsive(),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: disabled ? background.withOpacity(0.5) : background),
              child: Center(
                child: TextView(
                  text: text,
                  textColor: disabled ? textColor.withOpacity(0.5) : textColor,
                  textFont: POPPINS_BOLD,
                  textAllCaps: uppercase,
                  textSize: APP_BUTTON_TEXT_SIZE,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

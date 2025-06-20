import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

import '../constants/colors.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  late String? placeholder;
  final TextEditingController textController;
  late IconData? principalIcon;
  late IconData? secondIcon;
  late Function? onIconPressed;
  final FocusNode? focusNode;
  late bool passwordField;
  late bool obscureText;
  final Function(String)? onSubmit;
  final Function(String)? onEditing;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final String? title;
  final Function? onClick;

  AppTextField(
      {required this.textController,
      this.placeholder,
      this.principalIcon,
      this.secondIcon,
      this.focusNode,
      this.onIconPressed,
      this.obscureText = false,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.enabled = true,
      this.title,
      this.onClick,
      this.onEditing}) {
    passwordField = false;
  }

  AppTextField.password(
      {required this.textController,
      this.focusNode,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.enabled = true,
      this.title,
      this.onClick,
      this.placeholder = PASSWORD,
      this.onEditing}) {
    principalIcon = CupertinoIcons.eye;
    secondIcon = CupertinoIcons.eye_slash;
    passwordField = true;
    obscureText = true;
  }

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late IconData? renderedIcon;
  late bool displayText;

  @override
  void initState() {
    super.initState();
    renderedIcon = widget.principalIcon;
    displayText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onClick?.call();
        },
        child: Container(
            padding: EdgeInsets.only(
                left: PADDING_10.widthResponsive(),
                right: PADDING_10.widthResponsive()),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: PADDING_15.widthResponsive()),
                  width: double.infinity,
                  child: widget.title != null
                      ? TextView(
                          text: widget.title!.toUpperCase(),
                          textSize: APP_INPUT_TITLE_SIZE,
                          textAlign: TextAlign.left,
                          textColor: PRIMARY_BLUE_COLOR,
                        )
                      : Container(),
                ),
                SizedBox(
                  height: PADDING_5.heightResponsive(),
                ),
                Container(
                  height: APP_TEXT_FIELD_HEIGHT.heightResponsive(),
                  padding: EdgeInsets.only(
                    left: PADDING_10.widthResponsive(),
                    right: PADDING_5.widthResponsive(),
                    top: PADDING_3.widthResponsive(),
                    bottom: PADDING_3.widthResponsive(),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.start,
                          controller: widget.textController,
                          obscureText: displayText,
                          focusNode: widget.focusNode,
                          enabled: widget.enabled,
                          textInputAction: widget.textInputAction,
                          keyboardType: widget.keyboardType,
                          onSubmitted: (value) {
                            widget.onSubmit?.call(value);
                          },
                          onChanged: (value) {
                            widget.onEditing?.call(value);
                          },
                          style: TextStyle(
                              fontFamily: POPPINS_REGULAR,
                              fontSize:
                                  APP_TEXT_FIELD_FONT_SIZE.spResponsive()),
                          decoration: InputDecoration(
                              hintText: widget.placeholder,
                              hintStyle: TextStyle(
                                  fontFamily: POPPINS_REGULAR,
                                  fontSize:
                                      APP_TEXT_FIELD_FONT_SIZE.spResponsive(),
                                  color: PLACEHOLDER_TEXT_COLOR),
                              border: InputBorder.none),
                        ),
                      ),
                      renderedIcon.isNotNull()
                          ? Container(
                              width:
                                  APP_TEXT_FIELD_ICON_CIRCLE.widthResponsive(),
                              height:
                                  APP_TEXT_FIELD_ICON_CIRCLE.widthResponsive(),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: APP_BACKGROUND_COLOR),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    widget.passwordField
                                        ? _onIconPressed()
                                        : widget.onIconPressed?.call();
                                  },
                                  child: Icon(
                                    renderedIcon,
                                    color: TEXT_FIELD_ICON_COLOR,
                                    size:
                                        APP_TEXT_FIELD_ICON_SIZE.spResponsive(),
                                  ),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                )
              ],
            )));
  }

  _onIconPressed() {
    setState(() {
      if (widget.secondIcon.isNotNull()) {
        if (renderedIcon == widget.principalIcon) {
          renderedIcon = widget.secondIcon;
        } else {
          renderedIcon = widget.principalIcon;
        }
      }
      if (widget.passwordField) {
        displayText = !displayText;
      }
    });
  }
}

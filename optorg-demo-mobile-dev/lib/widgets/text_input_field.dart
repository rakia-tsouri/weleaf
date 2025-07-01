import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:optorg_mobile/constants/arrays.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/utils/input_validator.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class TextInputField extends StatefulWidget {
  final String? label;
  final TextEditingController textController;
  final bool passwordInput;
  final Widget? suffixIcon;
  final double suffixIconPadding;
  final Function? onSuffixIconClick;
  final Widget? prefixIcon;
  final bool enabled;
  final bool readOnly;
  final TextAlign textAlignement;
  final Color textColor;
  final bool bold;
  final TextInputType inputType;
  final double textSize;
  final double labelSize;
  final double? width;
  final double? height;
  final Function(String)? onSubmitInput;
  final FocusNode? focusNode;
  final Function(String)? onEditing;
  final Function(String)? onClick;

  final double? borderRadius;
  final InputFormatterType inputFormatterType;
  final bool isRequired;
  final Color? disabledBackgroundColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? disabledBorderColor;
  final Color? errorValidationColor;
  final InputValidator? inputValidator;
  final TextInputAction textInputAction;
  final EdgeInsets? contentPadding;
  final int? maxLenght;
  final String? font;
  final bool? autoCorrect;
  final String? prefixText;

  // ********
  // ********
  TextInputField(
      {required this.textController,
      this.label,
      this.passwordInput = false,
      this.onSuffixIconClick,
      this.suffixIconPadding = 8.0,
      this.suffixIcon,
      this.prefixIcon,
      this.enabled = true,
      this.readOnly = false,
      this.textAlignement = TextAlign.start,
      this.textColor = TEXT_INPUT_COLOR,
      this.bold = false,
      this.inputType = TextInputType.text,
      this.textSize = 13,
      this.labelSize = TEXT_FIELD_FONT_SIZE,
      this.focusNode,
      this.onSubmitInput,
      this.onEditing,
      this.borderRadius,
      this.onClick,
      this.inputFormatterType = InputFormatterType.free,
      this.isRequired = false,
      this.disabledBackgroundColor,
      this.backgroundColor = TEXT_FIELD_DEFAULT_BACKGROUND_COLOR,
      this.borderColor = APP_PRIMARY_COLOR,
      this.disabledBorderColor = FADED_GREY_COLOR,
      this.errorValidationColor = TEXT_FIELD_REQUIRED_COLOR,
      this.inputValidator,
      this.textInputAction = TextInputAction.done,
      this.width,
      this.contentPadding,
      this.maxLenght,
      this.font,
      this.height,
      this.autoCorrect = true,
      this.prefixText});

  @override
  _TextInputFieldState createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late bool obscureText;
  late Widget? displaydIcon;

// ***********************
// ***********************
  @override
  void initState() {
    super.initState();
    obscureText = widget.passwordInput;
    displaydIcon = widget.suffixIcon;
  }

// ***********************
// ***********************
  @override
  Widget build(BuildContext context) {
    Color borderColor = widget.borderColor ?? APP_PRIMARY_COLOR;
    Color labelColor = APP_PRIMARY_COLOR;
    if (widget.inputValidator != null && widget.inputValidator!.isError) {
      borderColor = widget.errorValidationColor != null
          ? widget.errorValidationColor!
          : TEXT_FIELD_REQUIRED_COLOR;

      labelColor = borderColor;
    }
    return Container(
      width: widget.width != null
          ? widget.width!.widthResponsive()
          : TEXT_FIELD_DEFAULT_WIDTH.widthResponsive(),
      height: widget.height?.heightResponsive(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
              widget.borderRadius ?? ASSET_PRICE_TEXTFIELD_BORDER_RADIUS),
          color: Colors.white),
      child: TextField(
        readOnly: widget.readOnly,
        autocorrect: widget.autoCorrect != null ? widget.autoCorrect! : true,
        maxLength: widget.maxLenght,
        obscureText: obscureText,
        onTap: () {
          widget.onClick?.call(widget.textController.text);
        },
        textInputAction: widget.textInputAction,
        controller: widget.textController,
        enabled: widget.enabled,
        textAlign: widget.textAlignement,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: widget.inputType,
        focusNode: widget.focusNode,
        inputFormatters: _getInputFormatterType(),
        onChanged: (value) {
          widget.onEditing?.call(value);
        },
        onSubmitted: (String value) {
          widget.onSubmitInput?.call(value);
        },
        style: TextStyle(
            color: widget.textColor,
            fontWeight: widget.bold ? FontWeight.bold : FontWeight.normal,
            fontSize: widget.textSize.spResponsive(),
            fontFamily: widget.font != null ? widget.font : POPPINS_MEDIUM),
        cursorColor: APP_PRIMARY_COLOR,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon,
          prefix: widget.prefixText != null
              ? TextView(
                  text: widget.prefixText,
                  textSize: REGISTER_PREFIX_PHONE_NUMBER_CODE_TEXT_SIZE,
                  textColor: TEXT_INPUT_COLOR,
                )
              : null,
          counterText: '',
          filled: true,
          fillColor: (widget.enabled == false &&
                  widget.disabledBackgroundColor != null)
              ? widget.disabledBackgroundColor
              : widget.backgroundColor,
          isDense: true,
          contentPadding: widget.contentPadding ??
              EdgeInsets.symmetric(
                  vertical: PADDING_13.heightResponsive(),
                  horizontal: PADDING_15.widthResponsive()),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? ASSET_PRICE_TEXTFIELD_BORDER_RADIUS),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? ASSET_PRICE_TEXTFIELD_BORDER_RADIUS),
            borderSide: BorderSide(
                color: widget.disabledBorderColor ?? FADED_GREY_COLOR,
                width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? ASSET_PRICE_TEXTFIELD_BORDER_RADIUS),
            borderSide: BorderSide(color: borderColor, width: 1.2),
          ),
          label: widget.label != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                      //entete du textField
                      TextView(
                          text: widget.label != null ? widget.label! : "",
                          textColor: labelColor,
                          textSize: widget.labelSize.spResponsive()),
                      SizedBox(
                        width: PADDING_5.widthResponsive(),
                      ),
                      Visibility(
                          visible: widget.isRequired,
                          child: TextView(
                              text: "*",
                              textColor: TEXT_FIELD_REQUIRED_COLOR,
                              textSize: TEXT_FIELD_FONT_SIZE.spResponsive())),
                    ])
              : null,
          suffixIcon: displaydIcon == null
              ? null
              : InkWell(
                  onTap: () {
                    widget.onSuffixIconClick?.call();
                    if (widget.passwordInput) {
                      updateTextVisibility();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(widget.suffixIconPadding),
                    child: displaydIcon,
                  )),
        ),
      ),
    );
  }

  // ***********************
  // ***********************
  updateTextVisibility() {
    setState(() {
      obscureText = !obscureText;
      if (obscureText) {
        displaydIcon = const Icon(CupertinoIcons.eye);
      } else {
        displaydIcon = const Icon(CupertinoIcons.eye_slash);
      }
    });
  }

  // ***********************
  // ***********************
  List<TextInputFormatter>? _getInputFormatterType() {
    if (widget.inputFormatterType == InputFormatterType.double) {
      return [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))];
    } else if (widget.inputFormatterType == InputFormatterType.int) {
      return [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))];
    }
    return null;
  }
}

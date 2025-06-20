import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/arrays.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/text_input_field.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class AppSlider extends StatefulWidget {
  final double? minValue;
  final double? maxValue;
  final int? numberOfDivision;
  final Function(double)? onSlideChanged;
  final Function(double)? onSlideChangedEnd;
  final bool withResult;
  final bool rangeOfIntegers;
  final String valuePrefix;
  final String? title;
  final bool isAmount;
  double? selectedValue;

  AppSlider(
      {required this.maxValue,
      required this.minValue,
      required this.onSlideChanged,
      this.numberOfDivision,
      this.withResult = false,
      this.rangeOfIntegers = false,
      this.valuePrefix = "",
      this.title,
      this.isAmount = false,
      this.onSlideChangedEnd,
      this.selectedValue});

  @override
  _SlideWidgetState createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<AppSlider> {
  TextEditingController valueController = TextEditingController();
  FocusNode valueFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    if (widget.selectedValue == null) {
      widget.selectedValue = widget.minValue;
    }
    this.valueFocusNode.addListener(() {
      double? doubleValue = this.valueController.text.toDouble();
      setState(() {
        _setControllerValue(updateValue: true, newValue: doubleValue);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkSelectedValue();
    return widget.withResult
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                Expanded(flex: 5, child: _renderSlider()),
                SizedBox(
                  width: PADDING_10.widthResponsive(),
                ),
                Expanded(
                    flex: 2,
                    child: TextInputField(
                      onSubmitInput: (String? value) {
                        double? doubleValue = value.toDouble();
                        setState(() {
                          _setControllerValue(
                              updateValue: true, newValue: doubleValue);
                          if (widget.selectedValue != null) {
                            widget.onSlideChangedEnd
                                ?.call(widget.selectedValue!);
                          }
                        });
                      },
                      textColor: Colors.black,
                      textSize: SLIDER_TEXT_INPUT_SIZE.spResponsive(),
                      focusNode: this.valueFocusNode,
                      textController: this.valueController,
                      enabled: canModifyValue(),
                      inputType: TextInputType.numberWithOptions(
                          decimal: true, signed: true),
                      inputFormatterType: widget.rangeOfIntegers
                          ? InputFormatterType.int
                          : InputFormatterType.double,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: PADDING_13.heightResponsive(),
                          horizontal: PADDING_5.widthResponsive()),
                    ))
              ])
        : _renderSlider();
  }

  _checkSelectedValue() {
    widget.selectedValue = _isValidValue(widget.selectedValue)
        ? widget.selectedValue
        : _isValueLessThanMin(widget.selectedValue)
            ? (widget.minValue ?? 0)
            : (widget.maxValue ?? 0);
    _setControllerValue();
  }

  _setControllerValue({bool updateValue = false, double? newValue}) {
    if (updateValue) {
      widget.selectedValue = _isValidValue(newValue)
          ? newValue!
          : _isValueLessThanMin(newValue)
              ? (widget.minValue ?? 0)
              : (widget.maxValue ?? 0);
    }
    this.valueController.text = _getTextInputValue();

    this.valueController.selection = TextSelection.fromPosition(
        TextPosition(offset: this.valueController.text.length));
    if (widget.selectedValue != null) {
      this.widget.onSlideChanged?.call(widget.selectedValue!);
    }
  }

  bool _isValidValue(double? value) {
    return value != null &&
        !_isValueGreaterThanMax(value) &&
        !_isValueLessThanMin(value);
  }

  bool _isValueGreaterThanMax(double? value) {
    return (value ?? 0) > (widget.maxValue ?? 0);
  }

  bool _isValueLessThanMin(double? value) {
    return (value ?? 0) < (widget.minValue ?? 0);
  }

  String _getTextInputValue() {
    String valuePrefix = !widget.isAmount && !this.valueFocusNode.hasFocus
        ? " ${widget.valuePrefix}"
        : "";
    if (!widget.rangeOfIntegers) {
      return "${widget.selectedValue.amountFormat(withCurrency: !this.valueFocusNode.hasFocus && widget.isAmount)}$valuePrefix";
    } else {
      return "${widget.selectedValue?.toInt().amountFormat(withCurrency: !this.valueFocusNode.hasFocus && widget.isAmount)}$valuePrefix";
    }
  }

  _renderSlider() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      widget.title != null
          ? Container(
              child: TextView(
                text: "${widget.title} :",
                textSize: SLIDER_TITLE,
                isBold: true,
              ),
            )
          : Container(),
      SizedBox(
        height: PADDING_2.heightResponsive(),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextView(
            textSize: SLIDER_VALUE_MIN_MAX_SIZE,
            text: widget.rangeOfIntegers
                ? widget.minValue?.toInt().amountFormat(
                    withCurrency: true, currency: widget.valuePrefix)
                : widget.minValue.amountFormat(
                    withCurrency: true, currency: widget.valuePrefix),
          ),
          TextView(
              textSize: SLIDER_VALUE_MIN_MAX_SIZE,
              text: widget.rangeOfIntegers
                  ? widget.maxValue?.toInt().amountFormat(
                      withCurrency: true, currency: widget.valuePrefix)
                  : widget.maxValue.amountFormat(
                      withCurrency: true, currency: widget.valuePrefix))
        ],
      ),
      Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: Padding(
                padding: EdgeInsets.only(
                    top: PADDING_3.heightResponsive(),
                    bottom: PADDING_3.heightResponsive()),
                child: Container(
                  width: SLIDER_LIMIT_LINE_WIDTH.widthResponsive(),
                  height: SLIDER_LIMIT_LINE_HEIGHT.heightResponsive(),
                  color: PRIMARY_BLUE_COLOR,
                )),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            child: Padding(
                padding: EdgeInsets.only(
                    top: PADDING_3.heightResponsive(),
                    bottom: PADDING_3.heightResponsive()),
                child: Container(
                  width: SLIDER_LIMIT_LINE_WIDTH.widthResponsive(),
                  height: SLIDER_LIMIT_LINE_HEIGHT.heightResponsive(),
                  color: PRIMARY_BLUE_COLOR,
                )),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                    height: SLIDER_HEIGHT.heightResponsive(),
                    child: SliderTheme(
                        data: SliderThemeData(
                            trackShape: CustomTrackShape(),
                            disabledThumbColor: Colors.red,
                            activeTrackColor: PRIMARY_BLUE_COLOR,
                            thumbColor: Colors.white,
                            showValueIndicator: ShowValueIndicator.always,
                            thumbShape:
                                RoundSliderThumbShape(enabledThumbRadius: 8)),
                        child: Slider(
                          onChangeEnd: (value) {
                            setState(() {
                              widget.selectedValue = value;
                              widget.onSlideChangedEnd
                                  ?.call(widget.selectedValue!);
                            });
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.selectedValue = value;
                              _setControllerValue();
                            });
                            widget.onSlideChanged?.call(widget.selectedValue!);
                          },
                          value: widget.selectedValue!,
                          min: widget.minValue!,
                          max: widget.maxValue!,
                          divisions: widget.numberOfDivision,
                          label: widget.rangeOfIntegers
                              ? "${widget.selectedValue?.toInt()}"
                              : "${widget.selectedValue?.toStringAsFixed(2)}",
                          inactiveColor: SLIDER_INAVTIVE_COLOR,
                        ))),
              ),
              SizedBox(
                width: PADDING_3.widthResponsive(),
              ),
            ],
          )
        ],
      ),
    ]));
  }

  bool canModifyValue() {
    return widget.maxValue != widget.minValue;
  }
}

class CustomTrackShape extends RectangularSliderTrackShape {
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight ?? 0;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

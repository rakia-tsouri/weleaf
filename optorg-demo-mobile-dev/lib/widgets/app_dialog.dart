import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/arrays.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/app_button.dart';
import 'package:optorg_mobile/widgets/app_textfield.dart';
import 'package:optorg_mobile/widgets/dialogs.dart';
import 'package:optorg_mobile/widgets/shadow_button.dart';
import 'package:optorg_mobile/widgets/textview.dart';

import '../constants/strings.dart';

// ignore: must_be_immutable
class AppDialog extends StatefulWidget {
  late String title;
  late String? description;
  late String buttonText;
  late String cancelButtonText;
  late Color textColor;
  late Color buttonColor;
  late Color cancelButtonColor;
  late Color background;
  late Function? onClickHandler;
  late Function? onCancelClickHandler;
  late DIALOG_TYPE dialogType;
  late List<String>? items;
  late int selectedItem;
  late String inputLabel;
  late TextInputType inputType;
  bool cancelable = true;

  AppDialog.informationPopup(
      {required this.description,
      this.title = "",
      this.buttonText = OK_ACTION,
      this.cancelButtonText = CANCEL_BUTTON,
      this.textColor = Colors.black,
      this.buttonColor = APP_PRIMARY_COLOR,
      this.cancelButtonColor = APP_PRIMARY_COLOR,
      this.background = Colors.white,
      this.onClickHandler,
      this.onCancelClickHandler,
      this.cancelable = true}) {
    dialogType = DIALOG_TYPE.INFO_DIALOG;
  }

  AppDialog.choiceSelector({
    required this.items,
    this.description,
    this.title = "",
    this.buttonText = CONFIRM_ACTION,
    this.textColor = Colors.black,
    this.cancelButtonText = CANCEL_BUTTON,
    this.cancelButtonColor = APP_PRIMARY_COLOR,
    this.buttonColor = APP_PRIMARY_COLOR,
    this.background = Colors.white,
    this.onCancelClickHandler,
    this.onClickHandler,
  }) {
    assert(items != null && items!.isNotEmpty);
    dialogType = DIALOG_TYPE.CHOICE_SELECTOR_DIALOG;
    selectedItem = 0;
  }

  AppDialog.inputDialog(
      {this.description,
      this.title = "",
      this.buttonText = CONFIRM_ACTION,
      this.textColor = Colors.black,
      this.cancelButtonText = CANCEL_BUTTON,
      this.cancelButtonColor = APP_PRIMARY_COLOR,
      this.buttonColor = APP_PRIMARY_COLOR,
      this.background = Colors.white,
      this.cancelable = false,
      this.onCancelClickHandler,
      this.onClickHandler,
      this.inputLabel = IDENTIFIANT,
      this.inputType = TextInputType.text}) {
    dialogType = DIALOG_TYPE.INPUT_DIALOG;
  }

  AppDialog.twoButtonsDialog({
    this.description,
    this.title = "",
    this.buttonText = CONFIRM_ACTION,
    this.textColor = Colors.black,
    this.cancelButtonText = CANCEL_BUTTON,
    this.cancelButtonColor = APP_PRIMARY_COLOR,
    this.buttonColor = APP_PRIMARY_COLOR,
    this.background = Colors.white,
    this.onCancelClickHandler,
    this.onClickHandler,
    this.cancelable = true,
  }) {
    dialogType = DIALOG_TYPE.TWO_BUTTONS_DIALOG;
  }

  AppDialog.fingerPrintDialog({
    this.onCancelClickHandler,
    this.onClickHandler,
  }) {
    dialogType = DIALOG_TYPE.FINGERPRINT_POPUP;
  }

  @override
  _AppDialogState createState() => _AppDialogState();

  show(BuildContext context) {
    Navigator.of(context).push(FullScreenPopup(
        child: this, isBlurBackground: true, withoutDecoration: true));
  }

  displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              backgroundColor: Colors.white.withOpacity(0),
              builder: (context) {
                return this;
              });
        });
  }
}

class _AppDialogState extends State<AppDialog> {
  bool errorMessageShown = false;
  late TextEditingController inputTextController;

  @override
  void initState() {
    inputTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.dialogType) {
      case DIALOG_TYPE.INPUT_DIALOG:
        return _renderInputDialog(context);
      case DIALOG_TYPE.TWO_BUTTONS_DIALOG:
        return _renderTwoButtonsDialog(context);
      case DIALOG_TYPE.CHOICE_SELECTOR_DIALOG:
        return _renderChoiceSelectorDialog(context);

      default:
        return _renderInformationDialog(context);
    }
  }

// *************
// *************
  _renderInformationDialog(BuildContext context) {
    return WillPopScope(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: this.widget.background),
          child: Padding(
            padding: EdgeInsets.all(PADDING_20.spResponsive()),
            child: Column(
              children: [
                widget.title.isNotEmpty
                    ? TextView(
                        text: this.widget.title,
                      )
                    : Container(),
                SizedBox(
                  height: PADDING_10.heightResponsive(),
                ),
                TextView(
                  text: this.widget.description,
                  textColor: PRIMARY_BLUE_COLOR,
                ),
                SizedBox(
                  height: PADDING_20.heightResponsive(),
                ),
                AppButton(
                  buttonText: widget.buttonText,
                  textColor: APP_PRIMARY_COLOR,
                  borderColor: APP_PRIMARY_COLOR,
                  buttonColor: Colors.white,
                  onClickCallback: () {
                    widget.onClickHandler?.call();
                  },
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return widget.cancelable;
        });
  }

// *************
// *************
  _renderTwoButtonsDialog(BuildContext context) {
    return WillPopScope(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: widget.background),
          child: Padding(
            padding: EdgeInsets.all(PADDING_20.widthResponsive()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.title.isNotEmpty
                    ? TextView(
                        text: widget.title,
                        isBold: true,
                        textFont: POPPINS_REGULAR,
                      )
                    : Container(),
                SizedBox(
                  height: PADDING_20.heightResponsive(),
                ),
                TextView(
                  text: widget.description,
                  textColor: PRIMARY_BLUE_COLOR,
                  textFont: POPPINS_REGULAR,
                ),
                SizedBox(
                  height: PADDING_20.heightResponsive(),
                ),
                AppButton(
                    buttonText: widget.buttonText,
                    onClickCallback: () {
                      widget.onClickHandler?.call();
                    }),
                SizedBox(
                  height: PADDING_10.heightResponsive(),
                ),
                AppButton(
                  buttonText: widget.cancelButtonText,
                  borderColor: PRIMARY_BLUE_COLOR,
                  buttonColor: WHITE_COLOR,
                  textColor: PRIMARY_BLUE_COLOR,
                  onClickCallback: () {
                    widget.onCancelClickHandler?.call();
                  },
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return widget.cancelable;
        });
  }

  _renderInputDialog(BuildContext context) {
    return Container(
      width: double.infinity,
      height: INPUT_POPUP_HEIGHT.heightResponsive(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: widget.background),
      child: Padding(
        padding: EdgeInsets.all(PADDING_20.spResponsive()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextView(
              text: widget.title,
              textFont: POPPINS_REGULAR,
            ),
            SizedBox(
              height: PADDING_15.heightResponsive(),
            ),
            TextView(text: widget.description, textFont: POPPINS_REGULAR),
            SizedBox(
              height: PADDING_20.heightResponsive(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                    placeholder: this.widget.inputLabel,
                    textController: this.inputTextController,
                    keyboardType: this.widget.inputType),
                Visibility(
                  visible: errorMessageShown,
                  child: TextView(
                      text: USERNAME_EMPTY_ERROR,
                      textSize: 11,
                      textColor: Colors.red,
                      textFont: POPPINS_REGULAR),
                )
              ],
            ),
            SizedBox(
              height: PADDING_15.heightResponsive(),
            ),
            ShadowButton.blue(
                text: this.widget.buttonText, onPress: _onButtonClicked),
            SizedBox(
              height: PADDING_5.heightResponsive(),
            ),
            ShadowButton.white(
                text: CANCEL_BUTTON,
                onPress: () {
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }

  _onButtonClicked() {
    if (inputTextController.text.isEmpty) {
      setState(() {
        errorMessageShown = true;
      });
    } else {
      widget.onClickHandler?.call(inputTextController.text);
    }
  }

  _renderChoiceSelectorDialog(BuildContext context) {
    return Container(
      height: CHOICE_SELECTOR_POPUP_HEIGHT.heightResponsive(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: widget.background),
      child: Column(
        children: [
          const SizedBox(
            height: PADDING_20,
          ),
          Container(
            height: CUPERTINO_PICKER_SIZE.heightResponsive(),
            child: CupertinoPicker(
              backgroundColor: Colors.transparent,
              itemExtent: CUPERTINO_PICKER_ITEM_HEIGHT,
              children: this.widget.items!.map((element) {
                return TextView(
                  text: element,
                );
              }).toList(),
              onSelectedItemChanged: (value) {
                widget.selectedItem = value;
              },
            ),
          ),
          const SizedBox(
            height: PADDING_20,
          ),
          AppButton(
              buttonText: widget.buttonText,
              onClickCallback: () {
                widget.onClickHandler?.call(widget.selectedItem);
              },
              buttonColor: widget.buttonColor),
          const SizedBox(
            height: PADDING_15,
          ),
          AppButton(
              buttonText: widget.cancelButtonText,
              onClickCallback: () {
                Navigator.pop(context);
              },
              buttonColor: widget.buttonColor)
        ],
      ),
    );
  }
}

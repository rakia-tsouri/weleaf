import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/utils/extensions.dart';

// +++++++++++++++++
// +++++++++++++++++
class CustomPopupBottomSheet extends StatelessWidget {
  final String? titlePopupText;
  final Widget? popupContent;
  final double? popupHeight;
  final EdgeInsets? contentPadding;
  final Color? backgroundColor;
  const CustomPopupBottomSheet(
      {super.key,
      this.titlePopupText,
      this.popupContent,
      this.contentPadding,
      this.popupHeight,
      this.backgroundColor});

// ***************
// ***************
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.popupHeight?.heightResponsive(),
      padding: this.contentPadding ?? EdgeInsets.all(WIDTH_5.widthResponsive()),
      margin: EdgeInsets.only(top: HEIGHT_5.heightResponsive()),
      decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(popupTopRadiusCorner),
              topRight: Radius.circular(popupTopRadiusCorner))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [popupContent != null ? popupContent! : Container()],
      ),
    );
  }

// ***************
// ***************
  static showBottomSheet(BuildContext context, Widget popup,
      {bool isDismissible = false, bool isScrollControlled = false}) {
    showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        builder: (BuildContext context) {
          return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: PopScope(child: popup, canPop: isDismissible));
        });
  }
}

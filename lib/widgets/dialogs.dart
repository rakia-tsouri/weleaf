import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/constants.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class FullScreenPopup extends ModalRoute<void> {
  Widget child;
  bool withBackButton;
  bool cancelable;
  bool withoutDecoration;
  bool isBlurBackground;

  late ImageFilter imageFilter;

  FullScreenPopup(
      {required this.child,
      this.withBackButton = true,
      this.cancelable = true,
      this.withoutDecoration = false,
      this.isBlurBackground = false}) {
    double blurSigma = 3;
    imageFilter = ImageFilter.blur(
        sigmaX: isBlurBackground ? blurSigma : 0,
        sigmaY: isBlurBackground ? blurSigma : 0);
  }

  @override
  Color? get barrierColor => isBlurBackground
      ? PRIMARY_BLUE_COLOR.withOpacity(0.28)
      : Colors.white.withOpacity(0.8);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  ImageFilter get filter => this.imageFilter;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return WillPopScope(
      child: ScreenUtilInit(
        builder: (_, child) => Material(
          type: MaterialType.transparency,
          child: SafeArea(child: _renderModal(context)),
        ),
      ),
      onWillPop: () async {
        return cancelable;
      },
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => POPUP_TRANSITION_DURATION;

  _renderModal(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Padding(
        padding: EdgeInsets.all(PADDING_20.widthResponsive()),
        child: Container(
          padding: EdgeInsets.all(PADDING_15.widthResponsive()),
          width: double.infinity,
          decoration: !withoutDecoration
              ? BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: APP_PRIMARY_COLOR, width: 1))
              : null,
          child: Column(
            children: [child],
          ),
        ),
      )
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/fonts.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/app_circular_loading.dart';
import 'package:optorg_mobile/widgets/dialogs.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class LoadingPopup extends StatelessWidget {
  final String popupMessage;
  final Color textColor;
  final Color popupColor;

  const LoadingPopup(
      {this.popupMessage = LOADING,
      this.popupColor = APP_SECONDARY_COLOR,
      this.textColor = APP_PRIMARY_COLOR});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(PADDING_10.widthResponsive()),
      height: PADDING_200.heightResponsive(),
      decoration: BoxDecoration(
          color: popupColor,
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppCircularLoading(),
            Padding(
              padding: EdgeInsets.only(top: PADDING_30.heightResponsive()),
              child: TextView(
                text: popupMessage.toUpperCase(),
                textColor: textColor,
                textFont: POPPINS_SEMIBOLD,
              ),
            )
          ],
        ),
      ),
    );
  }

// ***********
// ***********
  show(BuildContext context) {
    return Navigator.of(context).push(FullScreenPopup(
        child: this, withoutDecoration: true, isBlurBackground: true));
  }
}

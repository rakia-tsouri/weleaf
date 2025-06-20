import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class OfferInformationDetailItemWidget extends StatelessWidget {
  final String title;
  final String value;
  const OfferInformationDetailItemWidget(
      {required this.title, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: OFFER_DETAILS_DETAIL_ITEM_BACKGROUND_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      padding: EdgeInsets.symmetric(
          vertical: PADDING_7.widthResponsive(),
          horizontal: PADDING_10.widthResponsive()),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
              text: title,
              textColor: OFFER_DETAILS_DETAIL_ITEM_TITLE_COLOR,
              textSize: OFFER_DETAILS_INFO_TTEM_TITLE_TEXT_SIZE,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: PADDING_5.heightResponsive(),
            ),
            TextView(
              text: value,
              textColor: OFFER_DETAILS_DETAIL_ITEM_VALUE_COLOR,
              textSize: OFFER_DETAILS_INFO_TTEM_VALUE_TEXT_SIZE,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            )
          ]),
    );
  }
}

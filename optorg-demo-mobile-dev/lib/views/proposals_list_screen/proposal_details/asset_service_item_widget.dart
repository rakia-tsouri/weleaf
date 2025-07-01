import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/constants.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/textview.dart';

// +++++++++++++++++
// +++++++++++++++++
class AssetServiceItemWidget extends StatelessWidget {
  final AssetSerivce assetService;
  final int indexInList;
  final Function(int) onItemSelection;
  const AssetServiceItemWidget(
      {super.key,
      required this.assetService,
      required this.indexInList,
      required this.onItemSelection});

// ************
// ************
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemSelection.call(indexInList);
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: PADDING_10.heightResponsive(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TextView(
                    text: "Service: ",
                    textSize: 11,
                    textAlign: TextAlign.start,
                    textColor: PLACEHOLDER_TEXT_COLOR,
                    isBold: true,
                  ),
                ),
                SizedBox(
                  width: PADDING_2.widthResponsive(),
                ),
                Expanded(
                  flex: 5,
                  child: TextView(
                    text: assetService.servlabel,
                    textAlign: TextAlign.start,
                    textSize: 11,
                    textColor: PRIMARY_BLUE_COLOR,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TextView(
                    text: "Service en (%): ",
                    textSize: 11,
                    textAlign: TextAlign.start,
                    textColor: PLACEHOLDER_TEXT_COLOR,
                    isBold: true,
                  ),
                ),
                SizedBox(
                  width: PADDING_2.widthResponsive(),
                ),
                Expanded(
                  flex: 5,
                  child: TextView(
                    text: "${assetService.servpercentage ?? "-"} %",
                    textAlign: TextAlign.start,
                    textSize: 11,
                    textColor: PRIMARY_BLUE_COLOR,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: TextView(
                    text: "Montant fixe: ",
                    textSize: 11,
                    textAlign: TextAlign.start,
                    textColor: PLACEHOLDER_TEXT_COLOR,
                    isBold: true,
                  ),
                ),
                SizedBox(
                  width: PADDING_2.widthResponsive(),
                ),
                Expanded(
                  flex: 5,
                  child: TextView(
                    text:
                        "${assetService.servfixedamount ?? "-"} $CURRENCY_SYMBOL",
                    textAlign: TextAlign.start,
                    textSize: 11,
                    textColor: PRIMARY_BLUE_COLOR,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: PADDING_10.heightResponsive(),
            ),
            Container(
              height: 1.0.heightResponsive(),
              color: Colors.grey.shade200,
            )
          ]),
    );
  }
}

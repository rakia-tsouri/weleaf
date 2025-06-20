import 'package:flutter/material.dart';

import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/constants.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/cached_image.dart';
import 'package:optorg_mobile/widgets/textview.dart';

// +++++++++++++++++++
// +++++++++++++++++++
class ProposalListScreenItem extends StatelessWidget {
  final Proposal item;
  final Function(Proposal)? onItemClick;

  const ProposalListScreenItem(
      {required this.item, required this.onItemClick, super.key});

// ***************
// ***************
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onItemClick?.call(item);
      },
      child: Stack(
        children: [
          Positioned(
            top: PADDING_3.heightResponsive(),
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: PADDING_15.widthResponsive(),
                top: PADDING_15.heightResponsive(),
              ),
              width: PADDING_350.widthResponsive(),
              height: PADDING_115.heightResponsive(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white70,
                    spreadRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextView(
                        textAlign: TextAlign.left,
                        textColor: Colors.grey,
                        textSize: OFFER_LIST_TEXT_SIZE_1,
                        text: formatDate(item.ctstatusdate),
                      ),
                      TextView(
                        textAlign: TextAlign.left,
                        textColor: Colors.black,
                        textSize: OFFER_LIST_TEXT_SIZE_1,
                        text: ".",
                      ),
                      TextView(
                        textAlign: TextAlign.left,
                        textSize: OFFER_LIST_TEXT_SIZE_1,
                        text: item.statuslabel,
                        textColor: getStatusColor(item.ctstatus),
                      ),
                    ],
                  ),
                  TextView(
                    text: item.propreference,
                    textSize: OFFER_LIST_TEXT_SIZE_2,
                    textAlign: TextAlign.left,
                    textColor: PRIMARY_BLUE_COLOR,
                    isBold: true,
                  ),
                  SizedBox(
                    height: PADDING_3.heightResponsive(),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.grey,
                            textSize: OFFER_LIST_TEXT_SIZE_1,
                            text: BIEN,
                          ),
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.black,
                            textSize: OFFER_LIST_TEXT_SIZE_3,
                            text: item.ctdescription,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.grey,
                            textSize: OFFER_LIST_TEXT_SIZE_1,
                            text: MANTANTFINANCER,
                          ),
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.black,
                            textSize: OFFER_LIST_TEXT_SIZE_3,
                            text: item.ctfinancedamount
                                ?.toDouble()
                                .amountFormat(),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: PADDING_20.widthResponsive(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.grey,
                            textSize: OFFER_LIST_TEXT_SIZE_1,
                            text: LOYER,
                          ),
                          TextView(
                            textAlign: TextAlign.left,
                            textColor: Colors.black,
                            textSize: OFFER_LIST_TEXT_SIZE_3,
                            text: ASSET_PAYMENT_MONTH.format([
                              item.cterentalamount?.toDouble().amountFormat(),
                              item.cteduration
                            ]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: PADDING_3.heightResponsive(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: PADDING_125.heightResponsive(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: SizedBox(
              width: OFFER_LIST_ITEM_IMAGE_WIDTH.widthResponsive(),
              child: AspectRatio(
                aspectRatio: 1.7,
                child: PagerCachedImage(
                  imageSize: OFFER_LIST_ITEM_IMAGE_WIDTH.widthResponsive(),
                  url: (item.assetpictureurl != null)
                      ? getLogoVehicule(item.ctdescription)
                      : null,
                  boxFit: BoxFit.fitHeight,
                  onErrorBuilder: () {
                    return Image.asset(OFFER_DEFAULT_CAR);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Color getStatusColor(String? statuscode) {
    if (statuscode?.contains("SCOCREATED") == true) {
      return PRIMARY_YELLOW_COLOR;
    } else if (statuscode?.contains("INIT") == true) {
      return const Color.fromARGB(255, 14, 0, 168);
    } else if (statuscode?.contains("OFFCOMPLTE") == true) {
      return Colors.black;
    } else {
      return const Color.fromARGB(255, 133, 20, 97);
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null) {
      return "";
    }
    DateTime? dateTime = dateString.toDateTime();
    return dateTime.format(pattern: FRENCH_DATE_FORMAT_PATTERN) ?? '';
  }

  String getLogoVehicule(String? brandModele) {
    if (brandModele?.toLowerCase().contains("volkswagen") == true) {
      return "https://www.logo-voiture.com/wp-content/uploads/2021/01/Logo-Volkswagen.png";
    } else if (brandModele?.toLowerCase().contains("peugeot") == true) {
      return "https://logo-marque.com/wp-content/uploads/2021/10/Peugeot-Logo.png";
    } else if (brandModele?.toLowerCase().contains("dacia") == true) {
      return "https://upload.wikimedia.org/wikipedia/commons/a/a1/Dacia-logo.png";
    } else if (brandModele?.toLowerCase().contains("citroen") == true) {
      return "https://mediaresource.sfo2.digitaloceanspaces.com/wp-content/uploads/2024/04/20225621/citroen-new-2022-logo-B8E6FFA65E-seeklogo.com.png";
    } else if (brandModele?.toLowerCase().contains("volvo") == true) {
      return "https://www.logo-voiture.com/wp-content/uploads/2023/03/logo-volvo.png";
    } else if (brandModele?.toLowerCase().contains("jeep") == true) {
      return "https://www.logo-voiture.com/wp-content/uploads/2021/01/Logo-Jeep.png";
    } else {
      return "https://e7.pngegg.com/pngimages/264/346/png-clipart-mercedes-mercedes.png";
    }
  }
}

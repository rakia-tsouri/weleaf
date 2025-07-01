import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/offer_details_info_item_data.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/offer_information_detail_item_widget.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class OfferDetailsInfo extends StatelessWidget {
  final IOfferDetailsInfoType offerDetailsInfoType;
  final ProposalDetailsResponse offerResponse;
  OfferDetailsInfo(
      {required this.offerResponse,
      required this.offerDetailsInfoType,
      super.key}) {
    _iniOfferDetailsData();
  }

  final Map<IOfferDetailsInfoType, List<OfferDetailsInfoItemData>>
      offerDetailsInfos = {};
  @override
  Widget build(BuildContext context) {
    double gridViewItemPadding = PADDING_10.widthResponsive();
    return Container(
      alignment: Alignment.bottomLeft,
      color: OFFER_DETAILS_MORE_DETAILS_SECTION_BACKGROUND_COLOR,
      padding: EdgeInsets.only(
          left: PADDING_20.widthResponsive(),
          right: PADDING_20.widthResponsive(),
          top: PADDING_15.widthResponsive()),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextView(
              text: _getOfferDetailsTitleFromOfferInfoType(
                  infoType: offerDetailsInfoType),
              textColor: PRIMARY_BLUE_COLOR,
              isBold: true,
              textSize: OFFER_DETAILS_SECTION_DETAILS_TITLE_SIZE,
            ),
            SizedBox(
              height: PADDING_10.heightResponsive(),
            ),
            Expanded(child: LayoutBuilder(
              builder: (p0, p1) {
                return GridView(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getGridViewCrossAxisCountFromDataLength(
                          dataCount: _getOfferDetailsDataFromOfferInfoType(
                                  infoType: offerDetailsInfoType)
                              .length),
                      mainAxisExtent: _getGridViewMainAxisExtent(
                          infosLength: _getOfferDetailsDataFromOfferInfoType(
                                  infoType: offerDetailsInfoType)
                              .length,
                          maxWidth: p1.maxWidth,
                          padding: gridViewItemPadding),
                      crossAxisSpacing: gridViewItemPadding,
                      mainAxisSpacing: gridViewItemPadding),
                  children: _getOfferDetailsDataFromOfferInfoType(
                          infoType: offerDetailsInfoType)
                      .map((e) => OfferInformationDetailItemWidget(
                          title: e.title, value: e.value))
                      .toList(),
                );
              },
            )),
            SizedBox(
              height: PADDING_7.heightResponsive(),
            )
          ]),
    );
  }

  double _getGridViewMainAxisExtent(
      {required int infosLength,
      required double maxWidth,
      required double padding}) {
    if (infosLength <= 4) {
      return (maxWidth - padding) / 2;
    }
    return (maxWidth - (padding * 2)) / 3;
  }

  int _getGridViewCrossAxisCountFromDataLength({required int dataCount}) {
    return 2;
  }

  _iniOfferDetailsData() {
    offerDetailsInfos.clear();
    offerDetailsInfos.addAll({
      IOfferDetailsInfoType.financement: [
        OfferDetailsInfoItemData(
            title: OFFER_DETAILS_FIRST_PAYMENT,
            value: offerResponse.getFirstPayement()),
        OfferDetailsInfoItemData(
            title: OFFER_DETAILS_RESIDUAL_VALUE,
            value: offerResponse.getResidualValue()),
      ],
      IOfferDetailsInfoType.assetDetails: [
        OfferDetailsInfoItemData(
            title: OFFER_DETAILS_PRICE,
            value: offerResponse.getMontantFinance()),
        OfferDetailsInfoItemData(title: OFFER_DETAILS_QUANTITY, value: "1"),
        OfferDetailsInfoItemData(
            title: OFFER_DETAILS_MILEAGE,
            value: "${offerResponse.getMileageKm()} km"),
        OfferDetailsInfoItemData(
            title: OFFER_DETAILS_MONTANT_HT,
            value: offerResponse.getMontantHT()),
      ]
    });
  }

  List<OfferDetailsInfoItemData> _getOfferDetailsDataFromOfferInfoType(
      {required IOfferDetailsInfoType infoType}) {
    return offerDetailsInfos[infoType] ?? [];
  }

  String _getOfferDetailsTitleFromOfferInfoType(
      {required IOfferDetailsInfoType infoType}) {
    switch (infoType) {
      case IOfferDetailsInfoType.financement:
        return OFFER_DETAILS_MORE_DETAILS_SECTION_TITLE;
      case IOfferDetailsInfoType.assetDetails:
        return OFFER_DETAILS_FINANCEMENT_SECTION_TITLE;
    }
  }

  String validateAndFormatValue(
      {required double? value, required String currency}) {
    return value != null ? value.amountFormat(currency: currency) : "--";
  }
}

enum IOfferDetailsInfoType { financement, assetDetails }

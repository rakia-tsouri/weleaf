import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/offer_details_info.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/popup_asset_services_list_widget.dart';
import 'package:optorg_mobile/widgets/app_button.dart';
import 'package:optorg_mobile/widgets/custom_popup_bottom_sheet.dart';
import 'package:optorg_mobile/widgets/textview.dart';

class OfferDetailsFragment extends StatefulWidget {
  final ProposalDetailsResponse proposalDetailsResponse;
  OfferDetailsFragment({required this.proposalDetailsResponse, super.key});

  @override
  State<OfferDetailsFragment> createState() => _OfferDetailsFragmentState();
}

class _OfferDetailsFragmentState extends State<OfferDetailsFragment> {
  IOfferDetailsInfoType currentOfferDetailsInfoType =
      IOfferDetailsInfoType.values.first;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: PADDING_20.widthResponsive()),
      decoration: BoxDecoration(
          color: OFFER_DETAILS_DETAILS_CONTAINER_BACKGROUND_COLOR,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(OFFER_DETAILS_BOTTOM_CONTAINER_RADIUS),
              topRight:
                  Radius.circular(OFFER_DETAILS_BOTTOM_CONTAINER_RADIUS))),
      child: Column(children: [
        TextView(
          text:
              "${getFinancialPaymentWTaxValue()} / ${getNumberOfPaymentTermValue()} ${MONTH_PREFIX.toUpperCase()}",
          textSize: OFFER_DETAILS_FINANCED_PAYMENT_TEXT_SIZE,
          isBold: true,
          textColor: OFFER_DETAILS_FIRST_PAYMENT_COLOR,
        ),
        SizedBox(
          height: PADDING_5.heightResponsive(),
        ),
        TextView(
          text: widget.proposalDetailsResponse.data!.offer?.offerlabel,
          textSize: OFFER_DETAILS_ACTIVITY_TYPE_TEXT_SIZE,
          textColor: OFFER_DETAILS_ACTIVITY_TYPE_COLOR,
        ),
        SizedBox(
          height: PADDING_10.heightResponsive(),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: PADDING_5.widthResponsive()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                  textSize: 14,
                  withSplashEffect: false,
                  buttonHeight: OFFER_DETAILS_DETAILS_BUTTON_HEIGHT,
                  buttonText: _getDetailsButtonTextFromOfferInfoType(
                      infoType: currentOfferDetailsInfoType),
                  icon: _getDetailsButtonIconFromOfferInfoType(
                      infoType: currentOfferDetailsInfoType),
                  onClickCallback: () {
                    setState(() {
                      currentOfferDetailsInfoType =
                          currentOfferDetailsInfoType.next();
                    });
                  }),
              SizedBox(
                width: PADDING_5.widthResponsive(),
              ),
              AppButton(
                  buttonWidth: 100.0.widthResponsive(),
                  buttonHeight: OFFER_DETAILS_DETAILS_BUTTON_HEIGHT,
                  textSize: 14,
                  buttonText: "Services",
                  onClickCallback: () {
                    _displayAssetService();
                  }),
            ],
          ),
        ),
        SizedBox(
          height: PADDING_15.heightResponsive(),
        ),
        Expanded(
            child: OfferDetailsInfo(
                offerResponse: widget.proposalDetailsResponse,
                offerDetailsInfoType: currentOfferDetailsInfoType)),
      ]),
    );
  }

// **********
  // **********
  _displayAssetService() {
    List<AssetSerivce> listOfAssetServices = [];
    if (widget.proposalDetailsResponse.data != null &&
        widget.proposalDetailsResponse.data!.assetServiceList != null) {
      listOfAssetServices =
          widget.proposalDetailsResponse.data!.assetServiceList!;
    }
    CustomPopupBottomSheet.showBottomSheet(
        context,
        CustomPopupBottomSheet(
            popupContent: PopupAssetServicesList(
                listOfAssetServices: listOfAssetServices,
                onAssetSeriveSelection: _onAssetSeriveSelection)),
        isScrollControlled: true,
        isDismissible: true);
  }

// **********
  // **********
  _onAssetSeriveSelection(AssetSerivce assetService) {}
  String _getDetailsButtonTextFromOfferInfoType(
      {required IOfferDetailsInfoType infoType}) {
    switch (infoType) {
      case IOfferDetailsInfoType.financement:
        return OFFER_DETAILS_MORE_DETAILS;
      case IOfferDetailsInfoType.assetDetails:
        return OFFER_DETAILS_FINANCEMENT_DETAILS;
    }
  }

  Widget _getDetailsButtonIconFromOfferInfoType(
      {required IOfferDetailsInfoType infoType}) {
    switch (infoType) {
      case IOfferDetailsInfoType.financement:
        return SvgPicture.asset(
          OFFER_MORE_DETAILS_IC,
          height: OFFER_DETAILS_DETAILS_BUTTON_ICON_SIZE.heightResponsive(),
        );
      case IOfferDetailsInfoType.assetDetails:
        return SvgPicture.asset(
          OFFER_FINANCING_DETAILS_IC,
          height: OFFER_DETAILS_DETAILS_BUTTON_ICON_SIZE.heightResponsive(),
        );
    }
  }

  String getFinancementPaymentValue() {
    return "777777";
  }

// *******************
// *******************
  String getFinancialPaymentWTaxValue() {
    return widget.proposalDetailsResponse.getMonthlyRent();
  }

  String getNumberOfPaymentTermValue() {
    return widget.proposalDetailsResponse.getDuration();
  }
}

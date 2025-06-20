import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/constants/images.dart';
import 'package:optorg_mobile/constants/strings.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/proposal_details_response.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/offer_detail_gradient_background.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/offer_details_fragment.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen_vm.dart';
import 'package:optorg_mobile/widgets/app_future_builder.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';

// ++++++++++++++++
// ++++++++++++++++
class ProposalDetailsScreen extends StatefulWidget {
  final int proposalId;
  const ProposalDetailsScreen({super.key, required this.proposalId});

  @override
  State<ProposalDetailsScreen> createState() => _ProposalDetailsScreenState();
}

// ++++++++++++++++
// ++++++++++++++++
class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  late ProposalsListScreenVM proposalsListScreenVM;
  late Future<ApiResponse<ProposalDetailsResponse>> futureProposalDetails;
  ProposalDetailsResponse? proposalDetailsResponse;
  // ***************
  // ***************
  @override
  void initState() {
    //implement initState
    proposalsListScreenVM =
        Provider.of<ProposalsListScreenVM>(context, listen: false);
    futureProposalDetails =
        proposalsListScreenVM.getProposalDetails(proposalId: widget.proposalId);
    super.initState();
  }

  // ***************
  // ***************
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayBackButton: true,
      displayLogoutButton: false,
      displayUserIcon: true,
      screenContent: _buildProposalsListFutureBuilder(),
      screenBackground: OfferDetailGradientBackground(),
    );
  }

  // **********
  // **********
  _buildProposalsListFutureBuilder() {
    return AppFutureBuilder(
        future: futureProposalDetails,
        successBuilder: ((ProposalDetailsResponse result) {
          this.proposalDetailsResponse = result;

          return _buildProposalDetailsScreenContent();
        }));
  }

// **********
  // **********
  _buildProposalDetailsScreenContent() {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                margin: EdgeInsets.only(
                  left: PADDING_7.widthResponsive(),
                  right: PADDING_7.widthResponsive(),
                ),
                decoration: BoxDecoration(
                    color: PRIMARY_BLUE_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Stack(children: [
                  Positioned.fill(
                      child: _renderAssetInformationsContent(
                          proposalDetailsResponse: proposalDetailsResponse!)),
                ]),
              )),
          Expanded(
              flex: 5,
              child: OfferDetailsFragment(
                proposalDetailsResponse: proposalDetailsResponse!,
              ))
        ],
      ),
    );
  }

  Widget _renderAssetInformationsContent(
      {required ProposalDetailsResponse proposalDetailsResponse}) {
    return Container(
      margin: EdgeInsets.only(
        top: PADDING_5.heightResponsive(),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin:
                EdgeInsets.symmetric(horizontal: PADDING_20.widthResponsive()),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: OFFER_DETAILS_REF_OFFER,
                        textSize: OFFER_DETAILS_REF_TITLE_TEXT_SIZE,
                        textColor: OFFER_DETAILS_REF_OFFER_TITLE_COLOR,
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: PADDING_7.heightResponsive(),
                      ),
                      TextView(
                        text: proposalDetailsResponse.data?.propreference,
                        textSize: OFFER_DETAILS_REF_VALUE_TEXT_SIZE,
                        textColor: OFFER_DETAILS_REF_OFFER_VALUE_COLOR,
                        isBold: true,
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextView(
                      text: proposalDetailsResponse.data?.ctstatusdate,
                      textSize: OFFER_DETAILS_DATE_TEXT_SIZE.spResponsive(),
                      textColor: OFFER_DETAILS_CREATION_DATE_TITLE_COLOR,
                    ),
                    SizedBox(
                      height: PADDING_7.heightResponsive(),
                    ),
                    _renderOfferStatusBox(
                        status:
                            proposalDetailsResponse.data?.ctstatuslabel ?? "--")
                  ],
                )
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: _renderMainAssetImage(
                pictureBase64:
                    proposalDetailsResponse.data?.assetpictureBase64),
          ),
          Column(
            children: [
              TextView(
                text: proposalDetailsResponse.getMarqueModele(),
                textSize:
                    OFFER_DETAILS_ASSET_BRAND_RANGE_TEXT_SIZE.spResponsive(),
                textColor: OFFER_DETAILS_ASSET_BRAND_RANGE_COLOR,
              ),
              TextView(
                text: proposalDetailsResponse.getMontantFinance(),
                textSize: OFFER_DETAILS_FINANCED_VALUE_TEXT_SIZE,
                textColor: OFFER_DETAILS_FINANCED_AMOUNT__COLOR,
                isBold: true,
              ),
            ],
          )
        ],
      ),
    );
  }

// *********
// *********
  Widget _renderOfferStatusBox({required String status}) {
    return Container(
      decoration: BoxDecoration(
          color: OFFER_DETAILS_CREATION_DATE_BACKGROUND_COLOR,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      padding: EdgeInsets.symmetric(
          vertical: PADDING_7.widthResponsive(),
          horizontal: PADDING_10.widthResponsive()),
      child: TextView(
        text: status,
        textSize: OFFER_DETAILS_STATUS_TEXT_SIZE,
        textColor: OFFER_DETAILS_CREATION_DATE_VALUE_COLOR,
      ),
    );
  }

// *********
// *********
  Widget _renderMainAssetImage({required String? pictureBase64}) {
    if (!pictureBase64.isNullOrEmpty()) {
      return Image.memory(
        base64Decode(pictureBase64!),
        height:
            OFFER_DETAILS_ASSET_LEFT_BACKGROUND_IMAGE_SIZE.heightResponsive(),
      );
    }
    return Image.asset(OFFER_DEFAULT_CAR);
  }
}

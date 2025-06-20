import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/data/models/asset_services_response.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_details/asset_service_item_widget.dart';
import 'package:optorg_mobile/widgets/app_button.dart';
import 'package:optorg_mobile/widgets/textview.dart';

// +++++++++++++
// +++++++++++++
class PopupAssetServicesList extends StatefulWidget {
  final List<AssetSerivce> listOfAssetServices;
  final Function(AssetSerivce) onAssetSeriveSelection;
  const PopupAssetServicesList(
      {super.key,
      required this.listOfAssetServices,
      required this.onAssetSeriveSelection});

//*******
//*******
  @override
  State<PopupAssetServicesList> createState() => _PopupAssetServicesListState();
}

// +++++++++++++
// +++++++++++++
class _PopupAssetServicesListState extends State<PopupAssetServicesList> {
  // Variables

//*******
//*******
  @override
  Widget build(BuildContext context) {
    return _buildOrderListScreenContent();
  }

//*******
//*******
  _buildOrderListScreenContent() {
    return Container(
      height: PADDING_370.heightResponsive(),
      padding: EdgeInsets.all(PADDING_10.widthResponsive()),
      child: Column(
        children: [
          TextView(
            text: "Les services associés",
            textSize: PADDING_15,
            textColor: PRIMARY_BLUE_COLOR,
            isBold: true,
          ),
          SizedBox(
            height: PADDING_10.heightResponsive(),
          ),
          Expanded(
            child: (widget.listOfAssetServices.length > 0)
                ? ListView.builder(
                    padding:
                        EdgeInsets.only(bottom: PADDING_10.heightResponsive()),
                    itemCount: widget.listOfAssetServices.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AssetServiceItemWidget(
                        assetService: widget.listOfAssetServices[index],
                        indexInList: index,
                        onItemSelection: _onOrderSelection,
                      );
                    })
                : Center(
                    child: TextView(
                      text: "Aucun service associé à cette proposition",
                      textSize: PADDING_13,
                    ),
                  ),
          ),
          SizedBox(
            height: PADDING_10.heightResponsive(),
          ),
          Center(
            child: AppButton(
                buttonText: "OK",
                buttonWidth: PADDING_180.widthResponsive(),
                onClickCallback: () {
                  AppNavigation.pop();
                }),
          )
        ],
      ),
    );
  }

// *******
// ********
  _onOrderSelection(int index) {
    AppNavigation.pop();
    widget.onAssetSeriveSelection.call(widget.listOfAssetServices[index]);
  }
}

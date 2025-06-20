import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/data/models/api_response.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposal_list_screen_item.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen_vm.dart';
import 'package:optorg_mobile/widgets/app_future_builder.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';

// +++++++++++++++++
// +++++++++++++++++
class ProposalsListScreen extends StatefulWidget {
  const ProposalsListScreen({super.key});

  @override
  State<ProposalsListScreen> createState() => _ProposalsListScreenState();
}

// +++++++++++++++++
// +++++++++++++++++
class _ProposalsListScreenState extends State<ProposalsListScreen> {
  late ProposalsListScreenVM proposalsListScreenVM;
  late Future<ApiResponse<ProposalListResponse>> futureListOfProposals;
  List<Proposal> listOfProposals = [];
  int _currentOffset = 0;

// ******************
// ******************
  @override
  void initState() {
    // implement initState
    proposalsListScreenVM =
        Provider.of<ProposalsListScreenVM>(context, listen: false);
    refreshProposalsList();
    super.initState();
  }

  // **********
  // **********
  Future<void> refreshProposalsList() async {
    setState(() {
      _currentOffset = 0;
      listOfProposals = [];
      futureListOfProposals =
          proposalsListScreenVM.getListOfProposals(offset: _currentOffset);
    });
  }

// ******************
// ******************
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayBackButton: false,
      displayLogoutButton: false,
      displayUserIcon: true,
      backgroundColor: Colors.white,
      screenContent: Container(
        child: _buildProposalsListFutureBuilder(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigation.goToCalculateScreen();
        },
        foregroundColor: Colors.white,
        backgroundColor: PRIMARY_BLUE_COLOR,
        child: const Icon(
          Icons.calculate,
          size: PADDING_40,
        ),
      ),
    );
  }

  // **********
  // **********
  _buildProposalsListFutureBuilder() {
    return AppFutureBuilder(
        future: futureListOfProposals,
        successBuilder: ((ProposalListResponse result) {
          this.listOfProposals = result.list ?? [];
          return _buildProposalsListScreenContent();
        }));
  }

  // **********
  // **********
  _buildProposalsListScreenContent() {
    return Container(
        color: Colors.grey.shade100,
        padding: EdgeInsets.only(
            left: PADDING_10.widthResponsive(),
            right: PADDING_10.widthResponsive(),
            top: PADDING_10.widthResponsive()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
            child: TextView(
              textColor: const Color.fromARGB(255, 10, 65, 111),
              text:
                  "${proposalsListScreenVM.connectedUser?.data?.name} ${proposalsListScreenVM.connectedUser?.data?.surname}",
              isBold: true,
            ),
          ),
          SizedBox(height: PADDING_15.heightResponsive()),
          TextView(
            textColor: PRIMARY_BLUE_COLOR,
            text: "PROPOSITIONS",
            isBold: true,
          ),
          SizedBox(
            height: PADDING_5.heightResponsive(),
          ),
          SizedBox(
            height: PADDING_5.heightResponsive(),
          ),
          Expanded(
              child: listOfProposals.isEmpty
                  ? _buildEmptyScreen()
                  : _buildListOfProposals()),
        ]));
  }

  // **********
  // **********
  _buildListOfProposals() {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(
        child: RefreshIndicator(
          onRefresh: refreshProposalsList,
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: PADDING_10.heightResponsive()),
              itemCount: listOfProposals.length,
              itemBuilder: (BuildContext context, int index) {
                return ProposalListScreenItem(
                  item: listOfProposals[index],
                  onItemClick: (selectedItem) {
                    _onOrderItemClicked(selectedItem: selectedItem);
                  },
                );
              }),
        ),
      ),
    ]));
  }

  // **********
  // **********
  _onOrderItemClicked({required Proposal selectedItem}) {
    AppNavigation.goToProposalDetailsScreen(
        proposalId: selectedItem.ctrid ?? 0);
  }

  // **********
  // **********
  _buildEmptyScreen() {
    return Center(
      child: TextView(text: "Aucune propositions"),
    );
  }
}

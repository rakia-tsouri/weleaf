import 'package:flutter/material.dart';
import 'package:optorg_mobile/constants/colors.dart';
import 'package:optorg_mobile/constants/dimens.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/utils/app_navigation.dart';
import 'package:optorg_mobile/utils/extensions.dart';
import 'package:optorg_mobile/widgets/app_future_builder.dart';
import 'package:optorg_mobile/widgets/app_scaffold.dart';
import 'package:optorg_mobile/widgets/textview.dart';
import 'package:provider/provider.dart';
import 'proposals_list_screen_vm.dart';
import 'proposal_list_screen_item.dart';
import 'package:optorg_mobile/data/models/api_response.dart';


class ProposalsListScreen extends StatefulWidget {
  const ProposalsListScreen({super.key});

  @override
  State<ProposalsListScreen> createState() => _ProposalsListScreenState();
}

class _ProposalsListScreenState extends State<ProposalsListScreen> {
  late ProposalsListScreenVM proposalsListScreenVM;
  late Future<ApiResponse<ProposalListResponse>> futureListOfProposals;
  List<Proposal> listOfProposals = [];
  int _currentOffset = 0;
  String _selectedStatus = 'all';

  @override
  void initState() {
    proposalsListScreenVM =
        Provider.of<ProposalsListScreenVM>(context, listen: false);
    refreshProposalsList();
    super.initState();
  }

  Future<void> refreshProposalsList() async {
    setState(() {
      _currentOffset = 0;
      listOfProposals = [];
      futureListOfProposals =
          proposalsListScreenVM.getListOfProposals(offset: _currentOffset);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      displayBackButton: false,
      displayLogoutButton: false,
      displayUserIcon: true,
      withAppBar: false,
      backgroundColor: Colors.white,
      screenContent: Container(
        child: _buildProposalsListFutureBuilder(),
      ),

    );
  }

  Widget _buildProposalsListFutureBuilder() {
    return AppFutureBuilder(
      future: futureListOfProposals,
      successBuilder: (ProposalListResponse result) {
        listOfProposals = result.list ?? [];
        return _buildProposalsListScreenContent();
      },
    );
  }

  Widget _buildProposalsListScreenContent() {
    return Container(
      color: Colors.grey.shade100,
      padding: EdgeInsets.only(
        left: PADDING_10.widthResponsive(),
        right: PADDING_10.widthResponsive(),
        top: PADDING_10.widthResponsive(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserHeader(),
          SizedBox(height: PADDING_15.heightResponsive()),
          _buildHeaderSection(),
          SizedBox(height: PADDING_5.heightResponsive()),
          _buildFilterChips(),
          SizedBox(height: PADDING_10.heightResponsive()),
          _buildProposalsList(),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Center(
      child: TextView(
        textColor: const Color.fromARGB(255, 10, 65, 111),
        text: "${proposalsListScreenVM.connectedUser?.data?.name} "
            "${proposalsListScreenVM.connectedUser?.data?.surname}",
        isBold: true,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      children: [
        TextView(
          textColor: PRIMARY_BLUE_COLOR,
          text: "PROPOSITIONS",
          isBold: true,
        ),
        const Spacer(),
        _buildStatBadge('24', Colors.blue),
        SizedBox(width: PADDING_8.widthResponsive()),
        _buildStatBadge('8', Colors.orange),
        SizedBox(width: PADDING_8.widthResponsive()),
        _buildStatBadge('12', Colors.green),
        SizedBox(width: PADDING_8.widthResponsive()),
        _buildStatBadge('4', Colors.red),
      ],
    );
  }

  Widget _buildStatBadge(String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: PADDING_8.widthResponsive(),
        vertical: PADDING_4.heightResponsive(),
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatusChip('Toutes', 'all'),
          _buildStatusChip('Brouillon', 'draft'),
          _buildStatusChip('Envoyées', 'sent'),
          _buildStatusChip('Acceptées', 'accepted'),
          _buildStatusChip('Refusées', 'rejected'),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(right: PADDING_8.widthResponsive()),
      child: ChoiceChip(
        label: Text(label),
        selected: _selectedStatus == value,
        onSelected: (selected) => setState(() => _selectedStatus = value),
        selectedColor: PRIMARY_BLUE_COLOR.withOpacity(0.2),
        labelStyle: TextStyle(
          color: _selectedStatus == value ? PRIMARY_BLUE_COLOR : Colors.grey,
        ),
      ),
    );
  }

  Widget _buildProposalsList() {
    final filteredProposals = _getFilteredProposals();

    return Expanded(
      child: filteredProposals.isEmpty
          ? _buildEmptyScreen()
          : RefreshIndicator(
        onRefresh: refreshProposalsList,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: PADDING_10.heightResponsive()),
          itemCount: filteredProposals.length,
          itemBuilder: (context, index) => ProposalListScreenItem(
            proposal: filteredProposals[index],
            onTap: () => _onProposalItemClicked(filteredProposals[index]),
            onEdit: () => _showEditDialog(context, filteredProposals[index]),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 48, color: Colors.grey),
          SizedBox(height: PADDING_16.heightResponsive()),
          TextView(text: "Aucune proposition trouvée"),
          SizedBox(height: PADDING_16.heightResponsive()),
          ElevatedButton(
            onPressed: () {},
            child: Text('Créer une nouvelle proposition'),
          ),
        ],
      ),
    );
  }

  List<Proposal> _getFilteredProposals() {
    if (_selectedStatus == 'all') return listOfProposals;

    switch (_selectedStatus) {
      case 'draft':
        return listOfProposals.where((prop) =>
        prop.ctstatus?.contains("SCOCREATED") == true).toList();
      case 'sent':
        return listOfProposals.where((prop) =>
        prop.ctstatus?.contains("INIT") == true).toList();
      case 'accepted':
        return listOfProposals.where((prop) =>
        prop.ctstatus?.contains("OFFCOMPLTE") == true).toList();
      case 'rejected':
        return listOfProposals.where((prop) =>
        prop.ctstatus != null &&
            !prop.ctstatus!.contains("SCOCREATED") &&
            !prop.ctstatus!.contains("INIT") &&
            !prop.ctstatus!.contains("OFFCOMPLTE")).toList();
      default:
        return listOfProposals;
    }
  }

  void _onProposalItemClicked(Proposal selectedItem) {
    AppNavigation.goToProposalDetailsScreen(
      proposalId: selectedItem.ctrid ?? 0,
    );
  }

  void _showEditDialog(BuildContext context, Proposal proposal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${proposal.propreference}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: proposal.ctdescription),
              ),
              SizedBox(height: PADDING_16.heightResponsive()),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: proposal.ctfinancedamount?.toString(),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Proposition modifiée')),
              );
            },
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }
}
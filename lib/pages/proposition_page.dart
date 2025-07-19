import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/repositories/proposal_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ProposalDetailsScreen.dart';

class ProposalsPage extends StatefulWidget {
  const ProposalsPage({Key? key}) : super(key: key);

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage> {
  final ProposalsRepository _repository = ProposalsRepository();
  List<Proposal> _proposals = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _selectedFilter = 'all';
  int _currentPage = 0;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadProposals();
  }

  Future<void> _loadProposals() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _repository.getProposalsList(
        offset: _currentPage * _itemsPerPage,
        limit: _itemsPerPage,
        status: _selectedFilter != 'all' ? _selectedFilter : null,
      );

      if (!mounted) return;

      if (response.isSuccess()) {
        setState(() {
          _proposals = response.data?.list ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Échec du chargement';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur : ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filtrer les propositions'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('all', 'Toutes'),
              _buildFilterOption('pending', 'En attente'),
              _buildFilterOption('approved', 'Approuvées'),
              _buildFilterOption('rejected', 'Rejetées'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return ListTile(
      title: Text(label),
      leading: Radio<String>(
        value: value,
        groupValue: _selectedFilter,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedFilter = newValue;
              _currentPage = 0;
            });
            _loadProposals();
          }
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildProposalCard(Proposal proposal) {
    Color statusColor;
    switch (proposal.ctstatus?.toLowerCase()) {
      case 'approved':
      case 'active':
        statusColor = Colors.green;
        break;
      case 'pending':
      case 'init':
        statusColor = Colors.orange;
        break;
      case 'rejected':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () => _showProposalDetails(proposal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (proposal.imageBytes != null)
              Image.memory(
                proposal.imageBytes!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 180,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.description, size: 50)),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          proposal.ctreference ?? proposal.propreference ?? 'Sans référence',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          proposal.ctstatus?.toUpperCase() ?? 'INCONNU',
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    proposal.clientname ?? 'Client non spécifié',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    proposal.ctdescription ?? 'Aucune description disponible',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${proposal.ctfinancedamount?.toStringAsFixed(2)} €',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        proposal.ctstatusdate ?? '',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProposalDetails(Proposal proposal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProposalDetailsScreen(proposal: proposal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: const Text('Mes Propositions'),
        backgroundColor: const Color(0xFF003D70),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : _proposals.isEmpty
          ? const Center(child: Text('Aucune proposition trouvée'))
          : RefreshIndicator(
        onRefresh: _loadProposals,
        child: ListView.builder(
          itemCount: _proposals.length,
          itemBuilder: (context, index) {
            return _buildProposalCard(_proposals[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action à définir : création proposition
        },
        backgroundColor: const Color(0xFF003D70),
        child: const Icon(Icons.add),
      ),
    );
  }
}

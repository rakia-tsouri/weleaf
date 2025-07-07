import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/repositories/proposal_repository.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';

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

      if (response.isSuccess()) {
        final proposals = response.data?.list ?? [];

        // Décoder base64 vers Uint8List
        for (final proposal in proposals) {
          if (proposal.imageBytes is String) {
            try {
              proposal.imageBytes = base64Decode(proposal.imageBytes as String);
            } catch (_) {
              proposal.imageBytes = null;
            }
          }
        }

        setState(() {
          _proposals = proposals;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message ?? 'Failed to load proposals';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load proposals';
        _isLoading = false;
      });
    }
  }

  Future<Uint8List?> _loadImage(String? imageUrl) async {
    if (imageUrl == null || imageUrl.isEmpty) return null;

    try {
      final fullUrl = 'https://demo-backend-utina.teamwill-digital.com/$imageUrl';
      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Proposals'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFilterOption('all', 'All Proposals'),
              _buildFilterOption('pending', 'Pending'),
              _buildFilterOption('approved', 'Approved'),
              _buildFilterOption('rejected', 'Rejected'),
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
          setState(() {
            _selectedFilter = newValue!;
            _currentPage = 0;
            _loadProposals();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildProposalCard(Proposal proposal) {
    Color statusColor;
    switch (proposal.ctstatus?.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green;
        break;
      case 'pending':
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
            FutureBuilder<Uint8List?>(
              future: proposal.imageBytes != null
                  ? Future.value(proposal.imageBytes as Uint8List)
                  : _loadImage(proposal.assetpictureurl),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.memory(
                    snapshot.data!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                } else {
                  return Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Center(
                      child: snapshot.connectionState == ConnectionState.waiting
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.description, size: 50),
                    ),
                  );
                }
              },
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
                          proposal.ctreference ?? 'No Reference',
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
                          proposal.ctstatus?.toUpperCase() ?? 'UNKNOWN',
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
                    proposal.clientname ?? 'No Client',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    proposal.ctdescription ?? 'No description',
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
                        proposal.ctorderdate ?? '',
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

  Future<void> _showProposalDetails(Proposal proposal) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(proposal.ctreference ?? 'Proposal Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (proposal.assetpictureurl != null && proposal.assetpictureurl!.isNotEmpty)
                  FutureBuilder<Uint8List?>(
                    future: proposal.imageBytes != null
                        ? Future.value(proposal.imageBytes as Uint8List)
                        : _loadImage(proposal.assetpictureurl),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Image.memory(
                          snapshot.data!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: snapshot.connectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator()
                                : const Icon(Icons.description, size: 50),
                          ),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 16),
                Text('Client: ${proposal.clientname ?? 'N/A'}'),
                const SizedBox(height: 8),
                Text('Amount: ${proposal.ctfinancedamount?.toStringAsFixed(2) ?? '0.00'} €'),
                const SizedBox(height: 8),
                Text('Status: ${proposal.ctstatus?.toUpperCase() ?? 'UNKNOWN'}'),
                const SizedBox(height: 16),
                const Text('Description:'),
                Text(proposal.ctdescription ?? 'No description provided'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Proposals'),
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
          ? const Center(child: Text('No proposals found'))
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
          // TODO: Implement create proposal flow
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

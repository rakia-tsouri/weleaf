import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/proposals_list_response.dart';
import 'package:optorg_mobile/data/repositories/proposal_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  void dispose() {
    // Annulez ici toutes les opérations asynchrones en cours
    super.dispose();
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
          _errorMessage = response.message ?? 'Failed to load proposals';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load proposals: ${e.toString()}';
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
          // TODO: Implémenter la création de proposition
        },
        backgroundColor: const Color(0xFF003D70),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProposalDetailsScreen extends StatefulWidget {
  final Proposal proposal;

  const ProposalDetailsScreen({Key? key, required this.proposal}) : super(key: key);

  @override
  State<ProposalDetailsScreen> createState() => _ProposalDetailsScreenState();
}

class _ProposalDetailsScreenState extends State<ProposalDetailsScreen> {
  Map<String, dynamic>? _proposalDetails;
  bool _isLoadingDetails = false;
  String _errorMessage = '';
  bool _isUnauthorized = false;

  @override
  void initState() {
    super.initState();
    _loadProposalDetails();
  }

  @override
  void dispose() {
    // Annulez ici toutes les opérations asynchrones en cours
    super.dispose();
  }

  Future<void> _loadProposalDetails() async {
    if (!mounted) return;

    setState(() {
      _isLoadingDetails = true;
      _errorMessage = '';
      _isUnauthorized = false;
    });

    try {
      final response = await http.get(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/proposal-service/api/proposal/${widget.proposal.ctrid ?? 4649}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzIiwiaWF0IjoxNzUyNDg4MDY1LCJleHAiOjE3NTMwOTI4NjV9.wBf-sy-GzkyiThM7PB-0ZUxmeDHxWyA2np_ZB3QUCI-dYZXuoTlTm-ynrot8ttrH4ln9m9begE5zOY3myfT4jg', // Remplacez par votre token
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        setState(() {
          _proposalDetails = json.decode(response.body);
          _isLoadingDetails = false;
        });
      } else if (response.statusCode == 401) {
        setState(() {
          _isLoadingDetails = false;
          _isUnauthorized = true;
          _errorMessage = 'Authentification requise';
        });
      } else {
        setState(() {
          _errorMessage = 'Erreur de chargement: ${response.statusCode}';
          _isLoadingDetails = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur: ${e.toString()}';
        _isLoadingDetails = false;
      });
    }
  }

  void _handleRetry() {
    if (_isUnauthorized) {
      // Gérer la reconnexion ici
      // Par exemple, naviguer vers l'écran de connexion
    } else {
      _loadProposalDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (widget.proposal.ctstatus?.toLowerCase()) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.proposal.ctreference ?? 'Détails'),
        backgroundColor: const Color(0xFF003D70),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.proposal.imageBytes != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  widget.proposal.imageBytes!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Icon(Icons.image_not_supported, size: 50)),
              ),
            const SizedBox(height: 24),

            // Informations principales
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Statut',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.proposal.ctstatus?.toUpperCase() ?? 'INCONNU',
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow('Référence', widget.proposal.ctreference ?? 'N/A'),
                    _buildDetailRow('Client', widget.proposal.clientname ?? 'N/A'),
                    _buildDetailRow('Date', widget.proposal.ctstatusdate ?? 'N/A'),
                    _buildDetailRow('Montant financé', '${widget.proposal.ctfinancedamount?.toStringAsFixed(2)} €'),
                    if (widget.proposal.prcodelabel != null)
                      _buildDetailRow('Programme', widget.proposal.prcodelabel!),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Détails financiers
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails financiers',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (widget.proposal.cteduration != null)
                      _buildDetailRow('Durée', '${widget.proposal.cteduration} mois'),
                    if (widget.proposal.cteupfrontamount != null)
                      _buildDetailRow('Apport initial', '${widget.proposal.cteupfrontamount?.toStringAsFixed(2)} €'),
                    if (widget.proposal.ctervamount != null)
                      _buildDetailRow('Valeur résiduelle', '${widget.proposal.ctervamount?.toStringAsFixed(2)} €'),
                    if (widget.proposal.cterentalamount != null)
                      _buildDetailRow('Loyer mensuel', '${widget.proposal.cterentalamount?.toStringAsFixed(2)} €'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Détails de la proposition
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Détails de la proposition',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isLoadingDetails)
                      const Center(child: CircularProgressIndicator())
                    else if (_isUnauthorized)
                      Column(
                        children: [
                          Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _handleRetry,
                            child: const Text('Se reconnecter'),
                          ),
                        ],
                      )
                    else if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (_proposalDetails != null)
                          ..._buildProposalDetails(_proposalDetails!)
                        else
                          const Text('Aucune information supplémentaire disponible'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProposalDetails(Map<String, dynamic> details) {
    return [
      if (details['data'] != null)
        ..._buildDataDetails(details['data']),
      if (details['clientData'] != null)
        ..._buildClientDetails(details['clientData']),
    ];
  }

  List<Widget> _buildDataDetails(Map<String, dynamic> data) {
    return [
      if (data['ctdescription'] != null)
        _buildDetailRow('Description', data['ctdescription']),
      if (data['ctnetworkcode'] != null)
        _buildDetailRow('Réseau', data['ctnetworkcode']),
      if (data['ctstage'] != null)
        _buildDetailRow('Étape', data['ctstage']),
      if (data['ctvaliditydate'] != null)
        _buildDetailRow('Date de validité', data['ctvaliditydate']),
      if (data['ctrequestdate'] != null)
        _buildDetailRow('Date de demande', data['ctrequestdate']),
    ];
  }

  List<Widget> _buildClientDetails(Map<String, dynamic> clientData) {
    return [
      const SizedBox(height: 16),
      const Text(
        'Informations client',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      if (clientData['generalData'] != null)
        ..._buildGeneralClientDetails(clientData['generalData']),
      if (clientData['address'] != null)
        ..._buildAddressDetails(clientData['address']),
    ];
  }

  List<Widget> _buildGeneralClientDetails(Map<String, dynamic> generalData) {
    return [
      if (generalData['tpname'] != null || generalData['tpsurname'] != null)
        _buildDetailRow(
            'Nom complet',
            '${generalData['tpname'] ?? ''} ${generalData['tpsurname'] ?? ''}'
        ),
      if (generalData['tpfiscalid'] != null)
        _buildDetailRow('Identifiant fiscal', generalData['tpfiscalid']),
      if (generalData['tptaxid'] != null)
        _buildDetailRow('Numéro de TVA', generalData['tptaxid']),
    ];
  }

  List<Widget> _buildAddressDetails(Map<String, dynamic> address) {
    return [
      if (address['tpmainadrstreet1'] != null || address['tpmainadrcity'] != null)
        _buildDetailRow(
            'Adresse',
            '${address['tpmainadrstreet1'] ?? ''}\n'
                '${address['tpmainadrzipcode'] ?? ''} ${address['tpmainadrcity'] ?? ''}'
        ),
      if (address['tptel1'] != null)
        _buildDetailRow('Téléphone', address['tptel1']),
      if (address['tpemail1'] != null)
        _buildDetailRow('Email', address['tpemail1']),
    ];
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
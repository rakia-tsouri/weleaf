import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/proposals_list_response.dart';

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
  Map<String, dynamic>? _assetDetails;

  @override
  void initState() {
    super.initState();
    _loadProposalDetails();
    _loadAssetDetails();
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
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/proposal-service/api/proposal/${widget.proposal.ctrid}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzIiwiaWF0IjoxNzUyNDg4MDY1LCJleHAiOjE3NTMwOTI4NjV9.wBf-sy-GzkyiThM7PB-0ZUxmeDHxWyA2np_ZB3QUCI-dYZXuoTlTm-ynrot8ttrH4ln9m9begE5zOY3myfT4jg',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _proposalDetails = data;
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

  Future<void> _loadAssetDetails() async {
    if (!mounted) return;

    final assetId = widget.proposal.ctrid; // Assurez-vous que ce champ existe dans Proposal

    if (assetId == null ) {
      print('❌ Aucun assetid dans proposal');
      return;
    }

    try {
      print('🔎 Fetching asset with ID: $assetId');
      final response = await http.get(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/asset-service/api/assets/$assetId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzIiwiaWF0IjoxNzUyNDg4MDY1LCJleHAiOjE3NTMwOTI4NjV9.wBf-sy-GzkyiThM7PB-0ZUxmeDHxWyA2np_ZB3QUCI-dYZXuoTlTm-ynrot8ttrH4ln9m9begE5zOY3myfT4jg',
        },
      );

      print('🔁 Asset details status: ${response.statusCode}');

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _assetDetails = data;
        });
      } else {
        print('⚠️ Asset fetch failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading asset details: $e');
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
            _buildInfoCard(
              title: 'Informations principales',
              children: [
                _buildStatusRow(statusColor),
                const SizedBox(height: 12),
                _buildDetailRow('Référence', widget.proposal.ctreference ?? 'N/A'),
                _buildDetailRow('Client', widget.proposal.clientname ?? 'N/A'),
                _buildDetailRow('Date', widget.proposal.ctstatusdate ?? 'N/A'),
                _buildDetailRow('Montant financé', '${widget.proposal.ctfinancedamount?.toStringAsFixed(2)} €'),
                if (widget.proposal.prcodelabel != null)
                  _buildDetailRow('Programme', widget.proposal.prcodelabel!),
              ],
            ),

            const SizedBox(height: 16),

            // Détails financiers
            _buildInfoCard(
              title: 'Détails financiers',
              children: [
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

            const SizedBox(height: 16),

            // Détails de l'asset
            _buildInfoCard(
              title: 'Détails du véhicule',
              children: _assetDetails != null
                  ? _buildAssetDetails(_assetDetails!)
                  : [const Text('Aucun détail véhicule disponible.')],
            ),

            const SizedBox(height: 16),

            // Détails de la proposition
            _buildInfoCard(
              title: 'Détails de la proposition',
              children: [
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
                        onPressed: _loadProposalDetails,
                        child: const Text('Réessayer'),
                      ),
                    ],
                  )
                else if (_errorMessage.isNotEmpty)
                    Text(_errorMessage, style: const TextStyle(color: Colors.red))
                  else if (_proposalDetails != null)
                      ..._buildProposalDetails(_proposalDetails!)
                    else
                      const Text('Aucune information supplémentaire disponible'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> children}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(Color statusColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Statut', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            widget.proposal.ctstatus?.toUpperCase() ?? 'INCONNU',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildAssetDetails(Map<String, dynamic> asset) {
    return [
      if (asset['model'] != null)
        _buildDetailRow('Modèle', asset['model']),
      if (asset['brand'] != null)
        _buildDetailRow('Marque', asset['brand']),
      if (asset['year'] != null)
        _buildDetailRow('Année', asset['year'].toString()),
      if (asset['vin'] != null)
        _buildDetailRow('N° de série', asset['vin']),
      if (asset['color'] != null)
        _buildDetailRow('Couleur', asset['color']),
      if (asset['mileage'] != null)
        _buildDetailRow('Kilométrage', '${asset['mileage']} km'),
      if (asset['registrationNumber'] != null)
        _buildDetailRow('Immatriculation', asset['registrationNumber']),
    ];
  }

  List<Widget> _buildProposalDetails(Map<String, dynamic> details) {
    return [
      if (details['data']?['ctnetworkcode'] != null)
        _buildDetailRow('Réseau', details['data']['ctnetworkcode']),
      if (details['data']?['ctstage'] != null)
        _buildDetailRow('Étape', details['data']['ctstage']),
      if (details['data']?['ctvaliditydate'] != null)
        _buildDetailRow('Date de validité', details['data']['ctvaliditydate']),
      if (details['data']?['ctrequestdate'] != null)
        _buildDetailRow('Date de demande', details['data']['ctrequestdate']),
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
            child: Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

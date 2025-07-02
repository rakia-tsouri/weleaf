import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'detailsContrat.dart';

class ListContratsPage extends StatefulWidget {
  const ListContratsPage({super.key});

  @override
  State<ListContratsPage> createState() => _ListContratsPageState();
}

class _ListContratsPageState extends State<ListContratsPage> {
  final String _apiUrl = "https://demo-backend-utina.teamwill-digital.com/fincontract-service/api/contract";
  List<dynamic> _contrats = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchContrats();
  }

  Future<void> _fetchContrats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          _contrats = data.where((c) => c['tpidclient'] == 823).toList();
        });
      } else {
        throw Exception('Échec du chargement: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    await _fetchContrats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Mes Contrats'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refresh,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Erreur de chargement',
            style: TextStyle(fontSize: 18, color: Colors.red[700]),
          ),
          const SizedBox(height: 20),
          Text(
            _error!.contains('401')
                ? 'Authentification requise - Veuillez vous reconnecter'
                : _error!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: _fetchContrats,
            child: const Text('Réessayer'),
          ),
          if (_error!.contains('401'))
            TextButton(
              onPressed: () {
                // Ajoutez votre logique de déconnexion ici
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false,
                );
              },
              child: const Text('Se reconnecter'),
            ),
        ],
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _contrats.length,
        itemBuilder: (context, index) {
          final contrat = _contrats[index];
          return _buildContratCard(contrat);
        },
      ),
    );
  }

  Widget _buildContratCard(Map<String, dynamic> contrat) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencyFormat = NumberFormat.currency(symbol: 'MAD', decimalDigits: 2);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.directions_car, size: 24),
                const SizedBox(width: 8),
                Text(
                  contrat['ctdescription'] ?? 'Contrat',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              contrat['ctreference'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            // Ligne Mensualité + Échéances
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Mensualité', currencyFormat.format(contrat['cterentalamount'] ?? 0)),
                _buildInfoColumn('Échéances restantes', contrat['cteduration']?.toString() ?? '0'),
              ],
            ),
            const SizedBox(height: 16),

            // Ligne Début + Fin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Début', _formatDate(contrat['ctestartdate'])),
                _buildInfoColumn('Fin', _formatDate(contrat['cteenddate'])),
              ],
            ),
            const SizedBox(height: 16),

            // Bouton Détails
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _navigateToDetails(context, contrat),
                icon: const Icon(Icons.visibility, color: Colors.black),
                label: const Text(
                  'Voir les détails',
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[400]!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    } catch (e) {
      return date.toString();
    }
  }

  void _navigateToDetails(BuildContext context, Map<String, dynamic> contrat) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContractDetailsPage(contractData: contrat),
      ),
    );
  }
}
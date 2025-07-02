import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContractDetailsPage extends StatelessWidget {
  final Map<String, dynamic> contractData;

  const ContractDetailsPage({super.key, required this.contractData});

  @override
  Widget build(BuildContext context) {
    // Formateurs pour les données
    final currencyFormat = NumberFormat.currency(symbol: 'MAD', decimalDigits: 2);
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Détails du contrat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // Section Informations de base
                const SectionTitle(title: 'Informations du contrat', icon: Icons.description),
                DetailItem(
                  label: 'Référence proposition',
                  value: contractData['propreference'] ?? 'N/A',
                ),
                DetailItem(
                  label: 'ID Contrat',
                  value: contractData['ctrid']?.toString() ?? 'N/A',
                ),
                DetailItem(
                  label: 'Référence contrat',
                  value: contractData['ctreference'] ?? 'N/A',
                ),
                DetailItem(
                  label: 'Description',
                  value: contractData['ctdescription'] ?? 'N/A',
                ),
                DetailItem(
                  label: 'Offre',
                  value: contractData['offeridlabel'] ?? 'N/A',
                ),

                // Section Client
                const SectionTitle(title: 'Client', icon: Icons.person),
                DetailItem(
                  label: 'Nom client',
                  value: contractData['clientname'] ?? 'N/A',
                ),

                // Section Statut
                const SectionTitle(title: 'Statut', icon: Icons.notifications_active),
                DetailItem(
                  label: 'Statut',
                  value: contractData['ctstatus'] ?? 'N/A',
                ),
                DetailItem(
                  label: 'Date statut',
                  value: _formatDate(contractData['ctstatusdate']),
                ),

                // Section Période
                const SectionTitle(title: 'Période', icon: Icons.calendar_today),
                DetailItem(
                  label: 'Date début',
                  value: _formatDate(contractData['ctestartdate']),
                ),
                DetailItem(
                  label: 'Date fin',
                  value: _formatDate(contractData['cteenddate']),
                ),
                DetailItem(
                  label: 'Durée (mois)',
                  value: contractData['cteduration']?.toString() ?? 'N/A',
                ),

                // Section Paiement
                const SectionTitle(title: 'Paiement', icon: Icons.payment),
                DetailItem(
                  label: 'Premier paiement',
                  value: currencyFormat.format(contractData['ctefirstpayment'] ?? 0),
                ),
                DetailItem(
                  label: 'Loyer mensuel',
                  value: currencyFormat.format(contractData['cterentalamount'] ?? 0),
                ),
              ],
            ),
          ),
        ),
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
}

// Widgets réutilisables (inchangés)
class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label :',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const SectionTitle({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
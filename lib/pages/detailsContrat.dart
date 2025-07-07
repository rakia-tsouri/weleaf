import 'package:flutter/material.dart';

class ContractDetailsPage extends StatelessWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                const DetailItem(label: 'Référence proposition', value: '0000004562'),
                const DetailItem(label: 'ID Contrat', value: '4625'),
                const DetailItem(label: 'Référence contrat', value: '0000002786'),
                const DetailItem(label: 'Description', value: 'Scania S580'),
                const DetailItem(label: 'Offre', value: 'Long-term rental offer SC'),

                // Section Client
                const SectionTitle(title: 'Client', icon: Icons.person),
                const DetailItem(label: 'Nom client', value: 'Ahmed Mahmoud'),

                // Section Statut
                const SectionTitle(title: 'Statut', icon: Icons.notifications_active), // a changer
                const DetailItem(label: 'Statut', value: 'ACTIVE'),
                const DetailItem(label: 'Date statut', value: '18/06/2025'),

                // Section Période
                const SectionTitle(title: 'Période', icon: Icons.calendar_today),
                const DetailItem(label: 'Date début', value: '18/06/2025'),
                const DetailItem(label: 'Date fin', value: '25/06/2028'),
                const DetailItem(label: 'Durée (mois)', value: '36'),

                // Section Paiement
                const SectionTitle(title: 'Paiement', icon: Icons.payment),
                const DetailItem(label: 'Premier paiement', value: '7 310,00 MAD'),
                const DetailItem(label: 'Loyer mensuel', value: '22 131,57 MAD'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widgets réutilisables (à garder identiques)
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
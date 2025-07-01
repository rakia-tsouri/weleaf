import 'package:flutter/material.dart';

class ContractDetailsPage extends StatelessWidget {
  const ContractDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Fond gris clair pour la page
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
          color: Colors.white, // Fond blanc pour la carte
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SectionTitle(
                  title: 'Informations générales',
                  icon: Icons.description,
                ),
                const DetailItem(
                  label: 'Proposition',
                  value: 'Proposition ABC123',
                ),
                const DetailItem(label: 'Contrat', value: '#LC001'),
                const DetailItem(label: 'Produit', value: 'BMW X3 2023'),
                const DetailItem(label: 'Offre', value: 'Offre Premium'),

                const SectionTitle(title: 'Client', icon: Icons.person),
                const DetailItem(label: 'Nom du client', value: 'Jean Dupont'),

                const SectionTitle(
                  title: 'État du contrat',
                  icon: Icons.timeline,
                ),
                const DetailItem(label: 'Statut', value: 'Actif'),
                const DetailItem(label: 'Date statut', value: '15/06/2023'),

                const SectionTitle(title: 'Paiement', icon: Icons.payment),
                const DetailItem(
                  label: 'Mode de paiement',
                  value: 'Virement bancaire',
                ),
                const DetailItem(
                  label: 'RIB',
                  value: 'FR76 3000 6000 0112 3456 7890 189',
                ),
                const DetailItem(label: 'BIC', value: 'AGRIFRPP'),
                const DetailItem(
                  label: 'Nom de la banque',
                  value: 'Crédit Agricole',
                ),
                const DetailItem(label: 'Mensualité', value: '500 €'),
                const DetailItem(label: 'Échéances restantes', value: '24'),
                const DetailItem(label: 'Interets de retard', value: '0 €'),
                const DetailItem(label: 'Début', value: '01/07/2023'),
                const DetailItem(label: 'Fin', value: '01/07/2025'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
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
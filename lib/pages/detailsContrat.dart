// pages/detailsContrat.dart
import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/contract.dart';

class ContractDetailsPage extends StatelessWidget {
  final Contract contract;

  const ContractDetailsPage({super.key, required this.contract});

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
                DetailItem(label: 'Référence proposition', value: contract.propreference),
                DetailItem(label: 'ID Contrat', value: contract.ctrid.toString()),
                DetailItem(label: 'Référence contrat', value: contract.ctreference),
                DetailItem(label: 'Description', value: contract.ctdescription),
                DetailItem(label: 'Offre', value: contract.offeridlabel),

                // Section Client
                const SectionTitle(title: 'Client', icon: Icons.person),
                DetailItem(label: 'Nom client', value: contract.clientname),
                DetailItem(label: 'Référence client', value: contract.clientreference),

                // Section Statut
                const SectionTitle(title: 'Statut', icon: Icons.notifications_active),
                DetailItem(label: 'Statut', value: contract.statuslabel),
                if (contract.ctactivationdate != null)
                  DetailItem(
                      label: 'Date activation',
                      value: '${contract.ctactivationdate!.day}/${contract.ctactivationdate!.month}/${contract.ctactivationdate!.year}'
                  ),

                // Section Période
                const SectionTitle(title: 'Période', icon: Icons.calendar_today),
                DetailItem(label: 'Date début', value: contract.ctestartdate),
                DetailItem(label: 'Date fin', value: contract.cteenddate),
                DetailItem(label: 'Durée (mois)', value: contract.cteduration.toString()),

                // Section Paiement
                const SectionTitle(title: 'Paiement', icon: Icons.payment),
                DetailItem(
                    label: 'Premier paiement',
                    value: '${contract.ctefirstpayment.toStringAsFixed(2)} ${contract.currcode}'
                ),
                DetailItem(
                    label: 'Loyer mensuel',
                    value: '${contract.cterentalamount.toStringAsFixed(2)} ${contract.currcode}'
                ),
                DetailItem(
                    label: 'Montant financé',
                    value: '${contract.ctfinancedamount.toStringAsFixed(2)} ${contract.currcode}'
                ),
                DetailItem(
                    label: 'Valeur résiduelle',
                    value: '${contract.ctervamount.toStringAsFixed(2)} ${contract.currcode}'
                ),
                DetailItem(
                    label: 'Taux nominal',
                    value: '${contract.ctenominalrate.toStringAsFixed(2)}%'
                ),
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
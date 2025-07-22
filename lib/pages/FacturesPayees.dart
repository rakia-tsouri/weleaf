// pages/factures_payees_page.dart
import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/widgets/facture_card.dart';

class FacturesPayeesPage extends StatelessWidget {
  final List<Facture> factures;

  const FacturesPayeesPage({super.key, required this.factures});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures Payées'),
        backgroundColor: const Color(0xFF2563EB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: factures.isEmpty
          ? const Center(child: Text('Aucune facture payée'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: factures.length,
        itemBuilder: (context, index) {
          final facture = factures[index];
          return FactureCard(
            facture: facture,
            onVoirPressed: () => _showFactureDetails(context, facture),
            onDownloadPressed: () => _downloadFacture(facture),
          );
        },
      ),
    );
  }

  void _showFactureDetails(BuildContext context, Facture facture) {
    // Implémentez la navigation vers les détails
  }

  void _downloadFacture(Facture facture) {
    // Implémentez le téléchargement
  }
}
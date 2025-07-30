import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/widgets/facture_card.dart';

class FacturesImpayeesPage extends StatelessWidget {
  final List<Facture> factures;

  const FacturesImpayeesPage({super.key, required this.factures});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures Impayées'),
        backgroundColor: const Color(0xFF2563EB),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: factures.isEmpty
          ? const Center(child: Text('Aucune facture impayée'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: factures.length,
        itemBuilder: (context, index) {
          final facture = factures[index];
          return FactureCard(
            facture: facture,
            // The "Voir" action is already handled internally in FactureCard
          );
        },
      ),
    );
  }

  void _downloadFacture(Facture facture) {
    // Implémentez le téléchargement
  }
}
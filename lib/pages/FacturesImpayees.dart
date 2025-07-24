// pages/factures_impayees_page.dart
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
            onDownloadPressed: () => _downloadFacture(facture),
            onActionPressed: () => _handlePaymentAction(context, facture),
            // The "Voir" action is already handled internally in FactureCard
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

  void _handlePaymentAction(BuildContext context, Facture facture) {
    final isEnRetard = facture.cistatus == 'INPROG' &&
        facture.cidocdate.isBefore(DateTime.now());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEnRetard ? 'Paiement' : 'Programmer paiement'),
        content: Text(isEnRetard
            ? 'Voulez-vous payer cette facture maintenant?'
            : 'Voulez-vous programmer le paiement de cette facture?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implémentez la logique de paiement
            },
            child: Text(isEnRetard ? 'Payer' : 'Programmer'),
          ),
        ],
      ),
    );
  }
}
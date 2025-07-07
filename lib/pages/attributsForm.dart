import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttributsDisplay extends StatelessWidget {
  final VoidCallback? onBack;
  const AttributsDisplay({Key? key, this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Données fictives pour l'affichage
    final financementData = {
      'Mode de Paiement': 'Virement',
      'IBAN / RIB': 'FR76 3000 1007 1600 0000 0000 123',
      'BIC': 'BNPAFRPPXXX',
      'Nom de la Banque': 'BNP Paribas',
      'Délai de Paiement': '30 jours',
    };

    final facturationData = {
      'Mode de Facturation': 'Électronique',
      "Mode d'Envoi des Factures": 'Email',
      'Destinataire': 'Service Comptabilité',
      'Adresse': '12 Rue de la Paix',
      'Adresse Complémentaire': 'Bâtiment B, 2ème étage',
      'Code Postal': '75001',
      'Ville': 'Paris',
      'Région': 'Île-de-France',
      'Région Globale': 'ILE',
      'Pays': 'FR-FRANCE',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDataSection(
              title: 'Éléments de Financement',
              data: financementData,
            ),
            const SizedBox(height: 16),
            _buildDataSection(
              title: 'Adresse de Facturation',
              data: facturationData,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection({
    required String title,
    required Map<String, String> data,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ...data.entries.map((entry) => _buildDataRow(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
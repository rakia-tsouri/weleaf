import 'package:flutter/material.dart';
import 'package:optorg_mobile/widgets/CatalogueCarousel.dart'; // Importer ton widget carousel

class NosProduitsEtStats extends StatelessWidget {
  const NosProduitsEtStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CatalogueCarousel(), // On utilise ton widget réutilisable
        const SizedBox(height: 32),
        const Text(
          'Aperçu rapide',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.7, // Ajustez ce ratio selon vos besoins
          children: [
            _buildStatCard('Contrats actifs', '156', Icons.description, Colors.green),
            _buildStatCard('Factures en attente', '23', Icons.receipt, Colors.orange),
            _buildStatCard('Montant total', '12 €', Icons.euro, Colors.blue),
            _buildStatCard('Impayés', '89 €', Icons.warning, Colors.red),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced vertical padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, size: 26, color: color),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}

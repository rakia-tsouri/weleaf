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
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard('Contrats actifs', '156', Icons.description, Colors.green),
            _buildStatCard('Factures', '23', Icons.pending, Colors.orange),
            _buildStatCard('Impayés', '89', Icons.receipt, Colors.blue),
            _buildStatCard('Montant total', '12', Icons.task, Colors.purple),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

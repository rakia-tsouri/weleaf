import 'package:flutter/material.dart';
import 'detailsContrat.dart';

class ListContratsPage extends StatelessWidget {
  const ListContratsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Mes Contrats'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Padding(padding: EdgeInsets.all(16), child: ContractsList()),
    );
  }
}

class ContractsList extends StatelessWidget {
  const ContractsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ContractCard(
          title: 'BMW X3 2023',
          contractNumber: '#LC001',
          monthly: '850€',
          remaining: '24',
          start: '15/06/2023',
          end: '15/06/2026',
        ),
        SizedBox(height: 16),
        ContractCard(
          title: 'Audi A4 2022',
          contractNumber: '#LC002',
          monthly: '700€',
          remaining: '18',
          start: '01/01/2023',
          end: '01/07/2025',
        ),
      ],
    );
  }
}

class ContractCard extends StatelessWidget {
  final String title;
  final String contractNumber;
  final String monthly;
  final String remaining;
  final String start;
  final String end;

  const ContractCard({
    super.key,
    required this.title,
    required this.contractNumber,
    required this.monthly,
    required this.remaining,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre + icône
            Row(
              children: [
                const Icon(Icons.directions_car, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(contractNumber, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),

            // Mensualité & Échéances
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mensualité',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        monthly,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Échéances restantes',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remaining,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Début & Fin
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Début', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        start,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Fin', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(
                        end,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Bouton Voir les détails
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContractDetailsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility, color: Colors.black),
                label: const Text(
                  'Voir les détails',
                  style: TextStyle(color: Colors.black),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey[400]!),
                  foregroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
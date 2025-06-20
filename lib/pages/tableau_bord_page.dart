import 'package:flutter/material.dart';

class TableauBordPage extends StatefulWidget {
  const TableauBordPage({super.key});

  @override
  State<TableauBordPage> createState() => _TableauBordPageState();
}

class _TableauBordPageState extends State<TableauBordPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tableau de bord'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Plan comptable'),
            Tab(text: 'CRE non extraite'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlanComptablePage(),
          _buildCREPage(),
        ],
      ),
    );
  }

  Widget _buildPlanComptablePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan comptable',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Résumé financier
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildFinancialCard('Total Actif', '2 450 000 €', Icons.trending_up, Colors.green),
              _buildFinancialCard('Total Passif', '1 890 000 €', Icons.trending_down, Colors.red),
              _buildFinancialCard('Chiffre d\'affaires', '890 000 €', Icons.monetization_on, Colors.blue),
              _buildFinancialCard('Résultat net', '156 000 €', Icons.account_balance, Colors.purple),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Liste des comptes
          const Text(
            'Comptes principaux',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(10, (index) {
            final comptes = [
              {'numero': '101000', 'libelle': 'Capital social', 'solde': '500 000 €'},
              {'numero': '164000', 'libelle': 'Emprunts auprès des établissements de crédit', 'solde': '1 200 000 €'},
              {'numero': '211000', 'libelle': 'Terrains', 'solde': '300 000 €'},
              {'numero': '213000', 'libelle': 'Constructions', 'solde': '800 000 €'},
              {'numero': '218000', 'libelle': 'Autres immobilisations corporelles', 'solde': '450 000 €'},
              {'numero': '411000', 'libelle': 'Clients', 'solde': '125 000 €'},
              {'numero': '421000', 'libelle': 'Personnel', 'solde': '15 000 €'},
              {'numero': '512000', 'libelle': 'Banques', 'solde': '85 000 €'},
              {'numero': '701000', 'libelle': 'Ventes de produits finis', 'solde': '890 000 €'},
              {'numero': '641000', 'libelle': 'Rémunérations du personnel', 'solde': '180 000 €'},
            ];
            
            if (index < comptes.length) {
              final compte = comptes[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(
                      compte['numero']!.substring(0, 3),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('${compte['numero']} - ${compte['libelle']}'),
                  trailing: Text(
                    compte['solde']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildCREPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CRE non extraite',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Filtres
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Période',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'janvier', child: Text('Janvier 2024')),
                    DropdownMenuItem(value: 'fevrier', child: Text('Février 2024')),
                    DropdownMenuItem(value: 'mars', child: Text('Mars 2024')),
                  ],
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Filtrer'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Liste des CRE
          const Text(
            'Écritures en attente d\'extraction',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(8, (index) {
            final ecritures = [
              {'date': '15/01/2024', 'libelle': 'Facture client ABC-001', 'montant': '1 250,00 €', 'compte': '411000'},
              {'date': '16/01/2024', 'libelle': 'Paiement fournisseur XYZ', 'montant': '890,00 €', 'compte': '401000'},
              {'date': '17/01/2024', 'libelle': 'Salaires janvier 2024', 'montant': '15 000,00 €', 'compte': '641000'},
              {'date': '18/01/2024', 'libelle': 'Loyer bureaux janvier', 'montant': '2 500,00 €', 'compte': '613000'},
              {'date': '19/01/2024', 'libelle': 'Vente contrat leasing LC-045', 'montant': '3 200,00 €', 'compte': '701000'},
              {'date': '20/01/2024', 'libelle': 'Assurance véhicules', 'montant': '450,00 €', 'compte': '616000'},
              {'date': '21/01/2024', 'libelle': 'Frais bancaires', 'montant': '125,00 €', 'compte': '627000'},
              {'date': '22/01/2024', 'libelle': 'Achat matériel bureau', 'montant': '680,00 €', 'compte': '606000'},
            ];
            
            if (index < ecritures.length) {
              final ecriture = ecritures[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange.withOpacity(0.1),
                    child: const Icon(Icons.pending, color: Colors.orange),
                  ),
                  title: Text(ecriture['libelle']!),
                  subtitle: Text('${ecriture['date']} - Compte: ${ecriture['compte']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        ecriture['montant']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'En attente',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          
          const SizedBox(height: 16),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Extraire toutes les écritures'),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Valider sélection'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialCard(String title, String value, IconData icon, Color color) {
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

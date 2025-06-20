import 'package:flutter/material.dart';

class DossierEtudePage extends StatefulWidget {
  const DossierEtudePage({super.key});

  @override
  State<DossierEtudePage> createState() => _DossierEtudePageState();
}

class _DossierEtudePageState extends State<DossierEtudePage> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dossiers d\'étude'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewDossierDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatusChip('Tous', 'all'),
                  _buildStatusChip('En cours', 'progress'),
                  _buildStatusChip('En attente', 'pending'),
                  _buildStatusChip('Validés', 'validated'),
                  _buildStatusChip('Refusés', 'rejected'),
                ],
              ),
            ),
          ),
          
          // Statistiques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildStatCard('Total', '18', Colors.blue),
                _buildStatCard('En cours', '6', Colors.orange),
                _buildStatCard('Validés', '9', Colors.green),
                _buildStatCard('Refusés', '3', Colors.red),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Liste des dossiers
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredDossiers().length,
              itemBuilder: (context, index) {
                final dossier = _getFilteredDossiers()[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                dossier['numero']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildDossierStatusChip(dossier['statut']!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dossier['client']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dossier['objet']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Barre de progression
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Progression',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  '${dossier['progression']}%',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: int.parse(dossier['progression']!) / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _getProgressColor(int.parse(dossier['progression']!)),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Créé le ${dossier['dateCreation']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            Text(
                              dossier['montant']!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showDossierDetails(context, dossier),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Voir'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showEditDossierDialog(context, dossier),
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Modifier'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showDossierMenu(context, dossier),
                              icon: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedStatus == value,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = value;
          });
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              label,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDossierStatusChip(String status) {
    Color color;
    switch (status) {
      case 'En cours':
        color = Colors.blue;
        break;
      case 'En attente':
        color = Colors.orange;
        break;
      case 'Validé':
        color = Colors.green;
        break;
      case 'Refusé':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    
    return Chip(
      label: Text(status),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }

  Color _getProgressColor(int progress) {
    if (progress < 30) return Colors.red;
    if (progress < 70) return Colors.orange;
    return Colors.green;
  }

  List<Map<String, String>> _getFilteredDossiers() {
    final dossiers = [
      {
        'numero': 'DE-2024-001',
        'client': 'ABC Corporation',
        'objet': 'Étude financement BMW X3',
        'montant': '45 000 €',
        'statut': 'En cours',
        'progression': '65',
        'dateCreation': '20/01/2024',
        'analyste': 'Marie Dupont',
      },
      {
        'numero': 'DE-2024-002',
        'client': 'Tech Solutions SARL',
        'objet': 'Étude leasing équipement IT',
        'montant': '12 500 €',
        'statut': 'Validé',
        'progression': '100',
        'dateCreation': '18/01/2024',
        'analyste': 'Jean Martin',
      },
      {
        'numero': 'DE-2024-003',
        'client': 'Transport Plus',
        'objet': 'Étude financement flotte véhicules',
        'montant': '125 000 €',
        'statut': 'En attente',
        'progression': '25',
        'dateCreation': '15/01/2024',
        'analyste': 'Sophie Bernard',
      },
      {
        'numero': 'DE-2024-004',
        'client': 'Entreprise Delta',
        'objet': 'Étude leasing photocopieur',
        'montant': '8 500 €',
        'statut': 'Refusé',
        'progression': '100',
        'dateCreation': '12/01/2024',
        'analyste': 'Pierre Durand',
      },
      {
        'numero': 'DE-2024-005',
        'client': 'Garage Central',
        'objet': 'Étude financement équipement atelier',
        'montant': '35 000 €',
        'statut': 'En cours',
        'progression': '80',
        'dateCreation': '10/01/2024',
        'analyste': 'Marie Dupont',
      },
    ];

    if (_selectedStatus == 'all') {
      return dossiers;
    }

    String filterStatus;
    switch (_selectedStatus) {
      case 'progress':
        filterStatus = 'En cours';
        break;
      case 'pending':
        filterStatus = 'En attente';
        break;
      case 'validated':
        filterStatus = 'Validé';
        break;
      case 'rejected':
        filterStatus = 'Refusé';
        break;
      default:
        return dossiers;
    }

    return dossiers.where((dossier) => dossier['statut'] == filterStatus).toList();
  }

  void _showDossierDetails(BuildContext context, Map<String, String> dossier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(dossier['numero']!),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Client', dossier['client']!),
              _buildDetailRow('Objet', dossier['objet']!),
              _buildDetailRow('Montant', dossier['montant']!),
              _buildDetailRow('Statut', dossier['statut']!),
              _buildDetailRow('Progression', '${dossier['progression']}%'),
              _buildDetailRow('Date de création', dossier['dateCreation']!),
              _buildDetailRow('Analyste', dossier['analyste']!),
              
              const SizedBox(height: 16),
              const Text(
                'Documents requis:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildDocumentItem('Bilan comptable', true),
              _buildDocumentItem('Compte de résultat', true),
              _buildDocumentItem('Kbis', false),
              _buildDocumentItem('RIB', true),
              _buildDocumentItem('Pièce d\'identité dirigeant', false),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (dossier['statut'] == 'En cours')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditDossierDialog(context, dossier);
              },
              child: const Text('Modifier'),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildDocumentItem(String document, bool isReceived) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            isReceived ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: isReceived ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(
            document,
            style: TextStyle(
              color: isReceived ? Colors.black : Colors.grey,
              decoration: isReceived ? null : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  void _showNewDossierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau dossier d\'étude'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Client',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Objet de l\'étude',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Montant (€)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Analyste assigné',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dossier d\'étude créé avec succès')),
              );
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditDossierDialog(BuildContext context, Map<String, String> dossier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${dossier['numero']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Client',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dossier['client']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Objet',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dossier['objet']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dossier['montant']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Analyste',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: dossier['analyste']),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dossier modifié avec succès')),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showDossierMenu(BuildContext context, Map<String, String> dossier) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: const Text('Ajouter document'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document ajouté')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.check_circle),
            title: const Text('Valider le dossier'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dossier validé')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Télécharger rapport'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rapport téléchargé')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, dossier);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, String> dossier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${dossier['numero']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${dossier['numero']} supprimé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}

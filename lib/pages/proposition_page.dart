import 'package:flutter/material.dart';

class PropositionPage extends StatefulWidget {
  const PropositionPage({super.key});

  @override
  State<PropositionPage> createState() => _PropositionPageState();
}

class _PropositionPageState extends State<PropositionPage> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Propositions'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewPropositionDialog(context),
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
                  _buildStatusChip('Toutes', 'all'),
                  _buildStatusChip('Brouillon', 'draft'),
                  _buildStatusChip('Envoyées', 'sent'),
                  _buildStatusChip('Acceptées', 'accepted'),
                  _buildStatusChip('Refusées', 'rejected'),
                ],
              ),
            ),
          ),
          
          // Statistiques
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total', '24', Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('En attente', '8', Colors.orange),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Acceptées', '12', Colors.green),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Refusées', '4', Colors.red),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Liste des propositions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredPropositions().length,
              itemBuilder: (context, index) {
                final proposition = _getFilteredPropositions()[index];
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
                                proposition['numero']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildPropositionStatusChip(proposition['statut']!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          proposition['client']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          proposition['objet']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Créée le ${proposition['dateCreation']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            Text(
                              proposition['montant']!,
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
                                onPressed: () => _showPropositionDetails(context, proposition),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Voir'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showEditPropositionDialog(context, proposition),
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Modifier'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showPropositionMenu(context, proposition),
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
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropositionStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Brouillon':
        color = Colors.grey;
        break;
      case 'Envoyée':
        color = Colors.blue;
        break;
      case 'Acceptée':
        color = Colors.green;
        break;
      case 'Refusée':
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

  List<Map<String, String>> _getFilteredPropositions() {
    final propositions = [
      {
        'numero': 'PROP-2024-001',
        'client': 'ABC Corporation',
        'objet': 'Leasing véhicule BMW X3',
        'montant': '45 000 €',
        'statut': 'Envoyée',
        'dateCreation': '20/01/2024',
        'dateValidite': '20/02/2024',
      },
      {
        'numero': 'PROP-2024-002',
        'client': 'Tech Solutions SARL',
        'objet': 'Leasing équipement informatique',
        'montant': '12 500 €',
        'statut': 'Acceptée',
        'dateCreation': '18/01/2024',
        'dateValidite': '18/02/2024',
      },
      {
        'numero': 'PROP-2024-003',
        'client': 'Transport Plus',
        'objet': 'Leasing camionnette Ford Transit',
        'montant': '32 000 €',
        'statut': 'Brouillon',
        'dateCreation': '15/01/2024',
        'dateValidite': '15/02/2024',
      },
      {
        'numero': 'PROP-2024-004',
        'client': 'Entreprise Delta',
        'objet': 'Leasing photocopieur professionnel',
        'montant': '8 500 €',
        'statut': 'Refusée',
        'dateCreation': '12/01/2024',
        'dateValidite': '12/02/2024',
      },
      {
        'numero': 'PROP-2024-005',
        'client': 'Garage Central',
        'objet': 'Leasing équipement atelier',
        'montant': '25 000 €',
        'statut': 'Envoyée',
        'dateCreation': '10/01/2024',
        'dateValidite': '10/02/2024',
      },
    ];

    if (_selectedStatus == 'all') {
      return propositions;
    }

    String filterStatus;
    switch (_selectedStatus) {
      case 'draft':
        filterStatus = 'Brouillon';
        break;
      case 'sent':
        filterStatus = 'Envoyée';
        break;
      case 'accepted':
        filterStatus = 'Acceptée';
        break;
      case 'rejected':
        filterStatus = 'Refusée';
        break;
      default:
        return propositions;
    }

    return propositions.where((prop) => prop['statut'] == filterStatus).toList();
  }

  void _showPropositionDetails(BuildContext context, Map<String, String> proposition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(proposition['numero']!),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Client', proposition['client']!),
              _buildDetailRow('Objet', proposition['objet']!),
              _buildDetailRow('Montant', proposition['montant']!),
              _buildDetailRow('Statut', proposition['statut']!),
              _buildDetailRow('Date de création', proposition['dateCreation']!),
              _buildDetailRow('Validité', proposition['dateValidite']!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (proposition['statut'] == 'Brouillon')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditPropositionDialog(context, proposition);
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

  void _showNewPropositionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle proposition'),
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
                  labelText: 'Objet',
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
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
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
                const SnackBar(content: Text('Proposition créée avec succès')),
              );
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditPropositionDialog(BuildContext context, Map<String, String> proposition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${proposition['numero']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Client',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: proposition['client']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Objet',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: proposition['objet']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Montant',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: proposition['montant']),
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
                const SnackBar(content: Text('Proposition modifiée avec succès')),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showPropositionMenu(BuildContext context, Map<String, String> proposition) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.send),
            title: const Text('Envoyer'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proposition envoyée')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Dupliquer'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Proposition dupliquée')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Télécharger PDF'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PDF téléchargé')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, proposition);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, String> proposition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${proposition['numero']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${proposition['numero']} supprimée')),
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

import 'package:flutter/material.dart';

class BonCommandePage extends StatefulWidget {
  const BonCommandePage({super.key});

  @override
  State<BonCommandePage> createState() => _BonCommandePageState();
}

class _BonCommandePageState extends State<BonCommandePage> {
  String _selectedStatus = 'all';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bons de commande'),

        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showNewBonCommandeDialog(context),
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
                  _buildStatusChip('Brouillon', 'draft'),
                  _buildStatusChip('Envoyés', 'sent'),
                  _buildStatusChip('Confirmés', 'confirmed'),
                  _buildStatusChip('Livrés', 'delivered'),
                  _buildStatusChip('Annulés', 'cancelled'),
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
                _buildStatCard('Total', '32', Colors.blue),
                _buildStatCard('En cours', '12', Colors.orange),
                _buildStatCard('Confirmés', '15', Colors.green),
                _buildStatCard('Livrés', '5', Colors.purple),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Liste des bons de commande
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredBonsCommande().length,
              itemBuilder: (context, index) {
                final bon = _getFilteredBonsCommande()[index];
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
                                bon['numero']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildBonStatusChip(bon['statut']!),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bon['fournisseur']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bon['objet']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Informations détaillées
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Quantité',
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          bon['quantite']!,
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
                                          'Prix unitaire',
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          bon['prixUnitaire']!,
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'Total',
                                          style: TextStyle(fontSize: 12, color: Colors.grey),
                                        ),
                                        Text(
                                          bon['montantTotal']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'Créé le ${bon['dateCreation']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                            if (bon['dateLivraison'] != null) ...[
                              const SizedBox(width: 16),
                              Icon(Icons.local_shipping, size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                'Livraison: ${bon['dateLivraison']}',
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showBonDetails(context, bon),
                                icon: const Icon(Icons.visibility, size: 16),
                                label: const Text('Voir'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => _showEditBonDialog(context, bon),
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Modifier'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              onPressed: () => _showBonMenu(context, bon),
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

  Widget _buildBonStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Brouillon':
        color = Colors.grey;
        break;
      case 'Envoyé':
        color = Colors.blue;
        break;
      case 'Confirmé':
        color = Colors.green;
        break;
      case 'Livré':
        color = Colors.purple;
        break;
      case 'Annulé':
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

  List<Map<String, String?>> _getFilteredBonsCommande() {
    final bons = [
      {
        'numero': 'BC-2024-001',
        'fournisseur': 'XYZ Auto',
        'objet': 'BMW X3 2024 - Leasing client ABC',
        'quantite': '1',
        'prixUnitaire': '45 000 €',
        'montantTotal': '45 000 €',
        'statut': 'Confirmé',
        'dateCreation': '20/01/2024',
        'dateLivraison': '15/02/2024',
        'responsable': 'Marie Dupont',
      },
      {
        'numero': 'BC-2024-002',
        'fournisseur': 'Tech Solutions Pro',
        'objet': 'MacBook Pro 16" - Lot de 5',
        'quantite': '5',
        'prixUnitaire': '2 800 €',
        'montantTotal': '14 000 €',
        'statut': 'Livré',
        'dateCreation': '18/01/2024',
        'dateLivraison': '25/01/2024',
        'responsable': 'Jean Martin',
      },
      {
        'numero': 'BC-2024-003',
        'fournisseur': 'Garage Central',
        'objet': 'Ford Transit utilitaire',
        'quantite': '2',
        'prixUnitaire': '32 000 €',
        'montantTotal': '64 000 €',
        'statut': 'Brouillon',
        'dateCreation': '15/01/2024',
        'dateLivraison': null,
        'responsable': 'Sophie Bernard',
      },
      {
        'numero': 'BC-2024-004',
        'fournisseur': 'Bureau Plus',
        'objet': 'Photocopieur Canon multifonction',
        'quantite': '1',
        'prixUnitaire': '8 500 €',
        'montantTotal': '8 500 €',
        'statut': 'Envoyé',
        'dateCreation': '12/01/2024',
        'dateLivraison': '20/02/2024',
        'responsable': 'Pierre Durand',
      },
      {
        'numero': 'BC-2024-005',
        'fournisseur': 'Équipement Pro',
        'objet': 'Matériel atelier mécanique',
        'quantite': '1',
        'prixUnitaire': '25 000 €',
        'montantTotal': '25 000 €',
        'statut': 'Confirmé',
        'dateCreation': '10/01/2024',
        'dateLivraison': '28/02/2024',
        'responsable': 'Marie Dupont',
      },
      {
        'numero': 'BC-2024-006',
        'fournisseur': 'Auto Prestige',
        'objet': 'Mercedes Classe A - Annulé',
        'quantite': '1',
        'prixUnitaire': '35 000 €',
        'montantTotal': '35 000 €',
        'statut': 'Annulé',
        'dateCreation': '08/01/2024',
        'dateLivraison': null,
        'responsable': 'Jean Martin',
      },
    ];

    if (_selectedStatus == 'all') {
      return bons;
    }

    String filterStatus;
    switch (_selectedStatus) {
      case 'draft':
        filterStatus = 'Brouillon';
        break;
      case 'sent':
        filterStatus = 'Envoyé';
        break;
      case 'confirmed':
        filterStatus = 'Confirmé';
        break;
      case 'delivered':
        filterStatus = 'Livré';
        break;
      case 'cancelled':
        filterStatus = 'Annulé';
        break;
      default:
        return bons;
    }

    return bons.where((bon) => bon['statut'] == filterStatus).toList();
  }

  void _showBonDetails(BuildContext context, Map<String, String?> bon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(bon['numero']!),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Fournisseur', bon['fournisseur']!),
              _buildDetailRow('Objet', bon['objet']!),
              _buildDetailRow('Quantité', bon['quantite']!),
              _buildDetailRow('Prix unitaire', bon['prixUnitaire']!),
              _buildDetailRow('Montant total', bon['montantTotal']!),
              _buildDetailRow('Statut', bon['statut']!),
              _buildDetailRow('Date de création', bon['dateCreation']!),
              if (bon['dateLivraison'] != null)
                _buildDetailRow('Date de livraison', bon['dateLivraison']!),
              _buildDetailRow('Responsable', bon['responsable']!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          if (bon['statut'] == 'Brouillon')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBonDialog(context, bon);
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
            width: 120,
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

  void _showNewBonCommandeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau bon de commande'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Fournisseur',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Objet de la commande',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Quantité',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Prix unitaire (€)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Date de livraison souhaitée',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
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
                const SnackBar(content: Text('Bon de commande créé avec succès')),
              );
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  void _showEditBonDialog(BuildContext context, Map<String, String?> bon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${bon['numero']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Fournisseur',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: bon['fournisseur']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Objet',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: bon['objet']),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Quantité',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: bon['quantite']),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Prix unitaire',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: bon['prixUnitaire']),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()=> Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bon de commande modifié avec succès')),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showBonMenu(BuildContext context, Map<String, String?> bon) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (bon['statut'] == 'Brouillon')
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Envoyer au fournisseur'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bon de commande envoyé')),
                );
              },
            ),
          if (bon['statut'] == 'Envoyé')
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Marquer comme confirmé'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bon de commande confirmé')),
                );
              },
            ),
          if (bon['statut'] == 'Confirmé')
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Marquer comme livré'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bon de commande marqué comme livré')),
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.copy),
            title: const Text('Dupliquer'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bon de commande dupliqué')),
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
          if (bon['statut'] != 'Livré')
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Annuler'),
              onTap: () {
                Navigator.pop(context);
                _showCancelConfirmation(context, bon);
              },
            ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Supprimer'),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context, bon);
            },
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, Map<String, String?> bon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer l\'annulation'),
        content: Text('Êtes-vous sûr de vouloir annuler ${bon['numero']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${bon['numero']} annulé')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Annuler le bon'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, String?> bon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${bon['numero']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${bon['numero']} supprimé')),
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

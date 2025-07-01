import 'package:flutter/material.dart';

class TiersPage extends StatefulWidget {
  const TiersPage({super.key});

  @override
  State<TiersPage> createState() => _TiersPageState();
}

class _TiersPageState extends State<TiersPage> {
  String _selectedFilter = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des tiers'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTierDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche et filtres
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un tiers...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Tous', 'all'),
                      _buildFilterChip('Clients', 'clients'),
                      _buildFilterChip('Fournisseurs', 'fournisseurs'),
                      _buildFilterChip('Partenaires', 'partenaires'),
                      _buildFilterChip('Prospects', 'prospects'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Liste des tiers
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredTiers().length,
              itemBuilder: (context, index) {
                final tier = _getFilteredTiers()[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getTierColor(tier['type']!).withOpacity(0.1),
                      child: Icon(
                        _getTierIcon(tier['type']!),
                        color: _getTierColor(tier['type']!),
                      ),
                    ),
                    title: Text(
                      tier['nom']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tier['type']!),
                        Text(
                          tier['email']!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility),
                              SizedBox(width: 8),
                              Text('Voir'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit),
                              SizedBox(width: 8),
                              Text('Modifier'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Supprimer'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            _showTierDetails(context, tier);
                            break;
                          case 'edit':
                            _showEditTierDialog(context, tier);
                            break;
                          case 'delete':
                            _showDeleteConfirmation(context, tier);
                            break;
                        }
                      },
                    ),
                    onTap: () => _showTierDetails(context, tier),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
      ),
    );
  }

  List<Map<String, String>> _getFilteredTiers() {
    final tiers = [
      {'nom': 'ABC Corporation', 'type': 'Client', 'email': 'contact@abc-corp.fr', 'telephone': '01 23 45 67 89', 'adresse': '123 Rue de la Paix, Paris'},
      {'nom': 'XYZ Auto', 'type': 'Fournisseur', 'email': 'ventes@xyz-auto.fr', 'telephone': '01 98 76 54 32', 'adresse': '456 Avenue des Champs, Lyon'},
      {'nom': 'Tech Solutions SARL', 'type': 'Client', 'email': 'info@tech-solutions.fr', 'telephone': '01 11 22 33 44', 'adresse': '789 Boulevard Tech, Marseille'},
      {'nom': 'Assurance Pro', 'type': 'Partenaire', 'email': 'partenariat@assurance-pro.fr', 'telephone': '01 55 66 77 88', 'adresse': '321 Rue Assurance, Toulouse'},
      {'nom': 'Transport Plus', 'type': 'Client', 'email': 'admin@transport-plus.fr', 'telephone': '01 44 55 66 77', 'adresse': '654 Route Transport, Nice'},
      {'nom': 'Garage Central', 'type': 'Fournisseur', 'email': 'service@garage-central.fr', 'telephone': '01 33 44 55 66', 'adresse': '987 Avenue Garage, Nantes'},
      {'nom': 'Entreprise Delta', 'type': 'Prospect', 'email': 'contact@delta.fr', 'telephone': '01 22 33 44 55', 'adresse': '147 Rue Delta, Strasbourg'},
      {'nom': 'Banque Crédit', 'type': 'Partenaire', 'email': 'pro@banque-credit.fr', 'telephone': '01 66 77 88 99', 'adresse': '258 Place Banque, Bordeaux'},
    ];

    List<Map<String, String>> filtered = tiers;

    // Filtrer par type
    if (_selectedFilter != 'all') {
      String filterType;
      switch (_selectedFilter) {
        case 'clients':
          filterType = 'Client';
          break;
        case 'fournisseurs':
          filterType = 'Fournisseur';
          break;
        case 'partenaires':
          filterType = 'Partenaire';
          break;
        case 'prospects':
          filterType = 'Prospect';
          break;
        default:
          filterType = '';
      }
      filtered = filtered.where((tier) => tier['type'] == filterType).toList();
    }

    // Filtrer par recherche
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((tier) =>
        tier['nom']!.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        tier['email']!.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    return filtered;
  }

  Color _getTierColor(String type) {
    switch (type) {
      case 'Client':
        return Colors.blue;
      case 'Fournisseur':
        return Colors.green;
      case 'Partenaire':
        return Colors.purple;
      case 'Prospect':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTierIcon(String type) {
    switch (type) {
      case 'Client':
        return Icons.person;
      case 'Fournisseur':
        return Icons.business;
      case 'Partenaire':
        return Icons.handshake;
      case 'Prospect':
        return Icons.visibility;
      default:
        return Icons.help;
    }
  }

  void _showTierDetails(BuildContext context, Map<String, String> tier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tier['nom']!),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Type', tier['type']!),
            _buildDetailRow('Email', tier['email']!),
            _buildDetailRow('Téléphone', tier['telephone']!),
            _buildDetailRow('Adresse', tier['adresse']!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditTierDialog(context, tier);
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
            width: 80,
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

  void _showAddTierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter un tiers'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
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
                const SnackBar(content: Text('Tiers ajouté avec succès')),
              );
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  void _showEditTierDialog(BuildContext context, Map<String, String> tier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier ${tier['nom']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: tier['nom']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: tier['email']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: tier['telephone']),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Adresse',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: tier['adresse']),
                maxLines: 2,
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
                const SnackBar(content: Text('Tiers modifié avec succès')),
              );
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Map<String, String> tier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Êtes-vous sûr de vouloir supprimer ${tier['nom']} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${tier['nom']} supprimé avec succès')),
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

import 'package:flutter/material.dart';

class WorkflowPage extends StatefulWidget {
  const WorkflowPage({super.key});

  @override
  State<WorkflowPage> createState() => _WorkflowPageState();
}

class _WorkflowPageState extends State<WorkflowPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Workflow'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tâches'),
            Tab(text: 'Entités'),
            Tab(text: 'Kafka'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTachesPage(),
          _buildEntitesPage(),
          _buildKafkaPage(),
        ],
      ),
    );
  }

  Widget _buildTachesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Liste des tâches',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Filtres
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Statut',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Toutes')),
                    DropdownMenuItem(value: 'pending', child: Text('En attente')),
                    DropdownMenuItem(value: 'progress', child: Text('En cours')),
                    DropdownMenuItem(value: 'completed', child: Text('Terminées')),
                  ],
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Nouvelle tâche'),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Liste des tâches
          ...List.generate(10, (index) {
            final taches = [
              {'titre': 'Validation contrat LC-001', 'assignee': 'Marie Dupont', 'priorite': 'Haute', 'statut': 'En attente', 'date': '25/01/2024'},
              {'titre': 'Vérification documents client ABC', 'assignee': 'Jean Martin', 'priorite': 'Moyenne', 'statut': 'En cours', 'date': '24/01/2024'},
              {'titre': 'Approbation crédit entreprise XYZ', 'assignee': 'Sophie Bernard', 'priorite': 'Haute', 'statut': 'En attente', 'date': '23/01/2024'},
              {'titre': 'Mise à jour plan comptable', 'assignee': 'Pierre Durand', 'priorite': 'Basse', 'statut': 'Terminée', 'date': '22/01/2024'},
              {'titre': 'Génération rapport mensuel', 'assignee': 'Marie Dupont', 'priorite': 'Moyenne', 'statut': 'En cours', 'date': '21/01/2024'},
              {'titre': 'Relance client impayé', 'assignee': 'Jean Martin', 'priorite': 'Haute', 'statut': 'En attente', 'date': '20/01/2024'},
              {'titre': 'Archivage contrats terminés', 'assignee': 'Sophie Bernard', 'priorite': 'Basse', 'statut': 'En cours', 'date': '19/01/2024'},
              {'titre': 'Formation nouveau logiciel', 'assignee': 'Pierre Durand', 'priorite': 'Moyenne', 'statut': 'Terminée', 'date': '18/01/2024'},
              {'titre': 'Audit sécurité système', 'assignee': 'Marie Dupont', 'priorite': 'Haute', 'statut': 'En attente', 'date': '17/01/2024'},
              {'titre': 'Optimisation base de données', 'assignee': 'Jean Martin', 'priorite': 'Moyenne', 'statut': 'En cours', 'date': '16/01/2024'},
            ];
            
            if (index < taches.length) {
              final tache = taches[index];
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
                              tache['titre']!,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildPriorityChip(tache['priorite']!),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.person, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(tache['assignee']!, style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 16),
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(tache['date']!, style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusChip(tache['statut']!),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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

  Widget _buildEntitesPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suivi des entités',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Statistiques des entités
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildEntityCard('Clients actifs', '156', Icons.people, Colors.green),
              _buildEntityCard('Contrats', '89', Icons.description, Colors.blue),
              _buildEntityCard('Fournisseurs', '23', Icons.business, Colors.orange),
              _buildEntityCard('Partenaires', '12', Icons.handshake, Colors.purple),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Liste des entités récentes
          const Text(
            'Activité récente des entités',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(8, (index) {
            final activites = [
              {'entite': 'Client ABC Corp', 'action': 'Nouveau contrat créé', 'date': '25/01/2024 14:30', 'type': 'client'},
              {'entite': 'Fournisseur XYZ Auto', 'action': 'Facture reçue', 'date': '25/01/2024 11:15', 'type': 'fournisseur'},
              {'entite': 'Client Tech Solutions', 'action': 'Paiement effectué', 'date': '24/01/2024 16:45', 'type': 'client'},
              {'entite': 'Partenaire Assurance Pro', 'action': 'Contrat renouvelé', 'date': '24/01/2024 09:20', 'type': 'partenaire'},
              {'entite': 'Client SARL Transport', 'action': 'Modification adresse', 'date': '23/01/2024 13:10', 'type': 'client'},
              {'entite': 'Fournisseur Garage Central', 'action': 'Nouveau devis', 'date': '23/01/2024 10:30', 'type': 'fournisseur'},
              {'entite': 'Client Entreprise Delta', 'action': 'Demande d\'information', 'date': '22/01/2024 15:20', 'type': 'client'},
              {'entite': 'Partenaire Banque Crédit', 'action': 'Validation financement', 'date': '22/01/2024 08:45', 'type': 'partenaire'},
            ];
            
            if (index < activites.length) {
              final activite = activites[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getEntityColor(activite['type']!).withOpacity(0.1),
                    child: Icon(_getEntityIcon(activite['type']!), color: _getEntityColor(activite['type']!)),
                  ),
                  title: Text(activite['entite']!),
                  subtitle: Text(activite['action']!),
                  trailing: Text(
                    activite['date']!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _buildKafkaPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Suivi des traitements Kafka',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Statut des services
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statut des services',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceStatus('Kafka Broker', true),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildServiceStatus('Zookeeper', true),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildServiceStatus('Schema Registry', true),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildServiceStatus('Connect', false),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Topics et messages
          const Text(
            'Topics actifs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(6, (index) {
            final topics = [
              {'nom': 'contrats-events', 'messages': '1,234', 'partitions': '3', 'statut': 'Actif'},
              {'nom': 'paiements-events', 'messages': '856', 'partitions': '2', 'statut': 'Actif'},
              {'nom': 'clients-events', 'messages': '2,145', 'partitions': '4', 'statut': 'Actif'},
              {'nom': 'notifications-events', 'messages': '567', 'partitions': '2', 'statut': 'Actif'},
              {'nom': 'audit-events', 'messages': '3,421', 'partitions': '6', 'statut': 'Actif'},
              {'nom': 'errors-events', 'messages': '23', 'partitions': '1', 'statut': 'Attention'},
            ];
            
            if (index < topics.length) {
              final topic = topics[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: topic['statut'] == 'Actif' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    child: Icon(
                      Icons.topic,
                      color: topic['statut'] == 'Actif' ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(topic['nom']!),
                  subtitle: Text('${topic['messages']} messages • ${topic['partitions']} partitions'),
                  trailing: Chip(
                    label: Text(topic['statut']!),
                    backgroundColor: topic['statut'] == 'Actif' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          
          const SizedBox(height: 24),
          
          // Messages récents
          const Text(
            'Messages récents',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          ...List.generate(5, (index) {
            final messages = [
              {'topic': 'contrats-events', 'message': 'Nouveau contrat LC-001 créé', 'timestamp': '2024-01-25 14:30:15'},
              {'topic': 'paiements-events', 'message': 'Paiement reçu pour facture F-2024-001', 'timestamp': '2024-01-25 14:25:42'},
              {'topic': 'clients-events', 'message': 'Client ABC Corp mis à jour', 'timestamp': '2024-01-25 14:20:18'},
              {'topic': 'notifications-events', 'message': 'Email de rappel envoyé', 'timestamp': '2024-01-25 14:15:33'},
              {'topic': 'audit-events', 'message': 'Connexion utilisateur marie.dupont', 'timestamp': '2024-01-25 14:10:07'},
            ];
            
            if (index < messages.length) {
              final message = messages[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(message['topic']!),
                            backgroundColor: Colors.blue.withOpacity(0.1),
                          ),
                          const Spacer(),
                          Text(
                            message['timestamp']!,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(message['message']!),
                    ],
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

  Widget _buildPriorityChip(String priority) {
    Color color;
    switch (priority) {
      case 'Haute':
        color = Colors.red;
        break;
      case 'Moyenne':
        color = Colors.orange;
        break;
      case 'Basse':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }
    
    return Chip(
      label: Text(priority),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 12),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'En attente':
        color = Colors.orange;
        break;
      case 'En cours':
        color = Colors.blue;
        break;
      case 'Terminée':
        color = Colors.green;
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

  Widget _buildEntityCard(String title, String value, IconData icon, Color color) {
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
                fontSize: 24,
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

  Color _getEntityColor(String type) {
    switch (type) {
      case 'client':
        return Colors.blue;
      case 'fournisseur':
        return Colors.green;
      case 'partenaire':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getEntityIcon(String type) {
    switch (type) {
      case 'client':
        return Icons.person;
      case 'fournisseur':
        return Icons.business;
      case 'partenaire':
        return Icons.handshake;
      default:
        return Icons.help;
    }
  }

  Widget _buildServiceStatus(String service, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.error,
            color: isActive ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              service,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

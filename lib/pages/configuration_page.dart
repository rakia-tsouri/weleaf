import 'package:flutter/material.dart';

class ConfigurationPage extends StatelessWidget {
  const ConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Configuration système',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Paramètres généraux
            _buildConfigSection(
              'Paramètres généraux',
              Icons.settings,
              [
                _buildConfigItem('Nom de l\'entreprise', 'MG Leasing SARL', Icons.business),
                _buildConfigItem('Adresse', '123 Rue de la Paix, 75001 Paris', Icons.location_on),
                _buildConfigItem('Téléphone', '+33 1 23 45 67 89', Icons.phone),
                _buildConfigItem('Email', 'contact@mg-leasing.fr', Icons.email),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Paramètres financiers
            _buildConfigSection(
              'Paramètres financiers',
              Icons.monetization_on,
              [
                _buildConfigItem('Taux d\'intérêt par défaut', '4.5%', Icons.percent),
                _buildConfigItem('Devise', 'EUR (€)', Icons.euro),
                _buildConfigItem('TVA par défaut', '20%', Icons.receipt),
                _buildConfigItem('Exercice fiscal', '2024', Icons.calendar_today),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Paramètres utilisateurs
            _buildConfigSection(
              'Gestion des utilisateurs',
              Icons.people,
              [
                _buildConfigItem('Utilisateurs actifs', '12', Icons.person),
                _buildConfigItem('Rôles configurés', '5', Icons.security),
                _buildConfigItem('Sessions actives', '8', Icons.login),
                _buildConfigItem('Dernière sauvegarde', '25/01/2024 14:30', Icons.backup),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Paramètres système
            _buildConfigSection(
              'Paramètres système',
              Icons.computer,
              [
                _buildConfigItem('Version', '2.1.4', Icons.info),
                _buildConfigItem('Base de données', 'PostgreSQL 14.2', Icons.storage),
                _buildConfigItem('Serveur', 'Ubuntu 22.04 LTS', Icons.dns),
                _buildConfigItem('Dernière mise à jour', '20/01/2024', Icons.update),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Actions de configuration
            const Text(
              'Actions de configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionCard(
                  'Sauvegarder',
                  'Créer une sauvegarde',
                  Icons.backup,
                  Colors.green,
                  () {},
                ),
                _buildActionCard(
                  'Restaurer',
                  'Restaurer depuis sauvegarde',
                  Icons.restore,
                  Colors.blue,
                  () {},
                ),
                _buildActionCard(
                  'Logs système',
                  'Consulter les journaux',
                  Icons.list_alt,
                  Colors.orange,
                  () {},
                ),
                _buildActionCard(
                  'Maintenance',
                  'Mode maintenance',
                  Icons.build,
                  Colors.red,
                  () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigSection(String title, IconData icon, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildConfigItem(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            value,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(width: 8),
          Icon(Icons.edit, size: 16, color: Colors.grey[400]),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

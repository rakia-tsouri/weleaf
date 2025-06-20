import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bienvenue_page.dart';
import 'tableau_bord_page.dart';
import 'workflow_page.dart';
import 'configuration_page.dart';
import 'tiers_page.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen.dart';
import 'dossier_etude_page.dart';
import 'bon_commande_page.dart';

import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:optorg_mobile/utils/shared_prefs.dart';
import 'package:optorg_mobile/widgets/app_dialog.dart';
import 'package:optorg_mobile/widgets/custom_popup_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BienvenuePage(),
    const TableauBordPage(),
    const WorkflowPage(),
    const ConfigurationPage(),
    const TiersPage(),
    const ProposalsListScreen(),
    const DossierEtudePage(),
    const BonCommandePage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.home, label: 'Bienvenue', color: Colors.blue),
    NavigationItem(icon: Icons.dashboard, label: 'Tableau de bord', color: Colors.green),
    NavigationItem(icon: Icons.work, label: 'Workflow', color: Colors.orange),
    NavigationItem(icon: Icons.settings, label: 'Configuration', color: Colors.purple),
    NavigationItem(icon: Icons.people, label: 'Tiers', color: Colors.teal),
    NavigationItem(icon: Icons.description, label: 'Proposition', color: Colors.indigo),
    NavigationItem(icon: Icons.folder, label: 'Dossier d\'étude', color: Colors.red),
    NavigationItem(icon: Icons.shopping_cart, label: 'Bon de commande', color: Colors.brown),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/header_appbar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: SvgPicture.asset(
            'assets/images/logo_utina.svg',
            height: 40,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {},
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF003D70)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.business, size: 30, color: Color(0xFF061532)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'MG Leasing',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Système de gestion',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ...List.generate(_navigationItems.length, (index) {
              final item = _navigationItems[index];
              return ListTile(
                leading: Icon(item.icon, color: _selectedIndex == index ? item.color : Colors.grey),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: _selectedIndex == index ? item.color : Colors.black87,
                    fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                selected: _selectedIndex == index,
                selectedTileColor: item.color.withOpacity(0.1),
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                  Navigator.pop(context);
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context); // Fermer le Drawer
                _onLogoutClick(); // Afficher la confirmation
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex < 4 ? _selectedIndex : 0,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF0A235F),
        unselectedItemColor: Colors.grey,
        items: _navigationItems.take(4).map((item) {
          return BottomNavigationBarItem(icon: Icon(item.icon), label: item.label);
        }).toList(),
      ),
    );
  }

  void _onLogoutClick() {
    CustomPopupBottomSheet.showBottomSheet(
      context,
      CustomPopupBottomSheet(
        popupContent: AppDialog.twoButtonsDialog(
          background: Colors.white,
          title: 'OPTORG',
          description: "Êtes-vous sûr de vouloir vous déconnecter ?",
          buttonText: "Se déconnecter",
          onClickHandler: () {
            AppDataStore().clearAppData().then((value) async {
              await SharedPrefs.clear();
              Navigator.of(context).pushNamedAndRemoveUntil(
                ROUTE_TO_LOGIN_SCREEN,
                    (route) => false,
                arguments: ROUTE_TO_LOGIN_SCREEN,
              );
            });
          },
          onCancelClickHandler: () {
            Navigator.pop(context);
          },
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  NavigationItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}


import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:optorg_mobile/pages/proposition_page.dart';
import 'bienvenue_page.dart';
import 'package:optorg_mobile/constants/routes.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:optorg_mobile/utils/shared_prefs.dart';
import 'package:optorg_mobile/widgets/app_dialog.dart';
import 'package:optorg_mobile/widgets/custom_popup_bottom_sheet.dart';
import 'catalogue_page.dart';
import 'listContrats.dart';
import 'FacturesPayees.dart';
import 'FacturesImpayees.dart';
import 'calculatrice.dart';
import 'package:optorg_mobile/pages/profil.dart';
import 'package:optorg_mobile/pages/Notiflist.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BienvenuePage(),
    const CatalogPage(),
    const ProposalsPage(),
    const ListContratsPage(),  // Page corrigée
    FacturesPage(),
    CalculatricePage(),
  ];

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.home, label: 'Acceuil', color: Colors.blue),
    NavigationItem(icon: Icons.grid_view, label: 'Catalogue', color: Colors.indigo),
    NavigationItem(icon: Icons.description, label: 'Propositions', color: Colors.indigo),
    NavigationItem(icon: Icons.assignment, label: 'Contrats', color: Colors.indigo),
    NavigationItem(icon: Icons.receipt_long, label: 'Factures', color: Colors.indigo),
    NavigationItem(icon: Icons.calculate, label: 'Calculatrice', color: Colors.indigo),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
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
              decoration: BoxDecoration(color:Color(0xFF2563EB)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 10),
                  Text(
                    'Weleaf',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Votre partenaire de leasing',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                ],
              ),
            ),
            ...List.generate(_navigationItems.length, (index) {
              final item = _navigationItems[index];
              return ListTile(
                leading: Icon(item.icon, color: _selectedIndex == index ? item.color : Colors.grey[500]),
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 18,
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

class FacturesPage extends StatelessWidget {
  const FacturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 10, // Optimal height for larger tabs
          titleSpacing: 0,
          bottom: TabBar(
            labelStyle: TextStyle(
              fontSize: 18, // Increased from default 14
              fontWeight: FontWeight.w500,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 18, // Same size for both states
              fontWeight: FontWeight.w500,
            ),
            labelColor: const Color(0xFF2563EB),
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: const Color(0xFF2563EB),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Payées'),
              Tab(text: 'Impayées'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FacturesPayeesPage(),
            FacturesImpayeesPage(),
          ],
        ),
      ),
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


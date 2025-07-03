import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'bienvenue_page.dart';
import 'package:optorg_mobile/views/proposals_list_screen/proposals_list_screen.dart';
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
    const ProposalsListScreen(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2563EB),
        title: Text('Factures', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacturesPayeesPage()),
                );
              },
              child: Text('Factures Payées'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacturesImpayeesPage(),
                  ),
                );
              },
              child: Text('Factures Impayées'),
            ),
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


import 'package:flutter/material.dart';
import 'simulateur.dart';
import 'attributsForm.dart';

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16, top: 8, bottom: 8),
    );
  }
}

class PropositionsPage extends StatefulWidget {
  const PropositionsPage({Key? key}) : super(key: key);

  @override
  _PropositionsPageState createState() => _PropositionsPageState();
}

class _PropositionsPageState extends State<PropositionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _saveForm() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _tabController.index == 0
              ? 'Simulateur sauvegardé avec succès'
              : 'Attributs de facturation sauvegardés avec succès',
        ),
        backgroundColor: Colors.green,
      ),
    );
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
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: SizedBox.shrink(),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF2563EB),
              unselectedLabelColor: Colors.black87,
              indicatorColor: Color(0xFF2563EB),
              tabs: [
                Tab(text: 'Simulateur Rapide'),
                Tab(text: 'Attributs de Facturation'),
              ],
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [SaveButton(onPressed: _saveForm)],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SimulateurForm(),
          AttributsDisplay(),
        ],
      ),
    );
  }
}
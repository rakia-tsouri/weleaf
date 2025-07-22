import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/data/repositories/facture_repository.dart';
import 'package:optorg_mobile/pages/FacturesImpayees.dart';
import 'package:optorg_mobile/pages/FacturesPayees.dart';

class FacturesPage extends StatefulWidget {
  final FactureRepository factureRepository;

  const FacturesPage({
    super.key,
    required this.factureRepository,
  });

  @override
  State<FacturesPage> createState() => _FacturesPageState();
}

class _FacturesPageState extends State<FacturesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Facture>> _facturesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _facturesFuture = widget.factureRepository.fetchFactures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Factures'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Impayées'),
            Tab(text: 'Payées'),
          ],
        ),
      ),
      body: FutureBuilder<List<Facture>>(
        future: _facturesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final allFactures = snapshot.data ?? [];
          final impayees = widget.factureRepository.filterFacturesImpayees(allFactures);
          final payees = widget.factureRepository.filterFacturesPayees(allFactures);

          return TabBarView(
            controller: _tabController,
            children: [
              FacturesImpayeesPage(factures: impayees),
              FacturesPayeesPage(factures: payees),
            ],
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/repositories/contract_repository.dart';
import 'package:optorg_mobile/data/models/contract.dart';
import 'package:optorg_mobile/widgets/CatalogueCarousel.dart';
import 'package:optorg_mobile/data/repositories/facture_repository.dart';
import 'package:optorg_mobile/data/models/facture_model.dart';

class NosProduitsEtStats extends StatefulWidget {
  const NosProduitsEtStats({Key? key}) : super(key: key);

  @override
  _NosProduitsEtStatsState createState() => _NosProduitsEtStatsState();
}

class _NosProduitsEtStatsState extends State<NosProduitsEtStats> {
  final ContractRepository _contractRepository = ContractRepository();
  final FactureRepository _factureRepository = FactureRepository();

  int _activeContractsCount = 0;
  int _pendingInvoicesCount = 0;
  double _pendingInvoicesDueAmount = 0.0;
  double _pendingInvoicesGrossTotal = 0.0; // NEW: For "Montant total" (cigrosstotal)
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _contractRepository.fetchContracts(),
        _factureRepository.fetchFactures(),
      ]);

      final contracts = results[0] as List<Contract>;
      final factures = results[1] as List<Facture>;

      // 👉 Montant total (toutes les factures sauf INPROG)
      double totalGrossAmount = factures
          .where((f) => f.cistatus != 'INPROG')
          .fold(0.0, (sum, facture) => sum + (facture.cigrosstotal ?? 0.0));

      // 👉 Factures en attente (VALID)
      final validFactures = factures.where((f) => f.cistatus == 'VALID').toList();

      // 👉 Impayés (somme des cidueamount pour VALID uniquement)
      double totalDueAmount = validFactures.fold(0.0, (sum, facture) {
        return sum + (facture.cidueamount ?? 0.0);
      });

      setState(() {
        _activeContractsCount = contracts.length;
        _pendingInvoicesCount = validFactures.length;
        _pendingInvoicesGrossTotal = totalGrossAmount; // ✅ toutes sauf INPROG
        _pendingInvoicesDueAmount = totalDueAmount;    // ✅ impayés (VALID)
        _isLoading = false;
      });

      debugPrint('Montant total (sauf INPROG): ${totalGrossAmount.toStringAsFixed(2)} €');
      debugPrint('Montant impayé (VALID): ${totalDueAmount.toStringAsFixed(2)} €');
      debugPrint('Factures en attente (VALID): ${validFactures.length}');
    } catch (e) {
      debugPrint('Error loading data: $e');
      setState(() {
        _isLoading = false;
        _pendingInvoicesGrossTotal = 0.0;
        _pendingInvoicesDueAmount = 0.0;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CatalogueCarousel(),
        const SizedBox(height: 32),
        const Text(
          'Aperçu rapide',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.7,
          children: [
            _buildStatCard(
              'Contrats actifs',
              _isLoading ? '' : _activeContractsCount.toString(),
              Icons.description,
              Colors.green,
            ),
            _buildStatCard(
              'Factures en attente',
              _isLoading ? '' : _pendingInvoicesCount.toString(),
              Icons.receipt,
              Colors.orange,
            ),
            _buildStatCard(
              'Montant total',
              _isLoading ? '' : '${_pendingInvoicesGrossTotal.toStringAsFixed(2)} €',
              Icons.euro,
              Colors.blue,
            ),
            _buildStatCard(
              'Impayés',
              _isLoading ? '' : '${_pendingInvoicesDueAmount.toStringAsFixed(2)} €',
              Icons.warning,
              Colors.red,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 26, color: color),
                const SizedBox(width: 8),
                // Use Expanded with FittedBox to scale down the value text if it's too long
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown, // Scales down the child to fit
                    alignment: Alignment.centerLeft, // Aligns the scaled text to the left
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22, // Keep original font size, FittedBox will scale if needed
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      // Removed overflow: TextOverflow.ellipsis and maxLines: 1
                      // FittedBox handles the fitting without truncation
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Keep the font size for the title as you liked this fix
            Text(
              title,
              style: TextStyle(
                fontSize: 13, // Reduced from 14 to 13 to prevent vertical overflow
                color: Colors.grey[700],
              ),
              maxLines: 2, // Allow up to two lines for the title
              overflow: TextOverflow.ellipsis, // Add ellipsis if it still overflows
            ),
          ],
        ),
      ),
    );
  }
}
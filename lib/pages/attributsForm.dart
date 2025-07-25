import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AttributsDisplay extends StatefulWidget {
  final VoidCallback? onBack;
  const AttributsDisplay({Key? key, this.onBack}) : super(key: key);

  @override
  State<AttributsDisplay> createState() => _AttributsDisplayState();
}

class _AttributsDisplayState extends State<AttributsDisplay> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<bool> _isExpanded = [true, true];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Données fictives pour l'affichage
    final financementData = {
      'Mode de Paiement': 'Virement',
      'IBAN / RIB': 'FR76 3000 1007 1600 0000 0000 123',
      'BIC': 'BNPAFRPPXXX',
      'Nom de la Banque': 'BNP Paribas',
      'Délai de Paiement': '30 jours',
    };

    final facturationData = {
      'Mode de Facturation': 'Électronique',
      "Mode d'Envoi des Factures": 'Email',
      'Destinataire': 'Service Comptabilité',
      'Adresse': '12 Rue de la Paix',
      'Adresse Complémentaire': 'Bâtiment B, 2ème étage',
      'Code Postal': '75001',
      'Ville': 'Paris',
      'Région': 'Île-de-France',
      'Région Globale': 'ILE',
      'Pays': 'FR-FRANCE',
    };

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Opacity(
              opacity: _animationController.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - _animationController.value)),
                child: child,
              ),
            );
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection(
                title: 'Éléments de Financement',
                icon: Icons.account_balance_rounded,
                data: financementData,
                isExpanded: _isExpanded[0],
                onToggle: () => setState(() => _isExpanded[0] = !_isExpanded[0]),
                index: 0,
              ),
              const SizedBox(height: 16),
              _buildSection(
                title: 'Adresse de Facturation',
                icon: Icons.receipt_long_rounded,
                data: facturationData,
                isExpanded: _isExpanded[1],
                onToggle: () => setState(() => _isExpanded[1] = !_isExpanded[1]),
                index: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Map<String, String> data,
    required bool isExpanded,
    required VoidCallback onToggle,
    required int index,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2A3256).withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A6FFF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: const Color(0xFF4A6FFF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A3256),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF4A6FFF),
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: Container(),
            secondChild: Column(
              children: [
                const Divider(height: 1, thickness: 1, color: Color(0xFFEEF0F6)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: data.entries.map((entry) {
                      return _buildDataRow(entry.key, entry.value);
                    }).toList(),
                  ),
                ),
              ],
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    final bool isCopyable = label.contains('IBAN') ||
        label.contains('BIC') ||
        label.contains('Adresse');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A3256),
                      height: 1.5,
                    ),
                  ),
                ),
                if (isCopyable)
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copié: $value'),
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: Color(0xFF4A6FFF),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

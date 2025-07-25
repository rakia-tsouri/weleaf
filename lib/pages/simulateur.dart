import 'package:flutter/material.dart';
import 'package:optorg_mobile/data/models/calendar.dart';
import 'package:optorg_mobile/data/repositories/calendar_repository.dart';
import 'package:optorg_mobile/data/repositories/product_repository.dart';

class SimulateurForm extends StatefulWidget {
  @override
  _SimulateurFormState createState() => _SimulateurFormState();
}

class _SimulateurFormState extends State<SimulateurForm> with TickerProviderStateMixin {
  List<calendar> _calendars = [];
  int? _selectedCalendarId;
  bool _isLoading = false;
  late BuildContext _context;
  List<Map<String, dynamic>> _products = [];
  String? _selectedProduct;
  final ProductRepository _productRepository = ProductRepository();
  final CalendarRepository _calendarRepository = CalendarRepository();

  late AnimationController _animationController;
  late AnimationController _loadingController;
  final TextEditingController _commentsController = TextEditingController();
  bool _isDatesExpanded = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _loadProducts();
    _loadCalendars();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loadingController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    _loadingController.repeat();

    try {
      final products = await _productRepository.fetchProducts();
      setState(() {
        _products = products;
        if (products.isNotEmpty) {
          _selectedProduct = products.first['prlabel']?.trim();
        }
      });
    } catch (e) {
      _showErrorSnackBar('Erreur de chargement des produits: $e');
    } finally {
      setState(() => _isLoading = false);
      _loadingController.stop();
    }
  }

  Future<void> _loadCalendars() async {
    setState(() => _isLoading = true);
    try {
      final calendars = await _calendarRepository.fetchCalendars();
      setState(() {
        _calendars = calendars;
        _selectedCalendarId = calendars.isNotEmpty ? calendars.first.calid : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Erreur de chargement des calendriers: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE53E3E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _animationController.value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - _animationController.value)),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: _buildProduitSection()),
                          const SizedBox(width: 20),
                          Expanded(flex: 2, child: _buildStatutSection()),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        _buildProduitSection(),
                        const SizedBox(height: 20),
                        _buildStatutSection(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              _buildCommentsSection(),
              const SizedBox(height: 32),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.calculate_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Simulateur Financier',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Configurez votre simulation financière',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProduitSection() {
    return _buildModernCard(
      title: 'Informations Produit',
      icon: Icons.inventory_2_rounded,
      iconColor: const Color(0xFF059669),
      child: Column(
        children: [
          _buildModernFormField('Référence', isTextField: true),
          const SizedBox(height: 16),
          _buildProductDropdown(),
          const SizedBox(height: 16),
          _buildModernFormField(
            'Type de Montage',
            items: ['Élément financier unique', 'Autre'],
            hint: 'Élément financier unique',
          ),
          const SizedBox(height: 16),
          _buildModernFormField('Devise', items: ['EUR'], hint: 'EUR'),
          const SizedBox(height: 16),
          _buildModernFormField(
            'Montant financé',
            isTextField: true,
            hint: 'MAD 0.00',
            prefixIcon: Icons.euro_rounded,
          ),
          const SizedBox(height: 16),
          _buildModernFormField(
            'Type de Contrat',
            items: ['Seule', 'Autre'],
            hint: 'Seule',
          ),
        ],
      ),
    );
  }

  Widget _buildStatutSection() {
    return _buildModernCard(
      title: 'Statut & Calendrier',
      icon: Icons.event_available_rounded,
      iconColor: const Color(0xFF4F46E5),
      child: Column(
        children: [
          _buildCalendarDropdown(),
          const SizedBox(height: 16),
          _buildModernFormField('Statut', isTextField: true),
          const SizedBox(height: 16),
          _buildModernFormField(
            'Date de la Demande',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),
          const SizedBox(height: 16),
          _buildModernFormField(
            'Date Début Initiale',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),
          const SizedBox(height: 16),
          _buildModernFormField('Durée', isTextField: true, hint: 'Durée en mois'),
          const SizedBox(height: 20),
          _buildDatesSection(),
        ],
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: iconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildModernFormField(
      String label, {
        bool isTextField = false,
        List<String>? items,
        String? hint,
        bool isDate = false,
        IconData? prefixIcon,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isTextField
              ? TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 3),
              ),
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              contentPadding: const EdgeInsets.all(16),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: const Color(0xFF6B7280), size: 20)
                  : null,
              suffixIcon: isDate
                  ? const Icon(Icons.calendar_today_rounded,
                  color: Color(0xFF6B7280), size: 20)
                  : null,
            ),
          )
              : DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            hint: Text(
              hint ?? label,
              style: const TextStyle(color: Color(0xFF9CA3AF)),
            ),
            items: items?.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {},
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Produit',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _isLoading
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF4F46E5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Chargement des produits...',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          )
              : _products.isEmpty
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                SizedBox(width: 8),
                Text(
                  'Aucun produit disponible',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
              ],
            ),
          )
              : DropdownButtonFormField<String>(
            value: _selectedProduct,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            items: _products.map((product) {
              final label = product['prlabel']?.trim() ?? 'Produit sans nom';
              return DropdownMenuItem<String>(
                value: label,
                child: Text(label),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedProduct = value);
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Calendrier',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _isLoading
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF4F46E5),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Chargement des calendriers...',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          )
              : _calendars.isEmpty
              ? Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, color: Color(0xFFDC2626), size: 20),
                SizedBox(width: 8),
                Text(
                  'Aucun calendrier disponible',
                  style: TextStyle(color: Color(0xFFDC2626)),
                ),
              ],
            ),
          )
              : DropdownButtonFormField<int>(
            value: _selectedCalendarId,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
            hint: const Text(
              'Sélectionnez un calendrier',
              style: TextStyle(color: Color(0xFF9CA3AF)),
            ),
            items: _calendars.map((calendar) {
              return DropdownMenuItem<int>(
                value: calendar.calid,
                child: Text(
                  '${calendar.callabel}${calendar.countcode.isNotEmpty ? ' (${calendar.countcode})' : ''}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => _selectedCalendarId = value);
            },
            validator: (value) {
              if (value == null) {
                return 'Veuillez sélectionner un calendrier';
              }
              return null;
            },
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6B7280)),
          ),
        ),
      ],
    );
  }

  Widget _buildDatesSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4F46E5).withOpacity(0.05),
            const Color(0xFF7C3AED).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4F46E5).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isDatesExpanded = !_isDatesExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.date_range_rounded,
                      color: Color(0xFF4F46E5),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Dates Importantes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isDatesExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date Initiale'),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date de Validité'),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date de Fin'),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date de décision'),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date de signature'),
                  const SizedBox(height: 12),
                  _buildCompactDateField('Date d\'Activation'),
                ],
              ),
            ),
            crossFadeState: _isDatesExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactDateField(String label) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              suffixIcon: const Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.comment_rounded,
                    color: Color(0xFFF59E0B),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Commentaires',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _commentsController,
              maxLines: 2,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 2),
                ),
                hintText: 'Ajoutez vos commentaires ici...',
                hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Action pour sauvegarder
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6B7280),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Sauvegarder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4F46E5).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Action pour simuler
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Simuler',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/data/models/calendar.dart';
import 'package:optorg_mobile/data/repositories/calendar_repository.dart';
import 'package:optorg_mobile/data/repositories/product_repository.dart';

class SimulateurForm extends StatefulWidget {
  @override
  _SimulateurFormState createState() => _SimulateurFormState();
}

class _SimulateurFormState extends State<SimulateurForm> {
  List<calendar> _calendars = [];
  int? _selectedCalendarId;
  bool _isLoading = false;
  late BuildContext _context;

  List<Map<String, dynamic>> _products = [];
  String? _selectedProduct;
  final ProductRepository _productRepository = ProductRepository();
  final CalendarRepository _calendarRepository = CalendarRepository();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCalendars();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productRepository.fetchProducts();
      setState(() {
        _products = products;
        if (products.isNotEmpty) {
          // Sélectionner le premier produit par défaut
          _selectedProduct = products.first['prlabel']?.trim();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de chargement des produits: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
      ScaffoldMessenger.of(_context).showSnackBar(
        SnackBar(
          content: Text('Erreur de chargement des calendriers: $e'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _buildProduitSection()),
                      SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildStatutSection()),
                    ],
                  ),
                );
              } else {
                return Column(
                  children: [
                    _buildProduitSection(),
                    SizedBox(height: 16),
                    _buildStatutSection(),
                  ],
                );
              }
            },
          ),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commentaires',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Commentaires',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildProduitSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2, color: Color(0xFF2563EB), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Produit',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildFormField('Réf', isTextField: true),
          SizedBox(height: 12),
          _buildProductDropdown(),
          SizedBox(height: 12),
          _buildFormField(
            'Type de Montage',
            items: ['Élément financier unique', 'Autre'],
            hint: 'Élément financier unique',
          ),
          SizedBox(height: 12),
          _buildFormField('Devise', items: ['EUR'], hint: 'Devise'),
          SizedBox(height: 12),
          _buildFormField(
            'Montant financé',
            isTextField: true,
            hint: 'MAD 0.00',
          ),
          SizedBox(height: 12),
          _buildFormField(
            'Type de Contrat',
            items: ['Seule', 'Autre'],
            hint: 'Seule',
          ),
          SizedBox(height: 16),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Produit',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        if (_isLoading)
          CircularProgressIndicator()
        else if (_products.isEmpty)
          Text('Aucun produit disponible', style: TextStyle(color: Colors.red))
        else
          DropdownButtonFormField<String>(
            value: _selectedProduct,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
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
          ),
      ],
    );
  }

  Widget _buildStatutSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Statut',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Calendrier',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                )
              else if (_calendars.isEmpty)
                Text(
                  'Aucun calendrier disponible',
                  style: TextStyle(color: Colors.red[700]),
                )
              else
                DropdownButtonFormField<int>(
                  value: _selectedCalendarId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey[400]!),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  hint: Text(
                    'Sélectionnez un calendrier',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: _calendars.map((calendar) {
                    return DropdownMenuItem<int>(
                      value: calendar.calid,
                      child: Text(
                        '${calendar.callabel}${calendar.countcode.isNotEmpty ? ' (${calendar.countcode})' : ''}',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCalendarId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Veuillez sélectionner un calendrier';
                    }
                    return null;
                  },
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.arrow_drop_down, size: 24),
                ),
            ],
          ),
          SizedBox(height: 12),
          _buildFormField('Statut', isTextField: true),
          SizedBox(height: 12),
          _buildFormField(
            'Date de la Demande',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),
          SizedBox(height: 12),
          _buildFormField(
            'Date Début Initiale',
            isTextField: true,
            hint: '2025-06-22',
            isDate: true,
          ),
          SizedBox(height: 12),
          _buildFormField('Durée', isTextField: true, hint: 'Durée'),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue, size: 16),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Dates',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildDateField('Date Initiale'),
                SizedBox(height: 12),
                _buildDateField('Date de Validité'),
                SizedBox(height: 12),
                _buildDateField('Date de Fin'),
                SizedBox(height: 12),
                _buildDateField('Date de décision'),
                SizedBox(height: 12),
                _buildDateField('Date de signature'),
                SizedBox(height: 12),
                _buildDateField('Date d\'Activation'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField(
      String label, {
        bool isTextField = false,
        List<String>? items,
        String? hint,
        bool isDate = false,
        bool hasSearchIcon = false,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        if (isTextField)
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: hint,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              suffixIcon: isDate
                  ? Icon(Icons.calendar_today, size: 16)
                  : hasSearchIcon
                  ? Icon(Icons.search, size: 16)
                  : null,
            ),
          )
        else
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            hint: Text(hint ?? label, overflow: TextOverflow.ellipsis),
            items: items?.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (value) {},
          ),
      ],
    );
  }

  Widget _buildDateField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            suffixIcon: Icon(Icons.calendar_today, size: 14),
          ),
        ),
      ],
    );
  }
}
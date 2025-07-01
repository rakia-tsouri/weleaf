import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:optorg_mobile/data/repositories/catalogue_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class CatalogItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String? assetPictureUrl; // nom du fichier image, ex: "S450.jpg"
  final Map<String, dynamic> specifications;

  Uint8List? imageBytes; // image décodée base64

  CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.specifications,
    this.assetPictureUrl,
    this.imageBytes,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: json['catalogid']?.toString() ?? '',
      name: json['assetlabel']?.toString() ?? 'Nom inconnu',
      category: json['assetcategorylabel']?.toString() ?? 'Autre',
      price: (json['assetnetamount'] ?? 0).toInt(),
      description: json['assetdescription']?.toString() ?? '',
      specifications: {},
      assetPictureUrl: json['assetpictureurl']?.toString(),
    );
  }
}

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  final CatalogRepository _catalogRepository = CatalogRepository();
  final AppDataStore _appDataStore = AppDataStore();

  List<CatalogItem> catalogItems = [];
  bool isLoading = true;
  String? errorMessage;
  CatalogItem? selectedItem;
  bool showSimulation = false;
  double duration = 36;
  double downPayment = 0;
  double residualValue = 20;
  String selectedCategory = 'all';
  String selectedSort = 'price';

  @override
  void initState() {
    super.initState();
    _loadCatalogItems();
  }

  Future<Uint8List?> fetchImageBase64(String token, String imageName) async {
    try {
      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final response = await dio.post(
        'https://demo-backend-utina.teamwill-digital.com/document-service/api/getfile/$imageName',
      );


      if (response.statusCode == 200 && response.data != null) {
        String? base64String = response.data['description'];
        if (base64String != null && base64String.isNotEmpty) {
          if (base64String.startsWith('data:image')) {
            base64String = base64String.split(',').last;
          }
          return base64Decode(base64String);
        }
      }
    } catch (e) {
      print('Erreur récupération image $imageName: $e');
    }
    return null;
  }

  Future<void> _loadCatalogItems() async {
    try {
      final token = await _appDataStore.getToken();
      if (token == null) throw Exception('Token non disponible');

      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final items = await _catalogRepository.fetchCatalogItems();

      // Charger images Base64 pour chaque item avec image
      for (var item in items) {
        if (item.assetPictureUrl != null && item.assetPictureUrl!.isNotEmpty) {
          final imageBytes = await fetchImageBase64(token, item.assetPictureUrl!);
          item.imageBytes = imageBytes;
        }
      }

      setState(() {
        catalogItems = items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur de chargement: ${e.toString()}';
        isLoading = false;
      });
      print('Erreur catalogue: $e');
    }
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'véhicule':
      case 'vehicle':
        return Icons.directions_car;
      case 'informatique':
      case 'it':
        return Icons.computer;
      case 'bureau':
      case 'office':
        return Icons.print;
      default:
        return Icons.image;
    }
  }

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }

  Map<String, dynamic> calculateLeasing() {
    if (selectedItem == null) {
      return {'monthlyPayment': 0, 'totalCost': 0, 'totalInterest': 0};
    }

    final price = selectedItem!.price.toDouble();
    final duration = this.duration;
    final downPayment = this.downPayment;
    final residualValue = (price * this.residualValue) / 100;
    final financedAmount = price - downPayment - residualValue;
    const interestRate = 0.04;
    final monthlyRate = interestRate / 12;

    final monthlyPayment =
        (financedAmount * monthlyRate * pow(1 + monthlyRate, duration)) /
            (pow(1 + monthlyRate, duration) - 1);

    final totalCost = monthlyPayment * duration + downPayment + residualValue;
    final totalInterest = totalCost - price;

    return {
      'monthlyPayment': monthlyPayment.round(),
      'totalCost': totalCost.round(),
      'totalInterest': totalInterest.round(),
    };
  }

  List<CatalogItem> getFilteredItems() {
    var items = catalogItems;

    if (selectedCategory != 'all') {
      items = items
          .where((item) => item.category.toLowerCase().contains(selectedCategory))
          .toList();
    }

    switch (selectedSort) {
      case 'price':
        items.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price-desc':
        items.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'name':
        items.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    if (showSimulation && selectedItem != null) {
      return _buildSimulationView();
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildCatalogBody(),
    );
  }

  Widget _buildCatalogBody() {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadCatalogItems,
              child: const Text('Réessayer'),
            ),
          ],
        ),
      );
    }

    final filteredItems = getFilteredItems();

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Catalogue des produits',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                  Chip(
                    backgroundColor: Colors.grey.shade200,
                    label: Text('${filteredItems.length} items'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildDropdown(
                    label: 'Catégorie',
                    value: selectedCategory,
                    items: const {
                      'all': 'Toutes catégories',
                      'vehicle': 'Véhicules',
                      'it': 'Informatique',
                      'office': 'Bureau',
                    },
                    onChanged: (val) => setState(() => selectedCategory = val),
                  ),
                  _buildDropdown(
                    label: 'Trier par',
                    value: selectedSort,
                    items: const {
                      'price': 'Prix croissant',
                      'price-desc': 'Prix décroissant',
                      'name': 'Nom A-Z',
                    },
                    onChanged: (val) => setState(() => selectedSort = val),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (filteredItems.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Text(
                      'Aucun produit trouvé.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(filteredItems[index]);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required Map<String, String> items,
    required ValueChanged<String> onChanged,
  }) {
    return SizedBox(
      width: 180,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1E3A8A), width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1E3A8A)),
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        items: items.entries.map((entry) {
          return DropdownMenuItem<String>(
            value: entry.key,
            child: Text(entry.value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(CatalogItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.category.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 270,
            decoration: BoxDecoration(
              color:Color.fromRGBO(0,61,112,1),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: item.imageBytes != null
                ? Image.memory(
              item.imageBytes!,
              fit: BoxFit.contain,
            )
                : Icon(
              getCategoryIcon(item.category),
              size: 60,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${formatPrice(item.price)} €',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.calculate, size: 18),
              label: const Text('Simuler le leasing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedItem = item;
                  showSimulation = true;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationView() {
    final simulation = calculateLeasing();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF003D70),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() => showSimulation = false);
          },
        ),
        title: const Text(
          'Simulation de leasing',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        getCategoryIcon(selectedItem!.category),
                        size: 30,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedItem!.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSlider(
              label: 'Durée (mois)',
              value: duration,
              min: 12,
              max: 60,
              divisions: 48,
              onChanged: (val) => setState(() => duration = val),
              displayValue: '${duration.round()}',
            ),
            const SizedBox(height: 20),
            _buildSlider(
              label: 'Apport initial (€)',
              value: downPayment,
              min: 0,
              max: selectedItem!.price.toDouble(),
              divisions: selectedItem!.price,
              onChanged: (val) => setState(() => downPayment = val),
              displayValue: '${downPayment.round()} €',
            ),
            const SizedBox(height: 20),
            _buildSlider(
              label: 'Valeur résiduelle (%)',
              value: residualValue,
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: (val) => setState(() => residualValue = val),
              displayValue: '${residualValue.round()} %',
            ),
            const SizedBox(height: 40),
            Card(
              color: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    _buildResultRow('Paiement mensuel', '${simulation['monthlyPayment']} €'),
                    const SizedBox(height: 12),
                    _buildResultRow('Coût total', '${simulation['totalCost']} €'),
                    const SizedBox(height: 12),
                    _buildResultRow('Intérêts totaux', '${simulation['totalInterest']} €'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                setState(() => showSimulation = false);
              },
              child: const Text('Retour au catalogue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
    required String displayValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label : $displayValue',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF0D1B2A),
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          label: displayValue,
          onChanged: onChanged,
          activeColor: const Color(0xFF2563EB),
          inactiveColor: Colors.grey[300],
        ),
      ],
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

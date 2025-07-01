import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'dart:math';
import 'package:optorg_mobile/data/repositories/catalogue_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class CatalogItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final Map<String, dynamic> specifications;

  CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.specifications,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    return CatalogItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Nom inconnu',
      category: json['category']?.toString() ?? 'Autre',
      price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString() ?? '',
      specifications: Map<String, dynamic>.from(json['specifications'] ?? {}),
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

  Future<void> _loadCatalogItems() async {
    try {
      final token = await _appDataStore.getToken();
      if (token == null) {
        throw Exception('Token non disponible');
      }

      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final items = await _catalogRepository.fetchCatalogItems();

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
        return Icons.directions_car;
      case 'informatique':
        return Icons.computer;
      case 'bureau':
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

    // Filtre par catégorie
    if (selectedCategory != 'all') {
      items = items.where((item) =>
          item.category.toLowerCase().contains(selectedCategory)
      ).toList();
    }

    // Tri
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Catalogue',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(child: CircularProgressIndicator(color: Colors.white)),
            ),
        ],
      ),
      body: _buildCatalogBody(),
    );
  }

  Widget _buildCatalogBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage!),
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

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header section
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Produits disponibles',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('${filteredItems.length} produits'),
                ),
              ],
            ),
          ),

          // Filters
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Category filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Toutes catégories'),
                      ),
                      DropdownMenuItem(
                        value: 'vehicle',
                        child: Text('Véhicules'),
                      ),
                      DropdownMenuItem(
                        value: 'it',
                        child: Text('Informatique'),
                      ),
                      DropdownMenuItem(
                        value: 'office',
                        child: Text('Bureau'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value ?? 'all';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Sort filter
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: selectedSort,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'price',
                        child: Text('Prix croissant'),
                      ),
                      DropdownMenuItem(
                        value: 'price-desc',
                        child: Text('Prix décroissant'),
                      ),
                      DropdownMenuItem(
                        value: 'name',
                        child: Text('Nom A-Z'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value ?? 'price';
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Product list
          if (filteredItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Text('Aucun produit trouvé'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildProductCard(item);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(CatalogItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category tag
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // Image placeholder
          Container(
            height: 200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              getCategoryIcon(item.category),
              size: 60,
              color: Colors.grey[600],
            ),
          ),

          // Product info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '${formatPrice(item.price)}€',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ],
            ),
          ),

          // Specifications
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (var entry in item.specifications.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          '${entry.key}: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(entry.value.toString()),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Simulation button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.calculate),
                label: const Text('SIMULER LE LEASING'),
                onPressed: () {
                  setState(() {
                    selectedItem = item;
                    showSimulation = true;
                  });
                },
              ),
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
        backgroundColor: const Color(0xFF2563EB),
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
            // Product card
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedItem!.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${formatPrice(selectedItem!.price)}€',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Simulation parameters
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Paramètres du leasing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Durée du contrat:'),
                    Slider(
                      value: duration,
                      min: 12,
                      max: 60,
                      divisions: (60 - 12) ~/ 6,
                      label: '${duration.toInt()} mois',
                      onChanged: (value) {
                        setState(() => duration = value);
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Apport initial (€)'),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '0',
                      ),
                      onChanged: (value) {
                        setState(() {
                          downPayment = double.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Valeur résiduelle:'),
                    Slider(
                      value: residualValue,
                      min: 0,
                      max: 50,
                      divisions: 10,
                      label: '${residualValue.toInt()}%',
                      onChanged: (value) {
                        setState(() => residualValue = value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Results
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.calculate, color: Color(0xFF2563EB)),
                        SizedBox(width: 8),
                        Text(
                          'Résultats',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Text('Mensualité'),
                                Text(
                                  '${simulation['monthlyPayment']}€',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                const Text('Coût total'),
                                Text(
                                  '${simulation['totalCost']}€',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () {
                          // TODO: Implémenter la demande d'offre
                        },
                        child: const Text(
                          'DEMANDER UNE OFFRE',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
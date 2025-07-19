import 'dart:convert';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:optorg_mobile/data/repositories/catalogue_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class AssetService {
  final String servcode;
  final String servlabel;
  final double servpercentage;
  final double servfixedamount;

  AssetService({
    required this.servcode,
    required this.servlabel,
    required this.servpercentage,
    required this.servfixedamount,
  });

  factory AssetService.fromJson(Map<String, dynamic> json) {
    return AssetService(
      servcode: json['servcode'] ?? '',
      servlabel: json['servlabel'] ?? '',
      servpercentage: (json['servpercentage'] ?? 0).toDouble(),
      servfixedamount: (json['servfixedamount'] ?? 0).toDouble(),
    );
  }
}

class AssetOption {
  final String optcode;
  final String optlabel;
  final double optprice;
  bool isSelected;

  AssetOption({
    required this.optcode,
    required this.optlabel,
    required this.optprice,
    this.isSelected = false,
  });

  factory AssetOption.fromJson(Map<String, dynamic> json) {
    return AssetOption(
      optcode: json['optcode'] ?? '',
      optlabel: json['optcodelabel'] ?? json['optlabel'] ?? '',
      optprice: (json['optnetamount'] ?? 0).toDouble(),
    );
  }
}

class CatalogItem {
  final String id;
  final String name;
  final String category;
  final int price;
  final String description;
  final String? assetPictureUrl;
  final Map<String, dynamic> specifications;
  Uint8List? imageBytes;
  final List<AssetService> services;
  final List<AssetOption> options;

  CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.specifications,
    this.assetPictureUrl,
    this.imageBytes,
    this.services = const [],
    this.options = const [],
  });

  factory CatalogItem.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> specs = {};
    if (json['assetspecifications'] != null) {
      if (json['assetspecifications'] is Map<String, dynamic>) {
        specs = Map<String, dynamic>.from(json['assetspecifications']);
      } else if (json['assetspecifications'] is List) {
        for (var specEntry in json['assetspecifications']) {
          if (specEntry is Map && specEntry.containsKey('key') && specEntry.containsKey('value')) {
            specs[specEntry['key']] = specEntry['value'];
          }
        }
      }
    }

    List<AssetService> services = [];
    if (json['assetCatalogServices'] is List) {
      services = (json['assetCatalogServices'] as List)
          .map((e) => AssetService.fromJson(e))
          .toList();
    }

    List<AssetOption> options = [];
    if (json['assetCatalogOptions'] is List) {
      options = (json['assetCatalogOptions'] as List)
          .map((e) => AssetOption.fromJson(e))
          .toList();
    }

    return CatalogItem(
      id: json['catalogid']?.toString() ?? '',
      name: json['assetlabel']?.toString() ?? 'Nom inconnu',
      category: json['assetcategorylabel']?.toString() ?? 'Autre',
      price: (json['assetnetamount'] ?? 0).toInt(),
      description: json['assetdescription']?.toString() ?? '',
      specifications: specs,
      assetPictureUrl: json['assetpictureurl']?.toString(),
      services: services,
      options: options,
    );
  }
}

class LeasingSimulationHelper {
  static int calculateMonthlyPayment({
    required double price,
    required double duration,
    required double downPayment,
    required double residualValue,
    required List<AssetService> selectedServices,
    required List<AssetOption> selectedOptions,
  }) {
    final totalServiceCost = selectedServices.fold<double>(0, (sum, s) => sum + s.servfixedamount);
    final totalOptionsCost = selectedOptions.fold<double>(0, (sum, o) => sum + o.optprice);
    final adjustedPrice = price + totalServiceCost + totalOptionsCost;
    final financedAmount = adjustedPrice - downPayment - residualValue;
    const interestRate = 0.04;
    final monthlyRate = interestRate / 12;
    final monthlyPayment = (financedAmount * monthlyRate * pow(1 + monthlyRate, duration)) /
        (pow(1 + monthlyRate, duration) - 1);
    return monthlyPayment.round();
  }

  static int calculateTotalCost({
    required double monthlyPayment,
    required double duration,
    required double downPayment,
    required double residualValue,
  }) {
    return (monthlyPayment * duration + downPayment + residualValue).round();
  }

  static int calculateTotalInterest({
    required double totalCost,
    required double originalPrice,
  }) {
    return (totalCost - originalPrice).round();
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
  List<bool> selectedServicesCheckbox = [];
  List<AssetService> selectedServices = [];
  List<bool> selectedOptionsCheckbox = [];
  List<AssetOption> selectedOptions = [];

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

    final monthlyPayment = LeasingSimulationHelper.calculateMonthlyPayment(
      price: price,
      duration: duration,
      downPayment: downPayment,
      residualValue: residualValue,
      selectedServices: selectedServices,
      selectedOptions: selectedOptions,
    );

    final totalCost = LeasingSimulationHelper.calculateTotalCost(
      monthlyPayment: monthlyPayment.toDouble(),
      duration: duration,
      downPayment: downPayment,
      residualValue: residualValue,
    );

    final totalInterest = LeasingSimulationHelper.calculateTotalInterest(
      totalCost: totalCost.toDouble(),
      originalPrice: price,
    );

    return {
      'monthlyPayment': monthlyPayment,
      'totalCost': totalCost,
      'totalInterest': totalInterest,
      'totalOptions': selectedOptions.fold<double>(0, (sum, o) => sum + o.optprice).round(),
      'totalServices': selectedServices.fold<double>(0, (sum, s) => sum + s.servfixedamount).round(),
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
              color: const Color.fromRGBO(0, 61, 112, 1),
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
                  selectedServicesCheckbox = List.filled(item.services.length, false);
                  selectedServices = [];
                  selectedOptionsCheckbox = List.filled(item.options.length, false);
                  selectedOptions = [];
                  showSimulation = true;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('Détail'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0D1B2A),
                side: const BorderSide(color: Color(0xFF0D1B2A)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CatalogDetailPage(item: item),
                  ),
                );
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
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        title: const Text('Simulation de leasing'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildProductCardSection()),
                    const SizedBox(width: 16),
                    Expanded(child: _buildParameterCardSection()),
                  ],
                )
                    : Column(
                  children: [
                    _buildProductCardSection(),
                    const SizedBox(height: 16),
                    _buildParameterCardSection(),
                  ],
                ),
                const SizedBox(height: 24),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildResultCard(
                      'Mensualité',
                      simulation['monthlyPayment'],
                      Icons.calendar_today,
                      const Color(0xFF2563EB),
                      Colors.white,
                    ),
                    _buildResultCard(
                      'Coût total',
                      simulation['totalCost'],
                      Icons.euro_symbol,
                      const Color(0xFF4F46E5),
                      Colors.white,
                    ),
                    _buildResultCard(
                      'Intérêts',
                      simulation['totalInterest'],
                      Icons.trending_up,
                      const Color(0xFF06B6D4),
                      Colors.white,
                    ),
                    if (simulation['totalOptions'] > 0)
                      _buildResultCard(
                        'Options',
                        simulation['totalOptions'],
                        Icons.add_box,
                        const Color(0xFF10B981),
                        Colors.white,
                      ),
                    if (simulation['totalServices'] > 0)
                      _buildResultCard(
                        'Services',
                        simulation['totalServices'],
                        Icons.miscellaneous_services,
                        const Color(0xFFF59E0B),
                        Colors.white,
                      ),
                  ],
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () => setState(() => showSimulation = false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2563EB),
                        side: const BorderSide(color: Color(0xFF2563EB)),
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Fermer'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.send),
                      label: const Text('Demander un devis'),
                      onPressed: () {
                        // Action future
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCardSection() {
    return Card(
      color: const Color(0xFFEFF6FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 61, 112, 1),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: selectedItem?.imageBytes != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  selectedItem!.imageBytes!,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.image_not_supported_outlined,
                size: 60,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              selectedItem?.name ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A)
              ),
            ),
            const SizedBox(height: 6),
            Chip(
              label: Text(selectedItem?.category ?? ''),
              backgroundColor: const Color(0xFFDBEAFE),
              labelStyle: const TextStyle(color: Color(0xFF2563EB)),
            ),
            const SizedBox(height: 12),
            Text(
              selectedItem?.description ?? '',
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E40AF)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${formatPrice(selectedItem?.price ?? 0)} €',
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterCardSection() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paramètres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
            const SizedBox(height: 20),
            _buildSlider(
              label: 'Durée',
              value: duration,
              min: 12,
              max: 60,
              divisions: 8,
              displayValue: '${duration.toInt()} mois',
              onChanged: (val) => setState(() => duration = val),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Apport initial (€)',
                labelStyle: const TextStyle(color: Color(0xFF1E3A8A)),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) => setState(() => downPayment = double.tryParse(value) ?? 0),
            ),
            const SizedBox(height: 16),

            // Section des options additionnelles
            if (selectedItem?.options.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              const Text('Options additionnelles',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              const SizedBox(height: 12),
              for (int i = 0; i < selectedItem!.options.length; i++)
                CheckboxListTile(
                  title: Text(selectedItem!.options[i].optlabel),
                  subtitle: Text("Prix: ${selectedItem!.options[i].optprice} €"),
                  value: selectedOptionsCheckbox[i],
                  onChanged: (val) {
                    setState(() {
                      selectedOptionsCheckbox[i] = val ?? false;
                      selectedOptions = [
                        for (int j = 0; j < selectedItem!.options.length; j++)
                          if (selectedOptionsCheckbox[j]) selectedItem!.options[j],
                      ];
                    });
                  },
                ),
            ],

            // Section des services additionnels
            if (selectedItem?.services.isNotEmpty ?? false) ...[
              const SizedBox(height: 20),
              const Text('Services additionnels',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
              const SizedBox(height: 12),
              for (int i = 0; i < selectedItem!.services.length; i++)
                CheckboxListTile(
                  title: Text(selectedItem!.services[i].servlabel),
                  subtitle: Text(
                      "Montant fixe: €${selectedItem!.services[i].servfixedamount} | Pourcentage: ${selectedItem!.services[i].servpercentage}%"),
                  value: selectedServicesCheckbox[i],
                  onChanged: (val) {
                    setState(() {
                      selectedServicesCheckbox[i] = val ?? false;
                      selectedServices = [
                        for (int j = 0; j < selectedItem!.services.length; j++)
                          if (selectedServicesCheckbox[j]) selectedItem!.services[j],
                      ];
                    });
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(String title, int value, IconData icon, Color bgColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor.withOpacity(0.85), bgColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 6),
              Text(
                '${formatPrice(value)} €',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(icon, color: Colors.white, size: 32),
        ],
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
}

class CatalogDetailPage extends StatelessWidget {
  final CatalogItem item;
  const CatalogDetailPage({super.key, required this.item});

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails du produit'),
        backgroundColor: const Color(0xFF1E3A8A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 280,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 61, 112, 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: item.imageBytes != null
                    ? Image.memory(item.imageBytes!, fit: BoxFit.contain)
                    : Icon(Icons.image_not_supported_outlined, size: 80, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 24),
            Text(item.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
            const SizedBox(height: 8),
            Chip(label: Text(item.category), backgroundColor: const Color(0xFFDBEAFE), labelStyle: const TextStyle(color: Color(0xFF2563EB))),
            const SizedBox(height: 16),
            Text(item.description, style: const TextStyle(fontSize: 16, color: Color(0xFF1E40AF))),
            const SizedBox(height: 24),
            Text('Prix : ${formatPrice(item.price)} €', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
            const SizedBox(height: 24),
            if (item.specifications.isNotEmpty) ...[
              const Text('Spécifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
              const SizedBox(height: 12),
              ...item.specifications.entries.map(
                    (entry) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E3A8A)))),
                      Expanded(flex: 5, child: Text(entry.value.toString(), style: const TextStyle(color: Colors.black87))),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            if (item.options.isNotEmpty) ...[
              const Text('Options disponibles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
              const SizedBox(height: 12),
              ...item.options.map((option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(option.optlabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Prix: ${option.optprice} €'),
                  ),
                ),
              )),
            ],
            const SizedBox(height: 24),
            if (item.services.isNotEmpty) ...[
              const Text('Services associés', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0D1B2A))),
              const SizedBox(height: 12),
              ...item.services.map((service) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Card(
                  elevation: 1,
                  child: ListTile(
                    title: Text(service.servlabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('Code: ${service.servcode}\nMontant fixe: ${service.servfixedamount} €\nPourcentage: ${service.servpercentage} %'),
                  ),
                ),
              )),
            ]
          ],
        ),
      ),
    );
  }
}



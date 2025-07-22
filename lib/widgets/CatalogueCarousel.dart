import 'package:flutter/material.dart';
import 'package:optorg_mobile/pages/catalogue_page.dart';
import 'package:optorg_mobile/data/repositories/catalogue_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:async'; // Ajout pour Timer

class CatalogueCarousel extends StatefulWidget {
  const CatalogueCarousel({Key? key}) : super(key: key);

  @override
  State<CatalogueCarousel> createState() => _CatalogueCarouselState();
}

class _CatalogueCarouselState extends State<CatalogueCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  bool _isLoading = true;
  String? _errorMessage;
  final CatalogRepository _catalogRepository = CatalogRepository();
  final AppDataStore _appDataStore = AppDataStore();
  List<CatalogItem> _catalogItems = [];

  // Timer pour l'auto-scroll
  Timer? _autoScrollTimer;
  bool _userInteracting = false; // Pour savoir si l'utilisateur interagit

  @override
  void initState() {
    super.initState();
    _loadCatalogItems();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoScrollTimer?.cancel(); // Annuler le timer
    super.dispose();
  }

  // Fonction pour démarrer l'auto-scroll
  void _startAutoScroll() {
    _autoScrollTimer?.cancel(); // Annuler le timer existant s'il y en a un
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!_userInteracting && _catalogItems.isNotEmpty && mounted) {
        int nextPage = (_currentPage + 1) % _catalogItems.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  // Fonction pour arrêter temporairement l'auto-scroll
  void _pauseAutoScroll() {
    _userInteracting = true;
    // Reprendre l'auto-scroll après 3 secondes d'inactivité
    Timer(const Duration(seconds: 3), () {
      _userInteracting = false;
    });
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
        _isLoading = true;
        _errorMessage = null;
      });

      final items = await _catalogRepository.fetchCatalogItems();
      // Load images for the first few items (for the carousel)
      final itemsToLoad = items.take(4).toList(); // Limit to 4 items for the carousel

      for (var item in itemsToLoad) {
        if (item.assetPictureUrl != null && item.assetPictureUrl!.isNotEmpty) {
          final imageBytes = await fetchImageBase64(token, item.assetPictureUrl!);
          item.imageBytes = imageBytes;
        }
      }

      setState(() {
        _catalogItems = itemsToLoad;
        _isLoading = false;
      });

      // Démarrer l'auto-scroll une fois les données chargées
      if (_catalogItems.isNotEmpty) {
        _startAutoScroll();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erreur de chargement: ${e.toString()}';
        _isLoading = false;
      });
      print('Erreur catalogue: $e');
    }
  }

  String formatPrice(int price) {
    // Convert price to Euros (assuming 1 EUR = 10.8 MAD for example)
    // You should replace this with your actual conversion rate
    double priceInEuros = price / 10.8;

    // Format the price with 2 decimal places and Euro symbol
    return '${priceInEuros.toStringAsFixed(2)} €';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_catalogItems.isEmpty) {
      return const Center(child: Text('Aucun produit disponible'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nos Produits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: const Text('Catalogue'),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        body: const CatalogPage(),
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF0F9FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Voir tout',
                  style: TextStyle(
                    color: Color(0xFF007BFF),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _pauseAutoScroll(); // Pause l'auto-scroll quand l'utilisateur change de page
            },
            itemCount: _catalogItems.length,
            itemBuilder: (context, index) {
              final item = _catalogItems[index];
              return GestureDetector(
                onTap: () {
                  _pauseAutoScroll(); // Pause l'auto-scroll quand l'utilisateur tape
                  // Navigate to product detail if needed
                },
                onPanStart: (_) => _pauseAutoScroll(), // Pause quand l'utilisateur commence à faire glisser
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (item.imageBytes != null)
                          Image.memory(
                            item.imageBytes!,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'À partir de ${formatPrice(item.price)}', // Updated to use Euros
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _catalogItems.length,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? const Color(0xFF2563EB) : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
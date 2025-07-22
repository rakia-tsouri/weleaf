import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/utils/app_data_store.dart';

class ProductRepository {
  final AppDataStore _appDataStore = AppDataStore();
  static const String _baseUrl = "https://demo-backend-utina.teamwill-digital.com";
  static const String _endpoint = "/configuration-service/api/productlist";

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing authentication token');
    }

    final response = await http.get(
      Uri.parse(_baseUrl + _endpoint),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['list']);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid or expired token');
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
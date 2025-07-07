import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductRepository {
  static const String _baseUrl = "https://demo-backend-utina.teamwill-digital.com";
  static const String _endpoint = "/configuration-service/api/productlist";
  static const String _token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTYiLCJpYXQiOjE3NTE4NzYyNDksImV4cCI6MTc1MjQ4MTA0OX0.C2YnueXJFFiz0F0GxTETXrXWPkY_5Bv8mD3p6DVUjSHVoNfT1F3Rvt3Gjz1QgNiut7hiEyeGzjF9hPHruGt1IQ"; // Remplacez par votre vrai token

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(
      Uri.parse(_baseUrl + _endpoint),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data['list']);
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
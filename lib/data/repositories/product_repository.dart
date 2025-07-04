import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductRepository {
  static const String _baseUrl = "https://demo-backend-utina.teamwill-digital.com";
  static const String _endpoint = "/configuration-service/api/productlist";
  static const String _token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTYiLCJpYXQiOjE3NTE2Mjg5NDksImV4cCI6MTc1MjIzMzc0OX0.0oBXmWzg7-f1upG6AGeSWQYTiNwVGc7jR0hLSpIr2mWlCqOYFt4tctXti03ZeNO_A2_noJxXjipJ6rnrLPUCXg"; // Remplacez par votre vrai token

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
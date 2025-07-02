import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ContractRepository {
  final String _baseUrl = "https://demo-backend-utina.teamwill-digital.com/fincontract-service/api";

  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<List<Map<String, dynamic>>> fetchClientContracts() async {
    final token = await _getAuthToken();
    if (token == null) throw Exception('Token d\'authentification manquant');

    final response = await http.get(
      Uri.parse("$_baseUrl/contract"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> contracts = json.decode(response.body);
      return contracts
          .where((c) => c['tpidclient'] == 823)
          .map((c) => c as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Échec du chargement: ${response.statusCode}');
    }
  }
}
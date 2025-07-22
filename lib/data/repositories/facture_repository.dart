import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class FactureRepository {
  final AppDataStore _appDataStore = AppDataStore();
  final String baseUrl = 'https://demo-backend-utina.teamwill-digital.com/clientinvoice-service/api/clientInvoice';

  Future<List<Facture>> fetchFactures() async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token d\'authentification manquant');
    }

    // Construction de l'URI avec tous les paramètres requis
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'mgid': '6', // Fixed mgid value as required
        'cidocreference': '',
        'cireference': '',
        'cistatus': '',
        'citype': '',
        'clientname': '',
        'ctreference': '',
        'currcode': '',
        'datemax': '',
        'datemin': '',
        'paystatus': '',
        'tpreference': '',
      },
    );

    print('Requête envoyée à: ${uri.toString()}'); // Debug log

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Réponse reçue: ${response.statusCode}'); // Debug log

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != '200') {
        throw Exception(data['message'] ?? 'Erreur inconnue du serveur');
      }

      if (data['list'] == null || data['list'].isEmpty) {
        return [];
      }

      return (data['list'] as List)
          .map((item) => Facture.fromJson(item))
          .toList();
    } else {
      final errorData = json.decode(response.body);
      final errorMsg = errorData['message'] ?? 'Erreur inconnue';
      throw Exception('$errorMsg (${response.statusCode})');
    }
  }

  List<Facture> filterFacturesPayees(List<Facture> factures) {
    return factures.where((f) => f.cistatus == 'VALID').toList();
  }

  List<Facture> filterFacturesImpayees(List<Facture> factures) {
    return factures.where((f) => f.cistatus == 'INPROG').toList();
  }
}
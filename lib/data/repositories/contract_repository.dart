// repositories/contract_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/contract.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class ContractRepository {
  final AppDataStore _appDataStore = AppDataStore();
  final String baseUrl = 'https://demo-backend-utina.teamwill-digital.com/fincontract-service/api/contract';

  Future<List<Contract>> fetchContracts() async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token d\'authentification manquant');
    }

    // Construction de l'URI avec tous les paramètres requis
    final uri = Uri.parse(baseUrl).replace(
      queryParameters: {
        'branchid': '0',
        'ctstatus': 'ACTIVE', // Filtre clé pour les contrats actifs
        'brokername': '',
        'clientname': '', // Ajout filtre par nom client
        'clientreference': '',
        'ctphase': '',
        'ctreference': '',
        'ctrid': '',
        'datemax': '',
        'datemin': '',
        'marketingid': '0',
        'network': '',
        'offerid': '0',
        'prcode': '',
        'propreference': '',
        'tpidbroker': '0',
        'tpidsupplier': '',
        'tprefbroker': '',
        'tpreference': '',
      },
    );

    print('Requête envoyée à: ${uri.toString()}'); // Log pour débogage

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print('Réponse reçue: ${response.statusCode}'); // Log pour débogage

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['code'] != '200') {
        throw Exception(data['message'] ?? 'Erreur inconnue du serveur');
      }

      if (data['list'] == null || data['list'].isEmpty) {
        return [];
      }

      return (data['list'] as List)
          .map((item) => Contract.fromJson(item))
          .toList();
    } else {
      final errorData = json.decode(response.body);
      final errorMsg = errorData['message'] ?? 'Erreur inconnue';
      throw Exception('$errorMsg (${response.statusCode})');
    }
  }
}
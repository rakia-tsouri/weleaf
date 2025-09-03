import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/facture_model.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'dart:typed_data'; // Ajoutez cette ligne

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
        'tpreference': '00857',
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
    return factures.where((f) => f.cistatus == 'PAID').toList();
  }

  List<Facture> filterFacturesImpayees(List<Facture> factures) {
    return factures.where((f) => f.cistatus != 'PAID').toList();
  }

  // Dans votre FactureRepository
  Future<Uint8List> downloadFacturePdf(int printId) async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Token d\'authentification manquant');
    }

    // URL CORRIGÉE - Utilisez le bon endpoint
    final downloadUrl = 'https://demo-backend-utina.teamwill-digital.com/printing-service/api/print/download?printid=$printId';

    print('Téléchargement PDF depuis: $downloadUrl');

    final response = await http.get(
      Uri.parse(downloadUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/pdf',
      },
    );

    print('Réponse téléchargement: ${response.statusCode}');
    print('Taille du contenu: ${response.bodyBytes.length} bytes');

    if (response.statusCode == 200) {
      if (response.bodyBytes.isEmpty) {
        throw Exception('Le fichier PDF est vide');
      }
      return response.bodyBytes;
    } else {
      // Essayez de lire le message d'erreur en texte brut d'abord
      String errorMsg;
      try {
        errorMsg = utf8.decode(response.bodyBytes);
      } catch (e) {
        errorMsg = 'Erreur lors du décodage de la réponse';
      }

      // Si c'est du JSON, essayez de le parser
      try {
        final errorData = json.decode(errorMsg);
        errorMsg = errorData['message'] ?? errorMsg;
      } catch (e) {
        // Ce n'est pas du JSON, on garde le message texte
      }

      throw Exception('$errorMsg (${response.statusCode})');
    }
  }

}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/data/models/calendar.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class CalendarRepository {
  final AppDataStore _appDataStore = AppDataStore();
  static const String _baseUrl = "https://demo-backend-utina.teamwill-digital.com";
  static const String _endpoint = "/configuration-service/api/parcalendar";

  Future<List<calendar>> fetchCalendars() async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing authentication token');
    }

    try {
      final url = Uri.parse(_baseUrl + _endpoint);
      print('Fetching calendars from: $url'); // Debug print

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}'); // Debug print
      print('Response body: ${response.body}'); // Debug print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Handle both cases: direct array or wrapped in 'list' property
        if (data is List) {
          return data.map((json) => calendar.fromJson(json)).toList();
        } else if (data['list'] != null) {
          return (data['list'] as List)
              .map((json) => calendar.fromJson(json))
              .toList();
        }
        throw Exception('Invalid response format');
      } else {
        throw Exception('Failed to load calendars: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
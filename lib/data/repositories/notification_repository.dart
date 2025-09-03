import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/notification_model.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class NotificationRepository {
  final AppDataStore _appDataStore = AppDataStore();

  Future<List<ApiNotification>> getNotifications() async {
    final token = await _appDataStore.getToken();
    if (token == null || token.isEmpty) {
      throw Exception('Missing authentication token');
    }

    final response = await http.get(
      Uri.parse('https://demo-backend-utina.teamwill-digital.com/workflow-service/api/myNotiflist'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Decode response safely
    Map<String, dynamic> responseBody;
    try {
      responseBody = json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to decode response: $e');
    }

    final responseCode = responseBody['code'];
    final responseList = responseBody['list'];

    // Handle no content: either status 204, or custom "code": "204", or list is null
    if (response.statusCode == 204 || responseCode == '204' || responseList == null) {
      return [];
    }

    // Success response with data
    if (response.statusCode == 200 && responseCode == '200') {
      try {
        return (responseList as List)
            .map((json) => ApiNotification.fromJson(json))
            .toList();
      } catch (e) {
        throw Exception('Failed to parse notifications: $e');
      }
    }

    // Auth error
    if (response.statusCode == 401) {
      throw Exception('Invalid or expired token');
    }

    // Fallback for any other error
    throw Exception('Unexpected server response: ${response.body}');
  }
}

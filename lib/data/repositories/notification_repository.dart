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

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['code'] == '200' && data['list'] != null) {
        return (data['list'] as List)
            .map((json) => ApiNotification.fromJson(json))
            .toList();
      }
      throw Exception('Invalid response format');
    } else if (response.statusCode == 401) {
      throw Exception('Invalid or expired token');
    } else {
      throw Exception('Server error: ${response.statusCode}');
    }
  }
}
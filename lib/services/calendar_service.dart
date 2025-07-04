import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/Calendar.dart';

class CalendarService {
  static Future<List<Calendar>> fetchCalendars() async {
    final response = await http.get(
      Uri.parse('https://demo-backend-utina.teamwill-digital.com/configuration-service/api/parcalendar'),
      headers: {'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTYiLCJpYXQiOjE3NTE2Mjg5NDksImV4cCI6MTc1MjIzMzc0OX0.0oBXmWzg7-f1upG6AGeSWQYTiNwVGc7jR0hLSpIr2mWlCqOYFt4tctXti03ZeNO_A2_noJxXjipJ6rnrLPUCXg',
        'Content-Type': 'application/json',},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List).map((item) => Calendar.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load calendars');
    }
  }
}
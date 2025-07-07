import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/Calendar.dart';

class CalendarService {
  static Future<List<Calendar>> fetchCalendars() async {
    final response = await http.get(
      Uri.parse('https://demo-backend-utina.teamwill-digital.com/configuration-service/api/parcalendar'),
      headers: {'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTYiLCJpYXQiOjE3NTE4NzYyNDksImV4cCI6MTc1MjQ4MTA0OX0.C2YnueXJFFiz0F0GxTETXrXWPkY_5Bv8mD3p6DVUjSHVoNfT1F3Rvt3Gjz1QgNiut7hiEyeGzjF9hPHruGt1IQ',
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
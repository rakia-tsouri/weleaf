
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:optorg_mobile/data/models/region.dart';

class RegionService {
  static Future<List<Region>> fetchRegions() async {
    final response = await http.get(
      Uri.parse('https://demo-backend-utina.teamwill-digital.com/configuration-service/api/parlistChild?parcode=TPREGGLOB&parvalueparent=FR'),
      headers: {'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyMTYiLCJpYXQiOjE3NTE2Mjg5NDksImV4cCI6MTc1MjIzMzc0OX0.0oBXmWzg7-f1upG6AGeSWQYTiNwVGc7jR0hLSpIr2mWlCqOYFt4tctXti03ZeNO_A2_noJxXjipJ6rnrLPUCXg',
        'Content-Type': 'application/json',
        'Accept': 'application/json',},
    ).timeout(Duration(seconds: 10)); // Ajoutez un timeout

    print('Response status: ${response.statusCode}'); // Debug
    print('Response body: ${response.body}'); // Debug

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['list'] as List).map((item) => Region.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load regions');
    }
  }
}
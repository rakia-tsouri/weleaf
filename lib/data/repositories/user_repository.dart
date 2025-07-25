import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class UserRepository {
  final AppDataStore _appDataStore = AppDataStore();

  /// Get current user profile from API
  Future<User?> getCurrentUserProfile() async {
    try {
      // Get token from storage
      String? token = await _appDataStore.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant');
      }

      // Make API call to get user profile
      final response = await http.get(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/authentication-service/authenticate/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        // Create User object with the API response
        User user = User(
          code: 200,
          message: 'Success',
          token: token,
          data: Data.fromJson(responseData),
        );

        return user;
      } else if (response.statusCode == 401) {
        throw Exception('Token d\'authentification invalide ou expiré');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors du chargement du profil: $e');
      rethrow;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(User user) async {
    try {
      String? token = await _appDataStore.getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token d\'authentification manquant');
      }

      final response = await http.put(
        Uri.parse('https://demo-backend-utina.teamwill-digital.com/authentication-service/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(user.data?.toJson()),
      );

      if (response.statusCode == 200) {
        // Update local storage with new user info
        await _appDataStore.saveUserInfo(json.encode(user));
        return true;
      } else {
        throw Exception('Erreur lors de la mise à jour: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du profil: $e');
      return false;
    }
  }

  /// Get user from local storage
  Future<User?> getCachedUser() async {
    try {
      return await _appDataStore.getUserInfo();
    } catch (e) {
      print('Erreur lors de la récupération du cache utilisateur: $e');
      return null;
    }
  }
}
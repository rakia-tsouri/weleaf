import 'dart:convert';

import 'package:optorg_mobile/constants/api_constants.dart';
import 'package:optorg_mobile/data/models/authentication_user.dart';
import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class AuthRepository extends AppRepository {
  Future<User?> authenticateUser(AuthUser authUser, bool saveSession) async {
    try {
      var serverResponse = await dio.post(AUTH_TOKEN_API,
          data: authUser.toJson(), queryParameters: null);
      var data = serverResponse.data;
      User? connectedUser = User.fromJson(data);
      var token_string = data["token"];
      var appStorage = AppDataStore();

      await appStorage.saveUserInfo(json.encode(connectedUser));
      await appStorage.saveUserCredentials(
          authUser.username, authUser.password);
      await appStorage.saveToken(token_string);
      await appStorage.saveUserRemeberMe(authUser.rememberMe);

      return connectedUser;
    } catch (e) {
      return null;
    }
  }
}

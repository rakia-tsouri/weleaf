import 'package:optorg_mobile/data/models/user.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';

class SplashScreenVM {
  Future<String?> getUserToken() async {
    String? userToken = await AppDataStore().getToken();
    return userToken;
  }

  Future<User?> getUserData() async {
    User? user = await AppDataStore().getUserInfo();
    return user;
  }
}

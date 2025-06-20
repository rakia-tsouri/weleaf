import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:optorg_mobile/data/models/user.dart';

const USER_DATA = "USER_DATA";
const USER_NAME = "USER_NAME";
const USER_PASSWORD = "USER_PASSWORD";
const TOKEN_DATA = "TOKEN_DATA";
const TOKEN_ANONYMOUS = "TOKEN_ANONYMOUS";
const USER_PHONE_NUMBER = "USER_PHONE_NUMBER";
const USER_REMEMBER_ME = "USER_REMEMBER_ME";
const USER_READ_DAAQ = "USER_READ_DAAQ";

class AppDataStore {
  late FlutterSecureStorage storage;
  AppDataStore() {
    storage = new FlutterSecureStorage();
  }

// ********
// ********
  saveUserPhoneNumberContactMechanism(String? phoneNumber) async {
    await storage.write(key: USER_PHONE_NUMBER, value: phoneNumber);
  }

  // ********
// ********
  Future<String?> getUserPhoneNumberContactMechanism() async {
    return await storage.read(key: USER_PHONE_NUMBER);
  }

// ********
// ********
  saveUserInfo(String userAsJson) async {
    await storage.write(key: USER_DATA, value: userAsJson);
  }

// ********
// ********
  Future<User?> getUserInfo() async {
    String? userString = await storage.read(key: USER_DATA);
    if (userString == null) {
      return null;
    } else {
      return User.fromJson(jsonDecode(userString));
    }
  }

// ********
// ********
  saveUserCredentials(String username, String userPassword) async {
    await storage.write(key: USER_NAME, value: username);
    await storage.write(key: USER_PASSWORD, value: userPassword);
  }

  // ********
// ********
  saveUserReadDAAQ(String userDaaq) async {
    await storage.write(key: USER_READ_DAAQ, value: userDaaq);
  }

// ********
// ********
  Future<String?> getUserReadDAAQ() async {
    try {
      return await storage.read(key: USER_READ_DAAQ);
    } catch (ex) {
      return null;
    }
  }

// ********
// ********
  saveUserRemeberMe(bool rememberMe) async {
    await storage.write(key: USER_REMEMBER_ME, value: rememberMe ? "1" : "0");
  }

  // ********
// ********
  Future<bool> getUserRemeberMe() async {
    try {
      String? rememberMeAsString = await storage.read(key: USER_REMEMBER_ME);
      if (rememberMeAsString == "1") {
        return true;
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

// ********
// ********
  Future<String?> getUsername() async {
    try {
      return await storage.read(key: USER_NAME);
    } catch (ex) {
      return null;
    }
  }

// ********
// ********
  Future<Map<String, String?>> getUserCredentials() async {
    String? userName = await storage.read(key: USER_NAME);
    String? password = await storage.read(key: USER_PASSWORD);
    return {USER_NAME: userName, USER_PASSWORD: password};
  }

  saveToken(String token) async {
    await storage.write(key: TOKEN_DATA, value: token);
  }

  saveAnonymousToken(String token) async {
    await storage.write(key: TOKEN_ANONYMOUS, value: token);
  }

  Future<String?> getToken() async {
    String? token = await storage.read(key: TOKEN_DATA);
    return token;
  }

  Future<String?> getAnonymousToken() async {
    String? token = await storage.read(key: TOKEN_ANONYMOUS);
    return token;
  }

// *********************
// *********************
  Future<void> clearAppData() async {
    bool isUserRemember = await getUserRemeberMe();
    String? userLogin;
    if (isUserRemember) {
      userLogin = await getUsername() ?? "";
    }
    await storage.deleteAll();
    if (isUserRemember) {
      await saveUserCredentials(userLogin ?? "", "");
      await saveUserRemeberMe(true);
    }
  }
}

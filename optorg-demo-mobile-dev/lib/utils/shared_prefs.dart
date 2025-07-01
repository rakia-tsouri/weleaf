import 'package:shared_preferences/shared_preferences.dart';

const String EQUIPMENT_SIMULATION_AMOUT_INPUT_KEY =
    "EQUIPMENT_SIMULATION_AMOUT_INPUT";
const String EQUIPMENT_SIMULATION_DURATION_INPUT_KEY =
    "EQUIPMENT_SIMULATION_DURATION_INPUT";

const String CURRENT_OFFER_PROCESS_STEP_KEY = "CURRENT_OFFER_PROCESS_STEP_KEY";
const String WRONG_LOGIN_ATTEMPTS_TIME = "WRONG_LOGIN_ATTEMPTS_TIME";

class SharedPrefs {
  static Future<int?> getIntValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key);
  }

  static Future<bool> setIntValue(String key, int value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(key, value);
  }

  static Future<String?> getStringValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key);
  }

  static Future<bool> setStringValue(String key, String value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(key, value);
  }

  static Future<double?> getDoubleValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getDouble(key);
  }

  static Future<bool> setDoubleValue(String key, double value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setDouble(key, value);
  }

  static Future<bool?> getBooleanValue(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(key);
  }

  static Future<bool> setBooleanValue(String key, bool value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(key, value);
  }

  static clear() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }
}

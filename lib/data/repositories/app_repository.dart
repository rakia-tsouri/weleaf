import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:optorg_mobile/constants/arrays.dart';
import 'package:optorg_mobile/constants/versions.dart';
import 'package:optorg_mobile/utils/app_interceptor.dart';

class AppRepository {
  Dio dio = Dio();
  Dio dioWithToken = Dio();
  // ************
  // ************
  static Dio createDioInstance({withInterceptors = true}) {
    Dio dio = Dio();

    BaseOptions options = BaseOptions(
        followRedirects: false,
        connectTimeout: const Duration(seconds: 200),
        receiveTimeout: const Duration(seconds: 20),
        baseUrl: API_BASE_URL);
    dio.options = options;
    return dio;
  }

  // ************
  // ************
  AppRepository() {
    BaseOptions options = BaseOptions(
        followRedirects: false,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        baseUrl: API_BASE_URL);
    dio.options = options;
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    dioWithToken.options = options;
    dioWithToken.interceptors
        .add(LogInterceptor(requestBody: true, responseBody: true));
    dioWithToken.interceptors.add(AppInteceptor());

    _setupSavedUserBaseUrl();
  }
  // ************
  // ************
  _setupSavedUserBaseUrl() async {
    dio.options.baseUrl = API_BASE_URL;
    dioWithToken.options.baseUrl = API_BASE_URL;
  }

  // ************
  // ************
  Future<ConnectivityStatus> checkConnectivity() async {
    List<ConnectivityResult> connectivityResult;
    try {
      Connectivity connectivity = Connectivity();
      connectivityResult = await connectivity.checkConnectivity();
      return _getStatusFromConnectivityResult(connectivityResult);
    } catch (exception) {
      print(exception.toString());
    }
    return ConnectivityStatus.OFFLINE;
  }

// ************
  // ************
  ConnectivityStatus _getStatusFromConnectivityResult(
      List<ConnectivityResult> connectivityResult) {
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      return ConnectivityStatus.ONLINE;
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      return ConnectivityStatus.ONLINE;
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Wi-fi is available.
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
      return ConnectivityStatus.ONLINE;
    }
    return ConnectivityStatus.OFFLINE;
  }

  // ************
  // ************
  isOnline() async {
    var connectivityResult = await checkConnectivity();
    return connectivityResult == ConnectivityStatus.ONLINE;
  }

// ************
  // ************
  isOffline() async {
    var connectivityResult = await checkConnectivity();
    return connectivityResult == ConnectivityStatus.OFFLINE;
  }
}

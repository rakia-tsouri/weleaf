import 'package:dio/dio.dart';
import 'package:optorg_mobile/constants/versions.dart';
import 'package:optorg_mobile/data/models/authentication_user.dart';
import 'package:optorg_mobile/data/repositories/app_repository.dart';
import 'package:optorg_mobile/data/repositories/auth_repository.dart';
import 'package:optorg_mobile/utils/app_data_store.dart';
import 'package:optorg_mobile/utils/extensions.dart';

class AppInteceptor extends Interceptor {
  var appStorage = AppDataStore();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var token = await appStorage.getToken();
    if (token == null) {
      token = await appStorage.getAnonymousToken();
    }
    options.headers['Authorization'] = token!.toBearer();

    options.baseUrl = API_BASE_URL;
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      var refreshTokenResult;
      Map<String, String?> userCredentials =
          await appStorage.getUserCredentials();
      bool rememberMe = await appStorage.getUserRemeberMe();
      refreshTokenResult = await AuthRepository().authenticateUser(
          AuthUser(
              password: userCredentials[USER_PASSWORD] ?? "",
              username: userCredentials[USER_NAME] ?? "",
              rememberMe: rememberMe),
          rememberMe);

      if (refreshTokenResult != null) {
        var response = await _performDioRequest(err.requestOptions);
        if (response != null) {
          handler.resolve(response);
        } else {
          handler.reject(err);
        }
      } else {
        handler.reject(err);
      }
    } else {
      handler.reject(err);
    }
  }

  Future<Response?> _performDioRequest(RequestOptions options) async {
    var appStorage = AppDataStore();

    var dio = AppRepository.createDioInstance(withInterceptors: false);
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

    var token = await appStorage.getToken();
    if (token == null) {
      token = await appStorage.getAnonymousToken();
    }
    options.headers['Authorization'] = token.toBearer();
    try {
      switch (options.method.toUpperCase()) {
        case "GET":
          return await dio.get(options.path,
              queryParameters: options.queryParameters,
              options: Options(headers: options.headers));
        case "POST":
          return await dio.post(options.path,
              data: options.data, options: Options(headers: options.headers));
        case "DELETE":
          return await dio.delete(options.path,
              data: options.data, options: Options(headers: options.headers));
        case "PUT":
          return await dio.put(options.path,
              data: options.data, options: Options(headers: options.headers));
        default:
          return null;
      }
    } catch (err) {
      return null;
    }
  }
}

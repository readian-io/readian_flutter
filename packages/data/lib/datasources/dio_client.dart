import 'package:dio/dio.dart';
import 'package:readian_domain/domain.dart';

class DioClient {
  /// Creates a public Dio client without authentication
  /// Use for login, registration, and other public endpoints
  static Dio createPublicDio() {
    final dio = Dio();

    dio.options = BaseOptions(
      baseUrl: AppConfig.baseUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );

    return dio;
  }

  /// Creates an authenticated Dio client with token interceptor
  /// Use for protected endpoints that require authentication  
  /// Note: TokenInterceptor should be added via dependency injection in providers
  static Dio createAuthenticatedDio() {
    return createPublicDio();
  }
}

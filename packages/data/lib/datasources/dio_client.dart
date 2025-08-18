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
  static Dio createAuthenticatedDio() {
    final dio = createPublicDio();
    
    // Add auth interceptor only for authenticated client
    dio.interceptors.add(AuthInterceptor());

    return dio;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Add auth token to requests
    // final token = await AuthService.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: Handle token refresh or logout
    }
    handler.next(err);
  }
}

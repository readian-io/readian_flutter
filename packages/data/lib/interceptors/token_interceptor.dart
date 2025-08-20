import 'dart:async';
import 'package:dio/dio.dart';
import 'package:readian_domain/store/authentication_store.dart';
import '../validation/token_validator.dart';
import 'token_fetch_util.dart';

class TokenInterceptor extends Interceptor {
  static const String _authorizationHeader = 'Authorization';
  static const String _tokenTypeBearer = 'Bearer';
  static const int _minRefreshIntervalSeconds = 30;
  static const int _httpUnauthorized = 401;
  static const int _httpForbidden = 403;

  final TokenFetchUtil _tokenFetchUtil;
  final AuthenticationStore _authenticationStore;
  final TokenValidator _tokenValidator;

  Completer<void>? _refreshCompleter;
  int _lastRefreshTimeMs = 0;

  TokenInterceptor(
    this._tokenFetchUtil,
    this._authenticationStore,
    this._tokenValidator,
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authState = _authenticationStore.currentState;

    authState.when(
      unauthenticated: () {
        handler.next(options);
      },
      authenticated: (String accessToken, String refreshToken) async {
        await _handleAuthenticatedRequest(options, handler, accessToken);
      },
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRetryWithFreshToken(err.response)) {
      final authState = _authenticationStore.currentState;
      
      await authState.when(
        unauthenticated: () async {
          handler.next(err);
        },
        authenticated: (String accessToken, String refreshToken) async {
          await _retryWithFreshToken(err, handler, accessToken);
        },
      );
    } else {
      handler.next(err);
    }
  }

  Future<void> _handleAuthenticatedRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
    String accessToken,
  ) async {
    if (_shouldRefreshTokenPreemptively(accessToken)) {
      final freshToken = await _getFreshToken(accessToken);
      if (freshToken != null) {
        _addAuthHeader(options, freshToken);
        handler.next(options);
        return;
      }
    }

    _addAuthHeader(options, accessToken);
    handler.next(options);
  }

  Future<void> _retryWithFreshToken(
    DioException err,
    ErrorInterceptorHandler handler,
    String currentToken,
  ) async {
    final freshToken = await _getFreshToken(currentToken);

    if (freshToken != null) {
      try {
        final requestOptions = err.requestOptions;
        _addAuthHeader(requestOptions, freshToken);
        
        final dio = Dio();
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRetryWithFreshToken(Response? response) {
    if (response == null) return false;
    return response.statusCode == _httpUnauthorized || 
           response.statusCode == _httpForbidden;
  }

  bool _shouldRefreshTokenPreemptively(String token) {
    final tokenNeedsRefresh = _tokenValidator.isTokenExpiredWithoutVerification(token);
    if (!tokenNeedsRefresh) return false;

    final currentTimeMs = DateTime.now().millisecondsSinceEpoch;
    final minRefreshIntervalMs = _minRefreshIntervalSeconds * 1000;
    final tooSoonToRefresh = (currentTimeMs - _lastRefreshTimeMs) < minRefreshIntervalMs;
    
    if (tooSoonToRefresh) {
      return false;
    }

    return true;
  }

  Future<String?> _getFreshToken(String currentToken) async {
    try {
      // Simple mutex-like behavior using a completer
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        await _refreshCompleter!.future;
        final currentAuthState = _authenticationStore.currentState;
        return currentAuthState.whenOrNull(
          authenticated: (accessToken, refreshToken) => 
            accessToken != currentToken ? accessToken : null,
        );
      }

      _refreshCompleter = Completer<void>();
      
      return await _performTokenRefresh(_refreshCompleter!);
    } catch (e) {
      _refreshCompleter?.complete();
      return null;
    }
  }

  Future<String?> _performTokenRefresh(Completer<void> completer) async {
    try {
      final newAuthState = await _tokenFetchUtil.fetchFreshTokens();
      _lastRefreshTimeMs = DateTime.now().millisecondsSinceEpoch;

      completer.complete();

      return newAuthState?.whenOrNull(
        authenticated: (accessToken, refreshToken) {
          return accessToken;
        },
      );
    } catch (e) {
      completer.complete();
      return null;
    }
  }

  void _addAuthHeader(RequestOptions options, String accessToken) {
    options.headers.remove(_authorizationHeader);
    options.headers[_authorizationHeader] = '$_tokenTypeBearer $accessToken';
  }
}

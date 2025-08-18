import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:readian_domain/entities/authentication_state.dart';
import 'package:readian_domain/store/authentication_store.dart';

class TokenFetchUtil {
  final AuthenticationStore _authenticationStore;

  TokenFetchUtil(this._authenticationStore);

  Future<AuthenticationState?> fetchFreshTokens() async {
    try {
      final oldState = _authenticationStore.currentState;
      
      return oldState.when(
        authenticated: (String accessToken, String refreshToken) async {
          return await _authenticationStore.refresh(refreshToken, accessToken);
        },
        unauthenticated: () async {
          return const AuthenticationState.unauthenticated();
        },
      );
    } catch (e) {
      // Handle network errors gracefully
      if (e is SocketException || 
          e is TimeoutException ||
          (e is DioException && (
            e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError
          ))) {
        return null;
      } else {
        await _authenticationStore.clear();
        return const AuthenticationState.unauthenticated();
      }
    }
  }
}

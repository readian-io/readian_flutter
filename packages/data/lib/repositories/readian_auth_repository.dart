import 'package:dio/dio.dart';
import 'package:readian_domain/entities/auth_result.dart';
import 'package:readian_domain/entities/result/anon_reg_result.dart';
import 'package:readian_domain/entities/result/login_result.dart';
import 'package:readian_domain/entities/result/refresh_token_result.dart';
import 'package:readian_domain/entities/result/registration_result.dart';
import 'package:readian_domain/repositories/readian_auth_repository.dart';

import '../datasources/onboarding_data_source.dart';
import '../mappers/auth_mappers.dart';
import '../models/auth/anon_reg_payload.dart';
import '../models/auth/login_payload.dart';
import '../models/auth/refresh_token_payload.dart';
import '../models/auth/register_payload.dart';
import '../storage/secure_storage.dart';

class ReadianAuthRepository implements AuthRepository {
  final OnboardingDataSource _authApiClient;
  final SecureStorage _secureStorage;

  ReadianAuthRepository(this._authApiClient, this._secureStorage);

  @override
  Future<LoginResult> login(String identifier, String password) async {
    try {
      final payload = LoginPayload(identifier: identifier, password: password);
      final response = await _authApiClient.login(payload);
      final authResult = response.toEntity();

      await _storeAuthResult(authResult);

      return LoginResult.success(
        token: authResult.token,
        user: authResult.user,
      );
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 401) {
        return const LoginResult.wrongCredentials();
      } else {
        return const LoginResult.error();
      }
    }
  }

  @override
  Future<RegistrationResult> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final payload = RegisterPayload(
        email: email,
        username: username,
        password: password,
        confirmPassword: confirmPassword,
      );
      await _authApiClient.registration(payload);
      return const RegistrationResult.success();
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 422) {
        return const RegistrationResult.problem(
          problems: ['Validation failed'],
        );
      } else {
        return const RegistrationResult.error();
      }
    }
  }

  @override
  Future<AnonRegResult> registerAnonymous() async {
    try {
      final randomPassword = DateTime.now().millisecondsSinceEpoch.toString();
      final payload = AnonRegPayload(password: randomPassword);
      final response = await _authApiClient.anonRegistration(payload);

      await _secureStorage.storeTempToken(response.tempToken);

      return AnonRegResult.success(
        username: response.tempUserId,
        password: randomPassword,
      );
    } catch (e) {
      return const AnonRegResult.error();
    }
  }

  @override
  Future<RefreshTokenResult> refreshToken(
    String refreshToken,
    String accessToken,
  ) async {
    try {
      final payload = RefreshTokenPayload(
        refreshToken: refreshToken,
        accessToken: accessToken,
      );
      final response = await _authApiClient.refreshToken(payload);
      final authResult = response.toEntity();

      await _storeAuthResult(authResult);

      return RefreshTokenResult.success(token: authResult.token);
    } catch (e) {
      if (e is DioException) {
        final statusCode = e.response?.statusCode;
        if (statusCode == 401 || statusCode == 400) {
          return const RefreshTokenResult.invalidRefreshToken();
        } else if (e.type == DioExceptionType.connectionTimeout ||
                   e.type == DioExceptionType.receiveTimeout ||
                   e.type == DioExceptionType.sendTimeout) {
          return const RefreshTokenResult.incomplete();
        }
      }
      return const RefreshTokenResult.error();
    }
  }

  Future<void> _storeAuthResult(AuthResult authResult) async {
    await _secureStorage.storeAuthResult(authResult);
  }
}

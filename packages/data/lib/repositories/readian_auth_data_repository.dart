import 'dart:math';

import 'package:readian_domain/store/secure_storage.dart';
import 'package:readian_domain/repositories/auth_repository.dart';
import 'package:readian_domain/entities/result/login_result.dart';
import 'package:readian_domain/entities/result/registration_result.dart';
import 'package:readian_domain/entities/result/refresh_token_result.dart';
import 'package:readian_domain/entities/result/anon_reg_result.dart';
import '../datasources/onboarding_data_source.dart';
import '../errors/auth_data_error.dart';
import '../mappers/auth_mappers.dart';
import '../mappers/error_domain_mappers.dart';
import '../mappers/error_mappers.dart';
import '../models/auth/anon_reg_payload.dart';
import '../models/auth/login_payload.dart';
import '../models/auth/refresh_token_payload.dart';
import '../models/auth/register_payload.dart';
import '../results/auth_data_result.dart';
import '../validation/input_validator.dart';

class ReadianAuthDataRepository implements AuthRepository {
  final OnboardingDataSource _authApiClient;
  final SecureStorage _secureStorage;

  ReadianAuthDataRepository(this._authApiClient, this._secureStorage);

  // AuthRepository implementation (domain interface)
  @override
  Future<LoginResult> login(String identifier, String password) async {
    final dataResult = await _loginDataLayer(identifier, password);
    
    return dataResult.when(
      success: (authResult) => LoginResult.success(
        token: authResult.token,
        user: authResult.user,
      ),
      failure: (dataError) {
        final domainError = ErrorDomainMappers.mapLoginDataToDomain(dataError);
        return LoginResult.failure(domainError);
      },
    );
  }

  @override
  Future<RegistrationResult> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final dataResult = await _registerDataLayer(username, email, password, confirmPassword);
    
    return dataResult.when(
      success: () => const RegistrationResult.success(),
      failure: (dataError) {
        final domainError = ErrorDomainMappers.mapRegistrationDataToDomain(dataError);
        return RegistrationResult.failure(domainError);
      },
      validationFailure: (validationDataErrors) {
        final domainErrors = ErrorDomainMappers.mapValidationDataToDomain(validationDataErrors);
        return RegistrationResult.validationFailure(domainErrors);
      },
    );
  }

  @override
  Future<RefreshTokenResult> refreshToken(String refreshToken, String accessToken) async {
    final dataResult = await _refreshTokenDataLayer(refreshToken, accessToken);
    
    return dataResult.when(
      success: (authResult) => RefreshTokenResult.success(token: authResult.token),
      failure: (dataError) {
        final domainError = ErrorDomainMappers.mapRefreshTokenDataToDomain(dataError);
        return RefreshTokenResult.failure(domainError);
      },
    );
  }

  @override
  Future<AnonRegResult> registerAnonymous() async {
    try {
      await _registerAnonymousDataLayer();
      return const AnonRegResult.success(
        username: "anonymous",
        password: "temp_password",
      );
    } catch (e) {
      return const AnonRegResult.error();
    }
  }

  // Internal data layer methods
  Future<void> _registerAnonymousDataLayer() async {
    try {
      final randomPassword = _generateSecurePassword();
      final payload = AnonRegPayload(password: randomPassword);
      final response = await _authApiClient.anonRegistration(payload);

      await _secureStorage.storeTempToken(response.tempToken);
    } catch (e) {
      rethrow;
    }
  }
  Future<LoginDataResult> _loginDataLayer(String identifier, String password) async {
    // Validate inputs
    final sanitizedIdentifier = InputValidator.sanitizeInput(identifier);
    final sanitizedPassword = InputValidator.sanitizeInput(password);
    
    if (sanitizedIdentifier.isEmpty || sanitizedPassword.isEmpty) {
      return const LoginDataResult.failure(LoginDataError.emptyCredentials);
    }
    
    if (!InputValidator.isValidIdentifier(sanitizedIdentifier)) {
      return const LoginDataResult.failure(LoginDataError.invalidIdentifierFormat);
    }

    try {
      final payload = LoginPayload(
        identifier: sanitizedIdentifier, 
        password: sanitizedPassword,
      );
      final response = await _authApiClient.login(payload);
      final authResult = response.toEntity();

      await _secureStorage.storeAuthResult(authResult);

      return LoginDataResult.success(authResult);
    } catch (e) {
      final error = ErrorMappers.mapExceptionToLoginError(e);
      return LoginDataResult.failure(error);
    }
  }

  Future<RegistrationDataResult> _registerDataLayer(
    String username,
    String email,
    String password,
    String confirmPassword,
  ) async {
    // Validate and sanitize inputs
    final sanitizedUsername = InputValidator.sanitizeInput(username);
    final sanitizedEmail = InputValidator.sanitizeInput(email);
    final sanitizedPassword = InputValidator.sanitizeInput(password);
    final sanitizedConfirmPassword = InputValidator.sanitizeInput(confirmPassword);
    
    final validationErrors = <ValidationDataError>[];
    
    final usernameError = InputValidator.validateUsername(sanitizedUsername);
    if (usernameError != null) validationErrors.add(usernameError);
    
    final emailError = InputValidator.validateEmail(sanitizedEmail);
    if (emailError != null) validationErrors.add(emailError);
    
    final passwordError = InputValidator.validatePassword(sanitizedPassword);
    if (passwordError != null) validationErrors.add(passwordError);
    
    if (sanitizedPassword != sanitizedConfirmPassword) {
      validationErrors.add(ValidationDataError.passwordsNoMatch);
    }
    
    if (validationErrors.isNotEmpty) {
      return RegistrationDataResult.validationFailure(validationErrors);
    }

    try {
      final payload = RegisterPayload(
        email: sanitizedEmail,
        username: sanitizedUsername,
        password: sanitizedPassword,
        confirmPassword: sanitizedConfirmPassword,
      );
      await _authApiClient.registration(payload);
      return const RegistrationDataResult.success();
    } catch (e) {
      final error = ErrorMappers.mapExceptionToRegistrationError(e);
      return RegistrationDataResult.failure(error);
    }
  }

  Future<RefreshTokenDataResult> _refreshTokenDataLayer(
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

      await _secureStorage.storeAuthResult(authResult);

      return RefreshTokenDataResult.success(authResult);
    } catch (e) {
      final error = ErrorMappers.mapExceptionToRefreshTokenError(e);
      return RefreshTokenDataResult.failure(error);
    }
  }

  String _generateSecurePassword({int length = 16}) {
    const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%^&*';
    final Random random = Random.secure();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }
}

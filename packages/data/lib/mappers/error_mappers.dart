import 'dart:io';
import 'package:dio/dio.dart';
import '../errors/auth_data_error.dart';

class ErrorMappers {
  static LoginDataError mapDioExceptionToLoginError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
        return LoginDataError.invalidCredentials;
      case 400:
        return LoginDataError.invalidRequestFormat;
      case 500:
      case 502:
      case 503:
        return LoginDataError.serverError;
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          return LoginDataError.connectionTimeout;
        }
        return LoginDataError.unknownError;
    }
  }

  static RegistrationDataError mapDioExceptionToRegistrationError(DioException e) {
    switch (e.response?.statusCode) {
      case 422:
        return RegistrationDataError.validationFailure;
      case 409:
        return RegistrationDataError.duplicateCredentials;
      case 400:
        return RegistrationDataError.invalidRequestFormat;
      case 500:
      case 502:
      case 503:
        return RegistrationDataError.serverError;
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          return RegistrationDataError.connectionTimeout;
        }
        return RegistrationDataError.unknownError;
    }
  }

  static RefreshTokenDataError mapDioExceptionToRefreshTokenError(DioException e) {
    switch (e.response?.statusCode) {
      case 401:
      case 400:
        return RefreshTokenDataError.invalidRefreshToken;
      case 500:
      case 502:
      case 503:
        return RefreshTokenDataError.serverError;
      default:
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          return RefreshTokenDataError.connectionTimeout;
        }
        return RefreshTokenDataError.unknownError;
    }
  }

  static LoginDataError mapExceptionToLoginError(Object e) {
    if (e is DioException) {
      return mapDioExceptionToLoginError(e);
    } else if (e is SocketException) {
      return LoginDataError.networkFailure;
    } else {
      return LoginDataError.unknownError;
    }
  }

  static RegistrationDataError mapExceptionToRegistrationError(Object e) {
    if (e is DioException) {
      return mapDioExceptionToRegistrationError(e);
    } else if (e is SocketException) {
      return RegistrationDataError.networkFailure;
    } else {
      return RegistrationDataError.unknownError;
    }
  }

  static RefreshTokenDataError mapExceptionToRefreshTokenError(Object e) {
    if (e is DioException) {
      return mapDioExceptionToRefreshTokenError(e);
    } else if (e is SocketException) {
      return RefreshTokenDataError.networkFailure;
    } else {
      return RefreshTokenDataError.unknownError;
    }
  }
}
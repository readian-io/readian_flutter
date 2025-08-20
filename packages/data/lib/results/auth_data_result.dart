import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:readian_domain/entities/auth_result.dart';
import '../errors/auth_data_error.dart';

part 'auth_data_result.freezed.dart';

@freezed
sealed class LoginDataResult with _$LoginDataResult {
  const factory LoginDataResult.success(AuthResult authResult) = LoginDataSuccess;
  const factory LoginDataResult.failure(LoginDataError error) = LoginDataFailure;
}

@freezed
sealed class RegistrationDataResult with _$RegistrationDataResult {
  const factory RegistrationDataResult.success() = RegistrationDataSuccess;
  const factory RegistrationDataResult.failure(RegistrationDataError error) = RegistrationDataFailure;
  const factory RegistrationDataResult.validationFailure(List<ValidationDataError> errors) = RegistrationDataValidationFailure;
}

@freezed
sealed class RefreshTokenDataResult with _$RefreshTokenDataResult {
  const factory RefreshTokenDataResult.success(AuthResult authResult) = RefreshTokenDataSuccess;
  const factory RefreshTokenDataResult.failure(RefreshTokenDataError error) = RefreshTokenDataFailure;
}


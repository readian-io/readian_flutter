import 'package:freezed_annotation/freezed_annotation.dart';
import '../../errors/auth_domain_error.dart';

part 'registration_result.freezed.dart';

@freezed
sealed class RegistrationResult with _$RegistrationResult {
  const factory RegistrationResult.success() = RegistrationSuccess;

  const factory RegistrationResult.failure(RegistrationDomainError error) = RegistrationFailure;

  const factory RegistrationResult.validationFailure(List<ValidationDomainError> errors) = RegistrationValidationFailure;
}

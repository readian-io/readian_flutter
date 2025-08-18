import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration_result.freezed.dart';

@freezed
sealed class RegistrationResult with _$RegistrationResult {
  const factory RegistrationResult.success() = RegistrationSuccess;

  const factory RegistrationResult.problem({
    required List<String> problems,
  }) = RegistrationProblem;

  const factory RegistrationResult.error() = RegistrationError;
}

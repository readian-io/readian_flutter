import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_contract.freezed.dart';

@freezed
class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    @Default(false) bool loading,
    @Default([]) List<WelcomeProblem> errors,
  }) = _WelcomeState;
}

@freezed
sealed class WelcomeProblem with _$WelcomeProblem {
  const factory WelcomeProblem.invalidCredentials() = InvalidCredentials;
  const factory WelcomeProblem.validation(List<Field> fields) = Validation;
  const factory WelcomeProblem.genericError() = GenericError;
}

enum Field {
  identifier,
  password,
  unknown,
}
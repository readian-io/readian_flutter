import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_contract.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    @Default(false) bool loading,
    @Default([]) List<LoginProblem> errors,
  }) = _LoginState;
}

@freezed
sealed class LoginProblem with _$LoginProblem {
  const factory LoginProblem.invalidCredentials() = InvalidCredentials;
  const factory LoginProblem.validation(List<Field> fields) = Validation;
  const factory LoginProblem.genericError() = GenericError;
}

enum Field { identifier, password, unknown }

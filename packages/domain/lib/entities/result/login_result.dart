import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth_token.dart';
import '../user_entity.dart';

part 'login_result.freezed.dart';

@freezed
sealed class LoginResult with _$LoginResult {
  const factory LoginResult.success({
    required AuthToken token,
    required UserEntity user,
  }) = LoginSuccess;

  const factory LoginResult.wrongCredentials() = LoginWrongCredentials;

  const factory LoginResult.error() = LoginError;
}

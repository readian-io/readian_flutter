import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth_token.dart';
import '../user_entity.dart';
import '../../errors/auth_domain_error.dart';

part 'login_result.freezed.dart';

@freezed
sealed class LoginResult with _$LoginResult {
  const factory LoginResult.success({
    required AuthToken token,
    required UserEntity user,
  }) = LoginSuccess;

  const factory LoginResult.failure(LoginDomainError error) = LoginFailure;
}

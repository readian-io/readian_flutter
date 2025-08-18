import 'package:freezed_annotation/freezed_annotation.dart';
import 'auth_token.dart';
import 'user_entity.dart';

part 'auth_result.freezed.dart';

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required AuthToken token,
    required UserEntity user,
  }) = _AuthResult;
}

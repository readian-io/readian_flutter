import 'package:freezed_annotation/freezed_annotation.dart';
import '../auth_token.dart';

part 'refresh_token_result.freezed.dart';

@freezed
sealed class RefreshTokenResult with _$RefreshTokenResult {
  const factory RefreshTokenResult.success({
    required AuthToken token,
  }) = RefreshTokenSuccess;

  const factory RefreshTokenResult.invalidRefreshToken() = RefreshTokenInvalid;

  const factory RefreshTokenResult.incomplete() = RefreshTokenIncomplete;

  const factory RefreshTokenResult.error() = RefreshTokenError;
}

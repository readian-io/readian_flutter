import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_state.freezed.dart';

@freezed
sealed class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.authenticated({
    required String accessToken,
    required String refreshToken,
  }) = Authenticated;

  const factory AuthenticationState.unauthenticated() = Unauthenticated;
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_payload.freezed.dart';
part 'refresh_token_payload.g.dart';

@freezed
class RefreshTokenPayload with _$RefreshTokenPayload {
  const factory RefreshTokenPayload({
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _RefreshTokenPayload;

  factory RefreshTokenPayload.fromJson(Map<String, dynamic> json) => 
      _$RefreshTokenPayloadFromJson(json);
}

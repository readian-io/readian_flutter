import 'package:freezed_annotation/freezed_annotation.dart';

part 'anon_reg_response.freezed.dart';
part 'anon_reg_response.g.dart';

@freezed
class AnonRegResponse with _$AnonRegResponse {
  const factory AnonRegResponse({
    required String tempUserId,
    required String tempToken,
    @JsonKey(name: 'expires_in') int? expiresIn,
  }) = _AnonRegResponse;

  factory AnonRegResponse.fromJson(Map<String, dynamic> json) => 
      _$AnonRegResponseFromJson(json);
}

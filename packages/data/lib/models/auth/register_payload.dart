import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_payload.freezed.dart';
part 'register_payload.g.dart';

@freezed
class RegisterPayload with _$RegisterPayload {
  const factory RegisterPayload({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) = _RegisterPayload;

  factory RegisterPayload.fromJson(Map<String, dynamic> json) => 
      _$RegisterPayloadFromJson(json);
}

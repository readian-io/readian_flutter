import 'package:freezed_annotation/freezed_annotation.dart';

part 'anon_reg_payload.freezed.dart';
part 'anon_reg_payload.g.dart';

@freezed
class AnonRegPayload with _$AnonRegPayload {
  const factory AnonRegPayload({
    required String password,
  }) = _AnonRegPayload;

  factory AnonRegPayload.fromJson(Map<String, dynamic> json) => 
      _$AnonRegPayloadFromJson(json);
}

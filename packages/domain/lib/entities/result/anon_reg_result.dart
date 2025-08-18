import 'package:freezed_annotation/freezed_annotation.dart';

part 'anon_reg_result.freezed.dart';

@freezed
sealed class AnonRegResult with _$AnonRegResult {
  const factory AnonRegResult.success({
    required String username,
    required String password,
  }) = AnonRegSuccess;

  const factory AnonRegResult.error() = AnonRegError;
}

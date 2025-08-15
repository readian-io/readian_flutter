import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_state.freezed.dart';

@freezed
class WelcomeState with _$WelcomeState {
  const factory WelcomeState({
    @Default(false) bool isLoading,
    @Default(0) int currentPage,
    String? error,
  }) = _WelcomeState;
}

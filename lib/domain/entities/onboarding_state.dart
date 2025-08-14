import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_state.freezed.dart';

@freezed
class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(false) bool isLoading,
    @Default(0) int currentPage,
    String? error,
  }) = _OnboardingState;
}
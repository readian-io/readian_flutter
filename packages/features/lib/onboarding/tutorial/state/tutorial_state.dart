import 'package:freezed_annotation/freezed_annotation.dart';

part 'tutorial_state.freezed.dart';

@freezed
class TutorialState with _$TutorialState {
  const factory TutorialState({
    @Default(false) bool isLoading,
    @Default(0) int currentPage,
    String? error,
  }) = _TutorialState;
}

@freezed
sealed class NavigationSideEffect with _$TutorialNavigationSideEffect {
  const factory NavigationSideEffect.navigateToRegister() = NavigateToRegister;
}

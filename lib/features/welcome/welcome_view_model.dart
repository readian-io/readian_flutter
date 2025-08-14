import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/onboarding_state.dart';

part 'welcome_view_model.g.dart';

@riverpod
class WelcomeViewModel extends _$WelcomeViewModel {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setCurrentPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void navigateToLogin() {
    // TODO: Implement navigation to login
    setLoading(true);
    // Simulate navigation delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
      // Navigate to login screen
    });
  }

  void navigateToRegister() {
    // TODO: Implement navigation to register
    setLoading(true);
    // Simulate navigation delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setLoading(false);
      // Navigate to register screen
    });
  }
}
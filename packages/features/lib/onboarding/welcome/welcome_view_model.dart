import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_features/onboarding/welcome/state/welcome_contract.dart';

final welcomeViewModelProvider =
    StateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
      return WelcomeViewModel();
    });

class WelcomeViewModel extends StateNotifier<WelcomeState> {
  WelcomeViewModel() : super(const WelcomeState());

  void onSkip() {
    state = state.copyWith(loading: true, errors: []);
    // Handle skip logic here
    state = state.copyWith(loading: false);
  }
}

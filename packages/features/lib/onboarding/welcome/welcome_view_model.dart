

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_features/onboarding/welcome/state/welcome_contract.dart';

final welcomeViewModelProvider = StateNotifierProvider<WelcomeViewModel, WelcomeState>((ref) {
  // Inject use case dependency here
  // final welcomeUseCase = ref.watch(welcomeUseCaseProvider);
  return WelcomeViewModel(/* welcomeUseCase */);
});

class WelcomeViewModel extends StateNotifier<WelcomeState> {
  // final WelcomeUseCase _welcomeUseCase;
  
  WelcomeViewModel(/* this._welcomeUseCase */) : super(const WelcomeState());

  void setLoading(bool loading) {
    state = state.copyWith(loading: loading);
  }

  void setErrors(List<WelcomeProblem> errors) {
    state = state.copyWith(errors: errors);
  }

  void addError(WelcomeProblem error) {
    state = state.copyWith(errors: [...state.errors, error]);
  }

  void clearErrors() {
    state = state.copyWith(errors: []);
  }

  Future<void> welcome(String identifier, String password) async {
    setLoading(true);
    clearErrors();

    try {
      // await _welcomeUseCase.execute(identifier, password);
      // Handle success
    } catch (e) {
      addError(const WelcomeProblem.genericError());
    } finally {
      setLoading(false);
    }
  }
}
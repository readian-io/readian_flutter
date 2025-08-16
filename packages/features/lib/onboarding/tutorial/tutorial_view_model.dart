import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'state/tutorial_state.dart';

final tutorialViewModelProvider =
    StateNotifierProvider<TutorialViewModel, TutorialState>((ref) {
      return TutorialViewModel();
    });

class TutorialViewModel extends StateNotifier<TutorialState> {
  final StreamController<NavigationSideEffect> _navigationController =
      StreamController<NavigationSideEffect>.broadcast();

  Stream<NavigationSideEffect> get navigationEvents =>
      _navigationController.stream;

  TutorialViewModel() : super(const TutorialState());

  @override
  void dispose() {
    _navigationController.close();
    super.dispose();
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void handleNextAction() {
    if (state.currentPage < 2) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    } else {
      _navigationController.add(
        const NavigationSideEffect.navigateToRegister(),
      );
    }
  }
}

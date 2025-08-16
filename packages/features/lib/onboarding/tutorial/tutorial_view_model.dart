import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readian_presentation/presentation.dart';

import 'state/tutorial_state.dart';

final tutorialViewModelProvider = StateNotifierProvider<TutorialViewModel, TutorialState>((ref) {
  return TutorialViewModel();
});

class TutorialViewModel extends StateNotifier<TutorialState> {
  TutorialViewModel() : super(const TutorialState());

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }


  void handleNextAction(BuildContext context) {
    if (state.currentPage < 2) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    } else {
      try {
        setLoading(true);
        context.go(AppRouter.register);
      } catch (e) {
        setError('Failed to navigate to register: $e');
      } finally {
        setLoading(false);
      }
    }
  }
}
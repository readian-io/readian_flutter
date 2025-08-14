import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/navigation/app_router.dart';
import 'state/welcome_state.dart';

part 'welcome_view_model.g.dart';

@riverpod
class WelcomeViewModel extends _$WelcomeViewModel {

  @override
  WelcomeState build() {
    return const WelcomeState();
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

  void navigateToLogin(BuildContext context) {
    try {
      setLoading(true);
      context.go(AppRouter.login);
    } catch (e) {
      setError('Failed to navigate to login: $e');
    } finally {
      setLoading(false);
    }
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
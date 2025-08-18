import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_domain/usecases/auth/login_usecase.dart';
import 'package:readian_domain/store/authentication_store.dart';
import 'package:readian_presentation/providers/auth_providers.dart';

final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginViewState>((ref) {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final authStore = ref.watch(authenticationStoreProvider);
  return LoginViewModel(loginUseCase, authStore);
});

class LoginViewState {
  final bool isLoading;
  final String? error;
  final bool isSuccess;

  const LoginViewState({
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  LoginViewState copyWith({
    bool? isLoading,
    String? error,
    bool? isSuccess,
  }) {
    return LoginViewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginViewState> {
  final LoginUseCase _loginUseCase;
  final AuthenticationStore _authStore;

  LoginViewModel(this._loginUseCase, this._authStore) 
      : super(const LoginViewState());

  Future<void> login(String identifier, String password) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase(identifier, password);
    
    result.when(
      success: (token, user) async {
        await _authStore.persistToken(token);
        state = state.copyWith(
          isLoading: false,
          isSuccess: true,
        );
      },
      wrongCredentials: () {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid email or password',
        );
      },
      error: () {
        state = state.copyWith(
          isLoading: false,
          error: 'Login failed. Please try again',
        );
      },
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

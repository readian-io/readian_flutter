import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_domain/errors/auth_domain_error.dart';
import 'package:readian_domain/usecases/auth/login_usecase.dart';
import 'package:readian_domain/store/authentication_store.dart';
import 'package:readian_presentation/providers/auth_providers.dart';
import 'package:readian_flutter/l10n/app_localizations.dart';

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
  BuildContext? _context;

  LoginViewModel(this._loginUseCase, this._authStore) 
      : super(const LoginViewState());

  void setContext(BuildContext context) {
    _context = context;
  }

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
      failure: (domainError) {
        final errorMessage = _mapLoginErrorToString(domainError);
        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
      },
    );
  }

  String _mapLoginErrorToString(LoginDomainError error) {
    final l10n = _context != null ? AppLocalizations.of(_context!) : null;
    
    return switch (error) {
      LoginDomainError.wrongCredentials => l10n?.errorInvalidCredentials ?? 'Invalid email or password',
      LoginDomainError.connectionIssue => l10n?.errorNetworkConnection ?? 'Network error. Please check your connection',
      LoginDomainError.serverUnavailable => l10n?.errorServerUnavailable ?? 'Server error. Please try again later',
      LoginDomainError.invalidInput => l10n?.errorInvalidRequestFormat ?? 'Invalid request format',
      LoginDomainError.credentialsRequired => l10n?.errorUsernameEmailRequired ?? 'Username/email and password are required',
      LoginDomainError.invalidIdentifierFormat => l10n?.errorInvalidEmailUsername ?? 'Please enter a valid email or username',
      LoginDomainError.timeout => l10n?.errorNetworkConnection ?? 'Request timed out',
      LoginDomainError.unknownError => l10n?.errorGenericLogin ?? 'Login failed. Please try again',
    };
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

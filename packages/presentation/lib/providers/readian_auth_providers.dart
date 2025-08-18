import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:readian_data/data.dart';
import 'package:readian_domain/domain.dart';
import 'app_providers.dart';

// Secure Storage
final secureStorageProvider = Provider<SecureStorage>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  return ReadianSecureStorage(storage);
});

// Token Validator
final tokenValidatorProvider = Provider<TokenValidator>((ref) {
  return TokenValidator();
});

// Auth API Client
final authApiClientProvider = Provider<OnboardingDataSource>((ref) {
  final dio = ref.watch(publicDioProvider);
  return OnboardingDataSource(dio);
});

// Readian Auth Repository  
final readianAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiClient = ref.watch(authApiClientProvider);
  return ReadianAuthRepository(authApiClient, ref.watch(secureStorageProvider));
});

// Authentication Store
final authenticationStoreProvider = Provider<AuthenticationStore>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final repository = ref.watch(readianAuthRepositoryProvider);
  return ReadianAuthenticationStore(secureStorage, repository);
});

// Token Fetch Util
final tokenFetchUtilProvider = Provider<TokenFetchUtil>((ref) {
  final authStore = ref.watch(authenticationStoreProvider);
  return TokenFetchUtil(authStore);
});

// Token Interceptor
final tokenInterceptorProvider = Provider<TokenInterceptor>((ref) {
  final tokenFetchUtil = ref.watch(tokenFetchUtilProvider);
  final authStore = ref.watch(authenticationStoreProvider);
  final tokenValidator = ref.watch(tokenValidatorProvider);
  return TokenInterceptor(tokenFetchUtil, authStore, tokenValidator);
});

// Enhanced Dio with Token Interceptor
final authenticatedDioProvider = Provider<Dio>((ref) {
  final dio = DioClient.createPublicDio();
  final tokenInterceptor = ref.watch(tokenInterceptorProvider);
  dio.interceptors.add(tokenInterceptor);
  return dio;
});

// Authentication State Stream
final authenticationStateProvider = StreamProvider<AuthenticationState>((ref) {
  final authStore = ref.watch(authenticationStoreProvider);
  return authStore.state;
});

// Current Authentication State
final currentAuthStateProvider = Provider<AuthenticationState>((ref) {
  final authStore = ref.watch(authenticationStoreProvider);
  return authStore.currentState;
});

// Login Use Case with Result Types
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(readianAuthRepositoryProvider);
  return LoginUseCase(repository);
});

// Register Use Case with Result Types  
final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final repository = ref.watch(readianAuthRepositoryProvider);
  return RegisterUseCase(repository);
});

// Auth State Notifier
final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authStore = ref.watch(authenticationStoreProvider);
  return AuthStateNotifier(authStore);
});

// Auth State Model
enum AuthStatus { initial, loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  const AuthState({
    this.status = AuthStatus.initial,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? accessToken,
    String? refreshToken,
    String? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      error: error,
    );
  }
}

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthenticationStore _authenticationStore;

  AuthStateNotifier(this._authenticationStore) : super(const AuthState()) {
    _init();
  }

  void _init() {
    // Listen to authentication state changes
    _authenticationStore.state.listen((authState) {
      authState.when(
        authenticated: (accessToken, refreshToken) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            accessToken: accessToken,
            refreshToken: refreshToken,
            error: null,
          );
        },
        unauthenticated: () {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            accessToken: null,
            refreshToken: null,
            error: null,
          );
        },
      );
    });
  }

  Future<void> persistToken(AuthToken token) async {
    state = state.copyWith(status: AuthStatus.loading);
    await _authenticationStore.persistToken(token);
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _authenticationStore.clear();
  }

  void setError(String error) {
    state = state.copyWith(error: error);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

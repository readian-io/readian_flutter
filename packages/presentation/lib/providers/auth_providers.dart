import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:readian_data/datasources/onboarding_data_source.dart';
import 'package:readian_data/repositories/readian_auth_repository.dart';
import 'package:readian_data/storage/secure_storage.dart';
import 'package:readian_data/storage/readian_secure_storage.dart';
import 'package:readian_data/store/readian_authentication_store.dart';
import 'package:readian_domain/entities/authentication_state.dart';
import 'package:readian_domain/repositories/readian_auth_repository.dart';
import 'package:readian_domain/store/authentication_store.dart';
import 'package:readian_domain/usecases/auth/login_usecase.dart';
import 'package:readian_domain/usecases/auth/register_usecase.dart';
import 'app_providers.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return ReadianSecureStorage(storage);
});

final onboardingApiClientProvider = Provider<OnboardingDataSource>((ref) {
  final dio = ref.watch(publicDioProvider);
  return OnboardingDataSource(dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authApiClient = ref.watch(onboardingApiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return ReadianAuthRepository(authApiClient, secureStorage);
});

final authenticationStoreProvider = Provider<AuthenticationStore>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ReadianAuthenticationStore(secureStorage, authRepository);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(authRepository);
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(authRepository);
});

final authStateProvider = StreamProvider<AuthenticationState>((ref) {
  final authStore = ref.watch(authenticationStoreProvider);
  return authStore.state;
});

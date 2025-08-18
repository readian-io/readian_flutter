import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:readian_data/data.dart';

// Core network providers
final publicDioProvider = Provider<Dio>((ref) {
  return DioClient.createPublicDio();
});

final authenticatedDioProvider = Provider<Dio>((ref) {
  return DioClient.createAuthenticatedDio();
});

final publicApiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(publicDioProvider);
  return ApiClient(dio);
});

final authenticatedApiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(authenticatedDioProvider);
  return ApiClient(dio);
});

// Database provider
final databaseProvider = FutureProvider<Database>((ref) async {
  return await DatabaseHelper.database;
});

// Theme provider
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(false); // false = light, true = dark

  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}

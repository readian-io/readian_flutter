import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:readian_data/data.dart';

// Core network providers
final dioProvider = Provider<Dio>((ref) {
  return DioClient.createDio();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
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

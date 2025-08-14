import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';
import '../../data/datasources/api_client.dart';
import '../../data/datasources/dio_client.dart';
import '../../data/datasources/database_helper.dart';

part 'app_providers.g.dart';

// Core network providers
@riverpod
Dio dio(DioRef ref) {
  return DioClient.createDio();
}

@riverpod
ApiClient apiClient(ApiClientRef ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
}

// Database provider
@riverpod
Future<Database> database(DatabaseRef ref) async {
  return await DatabaseHelper.database;
}

// Theme provider
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  bool build() {
    // Default to light theme
    return false; // false = light, true = dark
  }

  void toggleTheme() {
    state = !state;
  }

  void setTheme(bool isDark) {
    state = isDark;
  }
}
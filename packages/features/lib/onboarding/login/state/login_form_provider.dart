import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_domain/domain.dart';

final usernameProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');

final hasUsernameErrorProvider = Provider<bool>((ref) {
  final email = ref.watch(usernameProvider);
  return !email.isValidUsername && email.isNotBlank;
});

final hasPasswordErrorProvider = Provider<bool>((ref) {
  final password = ref.watch(passwordProvider);
  return !password.isValidPassword && password.isNotBlank;
});

// Form validity provider
final isFormValidProvider = Provider<bool>((ref) {
  final username = ref.watch(usernameProvider);
  final password = ref.watch(passwordProvider);
  return username.isValidUsername && password.isValidPassword;
});

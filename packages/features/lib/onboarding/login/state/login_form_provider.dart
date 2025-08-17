import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readian_domain/domain.dart';

// State providers for form fields
final emailProvider = StateProvider<String>((ref) => '');
final passwordProvider = StateProvider<String>((ref) => '');

// Derived state providers for validation
final hasEmailErrorProvider = Provider<bool>((ref) {
  final email = ref.watch(emailProvider);
  return !email.isValidEmail && email.isNotBlank;
});

final hasPasswordErrorProvider = Provider<bool>((ref) {
  final password = ref.watch(passwordProvider);
  return !password.isValidPassword && password.isNotBlank;
});

// Form validity provider
final isFormValidProvider = Provider<bool>((ref) {
  final email = ref.watch(emailProvider);
  final password = ref.watch(passwordProvider);
  return email.isValidEmail && password.isValidPassword;
});

import '../../entities/result/registration_result.dart';
import '../../repositories/readian_auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<RegistrationResult> call({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (email.isEmpty || password.isEmpty || username.isEmpty || confirmPassword.isEmpty) {
      return const RegistrationResult.error();
    }

    if (password != confirmPassword) {
      return const RegistrationResult.problem(problems: ['Passwords do not match']);
    }

    return await _authRepository.register(username, email, password, confirmPassword);
  }
}

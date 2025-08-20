import '../../repositories/auth_repository.dart';
import '../../entities/result/registration_result.dart';

class RegisterUseCase {
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);

  Future<RegistrationResult> call({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _authRepository.register(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}

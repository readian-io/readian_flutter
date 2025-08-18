import '../../entities/result/login_result.dart';
import '../../repositories/readian_auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<LoginResult> call(String identifier, String password) async {
    if (identifier.isEmpty || password.isEmpty) {
      return const LoginResult.error();
    }

    return await _authRepository.login(identifier, password);
  }
}

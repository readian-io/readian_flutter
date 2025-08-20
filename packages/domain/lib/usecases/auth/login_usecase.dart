import '../../repositories/auth_repository.dart';
import '../../entities/result/login_result.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<LoginResult> call(String identifier, String password) async {
    return await _authRepository.login(identifier, password);
  }
}

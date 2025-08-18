import '../entities/result/login_result.dart';
import '../entities/result/registration_result.dart';
import '../entities/result/refresh_token_result.dart';
import '../entities/result/anon_reg_result.dart';

abstract class AuthRepository {
  Future<LoginResult> login(String identifier, String password);
  
  Future<RegistrationResult> register(
    String username,
    String email,
    String password,
    String confirmPassword,
  );
  
  Future<RefreshTokenResult> refreshToken(String refreshToken, String accessToken);
  
  Future<AnonRegResult> registerAnonymous();
}

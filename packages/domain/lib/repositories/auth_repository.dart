import '../entities/result/login_result.dart';
import '../entities/result/registration_result.dart';
import '../entities/result/refresh_token_result.dart';
import '../entities/result/anon_reg_result.dart';

/// Abstract repository interface for authentication operations
/// This belongs in the domain layer and defines contracts for data layer implementations
abstract class AuthRepository {
  Future<LoginResult> login(String identifier, String password);
  
  Future<RegistrationResult> register({
    required String username,
    required String email, 
    required String password,
    required String confirmPassword,
  });
  
  Future<RefreshTokenResult> refreshToken(String refreshToken, String accessToken);
  
  Future<AnonRegResult> registerAnonymous();
}
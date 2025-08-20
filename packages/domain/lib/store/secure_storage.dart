import 'package:readian_domain/entities/auth_result.dart';

abstract class SecureStorage {
  Future<void> storeAuthResult(AuthResult authResult);
  Future<AuthResult?> getAuthResult();
  Future<void> storeTempToken(String tempToken);
  Future<String?> getTempToken();
  Future<void> clearAuthData();
  Future<void> storeAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> storeRefreshToken(String token);
  Future<String?> getRefreshToken();
}

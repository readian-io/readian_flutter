import '../entities/authentication_state.dart';
import '../entities/auth_token.dart';

abstract class AuthenticationStore {
  Stream<AuthenticationState> get state;
  AuthenticationState get currentState;
  
  Future<void> persistToken(AuthToken token);
  Future<AuthenticationState?> refresh(String refreshToken, String accessToken);
  Future<void> clear();
}

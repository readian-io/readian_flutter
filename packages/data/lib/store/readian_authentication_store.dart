import 'dart:async';
import 'package:readian_domain/entities/authentication_state.dart';
import 'package:readian_domain/entities/auth_token.dart';
import 'package:readian_domain/repositories/auth_repository.dart';
import 'package:readian_domain/store/authentication_store.dart';
import 'package:readian_domain/store/secure_storage.dart';

class ReadianAuthenticationStore implements AuthenticationStore {
  final SecureStorage _persistence;
  final AuthRepository _dataRepository;
  
  late final StreamController<AuthenticationState> _stateController;
  AuthenticationState _currentState = const AuthenticationState.unauthenticated();

  ReadianAuthenticationStore(this._persistence, this._dataRepository) {
    _stateController = StreamController<AuthenticationState>.broadcast();
    _initializeState();
  }

  @override
  Stream<AuthenticationState> get state => _stateController.stream;

  @override
  AuthenticationState get currentState => _currentState;

  Future<void> _initializeState() async {
    final initialState = await _getInitialState();
    _updateState(initialState);
  }

  @override
  Future<void> persistToken(AuthToken token) async {
    await _persistence.storeAccessToken(token.accessToken);
    await _persistence.storeRefreshToken(token.refreshToken);
    
    final newState = AuthenticationState.authenticated(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
    );
    _updateState(newState);
  }

  @override
  Future<AuthenticationState?> refresh(String refreshToken, String accessToken) async {
    final dataResult = await _dataRepository.refreshToken(refreshToken, accessToken);
    
    return dataResult.when(
      success: (authResult) async {
        await persistToken(authResult);
        final newState = AuthenticationState.authenticated(
          accessToken: authResult.accessToken,
          refreshToken: authResult.refreshToken,
        );
        return newState;
      },
      failure: (domainError) async {
        if (domainError.name.contains('Invalid') || domainError.name.contains('invalid')) {
          await clear();
        }
        
        return const AuthenticationState.unauthenticated();
      },
    );
  }

  @override
  Future<void> clear() async {
    await _persistence.clearAuthData();
    _updateState(const AuthenticationState.unauthenticated());
  }

  Future<AuthenticationState> _getInitialState() async {
    final accessToken = await _persistence.getAccessToken();
    final refreshToken = await _persistence.getRefreshToken();
    
    return _asAuthenticationState(accessToken, refreshToken);
  }

  AuthenticationState _asAuthenticationState(String? accessToken, String? refreshToken) {
    if (accessToken == null || accessToken.isEmpty ||
        refreshToken == null || refreshToken.isEmpty) {
      return const AuthenticationState.unauthenticated();
    } else {
      return AuthenticationState.authenticated(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  void _updateState(AuthenticationState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  void dispose() {
    _stateController.close();
  }
}
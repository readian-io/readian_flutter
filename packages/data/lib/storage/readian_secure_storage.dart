import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:readian_domain/entities/auth_result.dart';
import 'package:readian_domain/entities/auth_token.dart';
import 'package:readian_domain/entities/user_entity.dart';
import 'secure_storage.dart';

class ReadianSecureStorage implements SecureStorage {
  final FlutterSecureStorage _storage;

  const ReadianSecureStorage(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tempTokenKey = 'temp_token';
  static const String _userKey = 'user_data';
  static const String _tokenExpiryKey = 'token_expiry';

  @override
  Future<void> storeAuthResult(AuthResult authResult) async {
    await storeAccessToken(authResult.token.accessToken);
    await storeRefreshToken(authResult.token.refreshToken);

    if (authResult.token.expiresAt != null) {
      await _storage.write(
        key: _tokenExpiryKey,
        value: authResult.token.expiresAt!.toIso8601String(),
      );
    }

    final userJson = {
      'id': authResult.user.id,
      'email': authResult.user.email,
      'username': authResult.user.username,
      'fullName': authResult.user.fullName,
      'avatarUrl': authResult.user.avatarUrl,
    };
    await _storage.write(key: _userKey, value: jsonEncode(userJson));
  }

  @override
  Future<AuthResult?> getAuthResult() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    final userData = await _storage.read(key: _userKey);

    if (accessToken == null || refreshToken == null || userData == null) {
      return null;
    }

    final userMap = jsonDecode(userData) as Map<String, dynamic>;
    final expiryString = await _storage.read(key: _tokenExpiryKey);
    
    final token = AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: expiryString != null ? DateTime.parse(expiryString) : null,
    );

    final user = UserEntity(
      id: userMap['id'] as String,
      email: userMap['email'] as String,
      username: userMap['username'] as String,
      fullName: userMap['fullName'] as String?,
      avatarUrl: userMap['avatarUrl'] as String?,
    );

    return AuthResult(token: token, user: user);
  }

  @override
  Future<void> storeTempToken(String tempToken) async {
    await _storage.write(key: _tempTokenKey, value: tempToken);
  }

  @override
  Future<String?> getTempToken() async {
    return await _storage.read(key: _tempTokenKey);
  }

  @override
  Future<void> clearAuthData() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _tempTokenKey);
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _tokenExpiryKey);
  }

  @override
  Future<void> storeAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  @override
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  @override
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }
}

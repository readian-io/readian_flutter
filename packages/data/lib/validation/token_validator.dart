import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class TokenValidator {
  static const int _tokenExpiryLeewaySeconds = 0;

  bool isTokenExpired(String token) {
    try {
      final jwt = JWT.decode(token);
      final exp = jwt.payload['exp'] as int?;
      if (exp == null) return true;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expiryWithLeeway = exp - _tokenExpiryLeewaySeconds;
      
      return now >= expiryWithLeeway;
    } catch (e) {
      return true;
    }
  }

  /// Alternative implementation that doesn't verify signature
  /// (matches your Kotlin implementation more closely)
  bool isTokenExpiredWithoutVerification(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return true;

      final payload = parts[1];
      
      // Add padding if needed for base64 decoding
      String normalized = base64.normalize(payload);
      final decoded = base64.decode(normalized);
      final payloadMap = jsonDecode(utf8.decode(decoded)) as Map<String, dynamic>;
      
      // Get expiry time
      final exp = payloadMap['exp'] as int?;
      if (exp == null) return true;
      
      // Check if expired
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final expiryWithLeeway = exp - _tokenExpiryLeewaySeconds;
      
      return now >= expiryWithLeeway;
    } catch (e) {
      return true;
    }
  }
}

import '../errors/auth_data_error.dart';

class InputValidator {
  static const int _minPasswordLength = 8;
  static const int _maxPasswordLength = 128;
  static const int _minUsernameLength = 3;
  static const int _maxUsernameLength = 30;

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email) && email.length <= 254;
  }

  static bool isValidPassword(String password) {
    if (password.length < _minPasswordLength || 
        password.length > _maxPasswordLength) {
      return false;
    }
    
    // Check for at least one letter and one number
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    
    return hasLetter && hasNumber;
  }

  static bool isValidUsername(String username) {
    if (username.length < _minUsernameLength || 
        username.length > _maxUsernameLength) {
      return false;
    }
    
    // Allow alphanumeric characters, underscores, and hyphens
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username);
  }

  static String sanitizeInput(String input) {
    // Remove leading/trailing whitespace and null characters
    return input.trim().replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
  }

  static bool isValidIdentifier(String identifier) {
    final sanitized = sanitizeInput(identifier);
    return isValidEmail(sanitized) || isValidUsername(sanitized);
  }

  static ValidationDataError? validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationDataError.passwordEmpty;
    }
    
    if (password.length < _minPasswordLength) {
      return ValidationDataError.passwordTooShort;
    }
    
    if (password.length > _maxPasswordLength) {
      return ValidationDataError.passwordTooLong;
    }
    
    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      return ValidationDataError.passwordMissingLetter;
    }
    
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return ValidationDataError.passwordMissingNumber;
    }
    
    return null;
  }

  static ValidationDataError? validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationDataError.emailEmpty;
    }
    
    if (!isValidEmail(email)) {
      return ValidationDataError.emailInvalid;
    }
    
    return null;
  }

  static ValidationDataError? validateUsername(String username) {
    if (username.isEmpty) {
      return ValidationDataError.usernameEmpty;
    }
    
    if (!isValidUsername(username)) {
      return ValidationDataError.usernameInvalid;
    }
    
    return null;
  }
}

class ValidationUtils {
  static const String _passwordPattern =
      r'^(?=.*[0-9])(?=.*[!@#$%^&*()])[a-zA-Z0-9!@#$%^&*()]{8,}$';
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  static final RegExp _passwordRegExp = RegExp(_passwordPattern);

  static bool isValidEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String? password) {
    if (password == null || password.isEmpty) return false;
    return _passwordRegExp.hasMatch(password);
  }
}

extension StringValidation on String? {
  bool get isValidEmail => ValidationUtils.isValidEmail(this);
  bool get isValidPassword => ValidationUtils.isValidPassword(this);
  bool get isNotBlank => this != null && this!.trim().isNotEmpty;
}

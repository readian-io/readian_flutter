enum LoginDataError {
  invalidCredentials,
  networkFailure,
  serverError,
  invalidRequestFormat,
  emptyCredentials,
  invalidIdentifierFormat,
  connectionTimeout,
  unknownError,
}

enum RegistrationDataError {
  validationFailure,
  duplicateCredentials,
  invalidRequestFormat,
  networkFailure,
  serverError,
  connectionTimeout,
  unknownError,
}

enum ValidationDataError {
  passwordEmpty,
  passwordTooShort,
  passwordTooLong,
  passwordMissingLetter,
  passwordMissingNumber,
  emailEmpty,
  emailInvalid,
  usernameEmpty,
  usernameInvalid,
  passwordsNoMatch,
}

enum RefreshTokenDataError {
  invalidRefreshToken,
  networkFailure,
  serverError,
  connectionTimeout,
  unknownError,
}

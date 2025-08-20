enum LoginDomainError {
  wrongCredentials,
  connectionIssue,
  serverUnavailable,
  invalidInput,
  credentialsRequired,
  invalidIdentifierFormat,
  timeout,
  unknownError,
}

enum RegistrationDomainError {
  validationFailure,
  credentialsAlreadyExist,
  invalidData,
  connectionIssue,
  serverUnavailable,
  timeout,
  unknownError,
}

enum ValidationDomainError {
  passwordEmpty,
  passwordTooShort,
  passwordTooLong,
  passwordWeakFormat,
  emailEmpty,
  emailInvalidFormat,
  usernameEmpty,
  usernameInvalidFormat,
  passwordsDoNotMatch,
}

enum RefreshTokenDomainError {
  tokenInvalid,
  connectionIssue,
  serverUnavailable,
  timeout,
  unknownError,
}

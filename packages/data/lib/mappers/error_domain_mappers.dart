import '../errors/auth_data_error.dart';
import 'package:readian_domain/errors/auth_domain_error.dart';

class ErrorDomainMappers {
  static LoginDomainError mapLoginDataToDomain(LoginDataError dataError) {
    return switch (dataError) {
      LoginDataError.invalidCredentials => LoginDomainError.wrongCredentials,
      LoginDataError.networkFailure => LoginDomainError.connectionIssue,
      LoginDataError.serverError => LoginDomainError.serverUnavailable,
      LoginDataError.invalidRequestFormat => LoginDomainError.invalidInput,
      LoginDataError.emptyCredentials => LoginDomainError.credentialsRequired,
      LoginDataError.invalidIdentifierFormat => LoginDomainError.invalidIdentifierFormat,
      LoginDataError.connectionTimeout => LoginDomainError.timeout,
      LoginDataError.unknownError => LoginDomainError.unknownError,
    };
  }

  static RegistrationDomainError mapRegistrationDataToDomain(RegistrationDataError dataError) {
    return switch (dataError) {
      RegistrationDataError.validationFailure => RegistrationDomainError.validationFailure,
      RegistrationDataError.duplicateCredentials => RegistrationDomainError.credentialsAlreadyExist,
      RegistrationDataError.invalidRequestFormat => RegistrationDomainError.invalidData,
      RegistrationDataError.networkFailure => RegistrationDomainError.connectionIssue,
      RegistrationDataError.serverError => RegistrationDomainError.serverUnavailable,
      RegistrationDataError.connectionTimeout => RegistrationDomainError.timeout,
      RegistrationDataError.unknownError => RegistrationDomainError.unknownError,
    };
  }

  static List<ValidationDomainError> mapValidationDataToDomain(List<ValidationDataError> dataErrors) {
    return dataErrors.map((error) => switch (error) {
      ValidationDataError.passwordEmpty => ValidationDomainError.passwordEmpty,
      ValidationDataError.passwordTooShort => ValidationDomainError.passwordTooShort,
      ValidationDataError.passwordTooLong => ValidationDomainError.passwordTooLong,
      ValidationDataError.passwordMissingLetter => ValidationDomainError.passwordWeakFormat,
      ValidationDataError.passwordMissingNumber => ValidationDomainError.passwordWeakFormat,
      ValidationDataError.emailEmpty => ValidationDomainError.emailEmpty,
      ValidationDataError.emailInvalid => ValidationDomainError.emailInvalidFormat,
      ValidationDataError.usernameEmpty => ValidationDomainError.usernameEmpty,
      ValidationDataError.usernameInvalid => ValidationDomainError.usernameInvalidFormat,
      ValidationDataError.passwordsNoMatch => ValidationDomainError.passwordsDoNotMatch,
    }).toList();
  }

  static RefreshTokenDomainError mapRefreshTokenDataToDomain(RefreshTokenDataError dataError) {
    return switch (dataError) {
      RefreshTokenDataError.invalidRefreshToken => RefreshTokenDomainError.tokenInvalid,
      RefreshTokenDataError.networkFailure => RefreshTokenDomainError.connectionIssue,
      RefreshTokenDataError.serverError => RefreshTokenDomainError.serverUnavailable,
      RefreshTokenDataError.connectionTimeout => RefreshTokenDomainError.timeout,
      RefreshTokenDataError.unknownError => RefreshTokenDomainError.unknownError,
    };
  }
}
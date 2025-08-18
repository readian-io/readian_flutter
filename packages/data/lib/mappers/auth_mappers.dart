import 'package:readian_domain/entities/auth_result.dart';
import 'package:readian_domain/entities/auth_token.dart';
import 'package:readian_domain/entities/user_entity.dart';
import '../models/auth/login_response_data.dart';
import '../models/user.dart';

extension LoginResponseDataMapper on LoginResponseData {
  AuthResult toEntity() {
    return AuthResult(
      token: AuthToken(
        accessToken: data.token.accessToken,
        refreshToken: data.token.refreshToken,
      ),
      user: data.user.toEntity(),
    );
  }
}

extension UserResponseDataModelMapper on UserResponseDataModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email ?? '',
      username: username,
      fullName: name,
      avatarUrl: null,
    );
  }
}

extension UserMapper on User {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }
}

extension UserEntityMapper on UserEntity {
  User toModel() {
    return User(
      id: id,
      email: email,
      username: username,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
  }
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_data.freezed.dart';
part 'login_response_data.g.dart';

@freezed
class LoginResponseData with _$LoginResponseData {
  const factory LoginResponseData({
    required LoginDataDataModel data,
  }) = _LoginResponseData;

  factory LoginResponseData.fromJson(Map<String, dynamic> json) => 
      _$LoginResponseDataFromJson(json);
}

@freezed
class LoginDataDataModel with _$LoginDataDataModel {
  const factory LoginDataDataModel({
    required UserResponseDataModel user,
    required TokenResponseDataModel token,
  }) = _LoginDataDataModel;

  factory LoginDataDataModel.fromJson(Map<String, dynamic> json) => 
      _$LoginDataDataModelFromJson(json);
}

@freezed
class TokenResponseDataModel with _$TokenResponseDataModel {
  const factory TokenResponseDataModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _TokenResponseDataModel;

  factory TokenResponseDataModel.fromJson(Map<String, dynamic> json) => 
      _$TokenResponseDataModelFromJson(json);
}

@freezed
class UserResponseDataModel with _$UserResponseDataModel {
  const factory UserResponseDataModel({
    required String id,
    required String username,
    String? name,
    String? email,
  }) = _UserResponseDataModel;

  factory UserResponseDataModel.fromJson(Map<String, dynamic> json) => 
      _$UserResponseDataModelFromJson(json);
}

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/auth/login_payload.dart';
import '../models/auth/register_payload.dart';
import '../models/auth/anon_reg_payload.dart';
import '../models/auth/refresh_token_payload.dart';
import '../models/auth/login_response_data.dart';
import '../models/auth/anon_reg_response.dart';

part 'onboarding_data_source.g.dart';

@RestApi()
abstract class OnboardingDataSource {
  factory OnboardingDataSource(Dio dio, {String baseUrl}) = _OnboardingDataSource;

  @POST('api/login')
  Future<LoginResponseData> login(@Body() LoginPayload payload);

  @POST('api/register')
  Future<void> registration(@Body() RegisterPayload payload);

  @POST('api/register/temp')
  Future<AnonRegResponse> anonRegistration(@Body() AnonRegPayload payload);

  @POST('api/refresh-token')
  Future<LoginResponseData> refreshToken(@Body() RefreshTokenPayload payload);
}

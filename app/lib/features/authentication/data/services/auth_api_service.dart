import 'package:app/features/authentication/data/models/auth_models.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(
    Dio dio, {
    String baseUrl,
  }) = _AuthApiService;

  @POST('/auth/login')
  Future<AuthApiResponseModel> signIn(@Body() Map<String, dynamic> body);

  @POST('/auth/register')
  Future<AuthApiResponseModel> signUp(@Body() Map<String, dynamic> body);

  @POST('/auth/social/google')
  Future<AuthApiResponseModel> signInWithGoogle(@Body() Map<String, dynamic> body);

  @POST('/auth/social/zalo')
  Future<AuthApiResponseModel> signInWithZalo(@Body() Map<String, dynamic> body);
}

import 'package:app/core/network/api_config.dart';
import 'package:app/features/authentication/data/models/auth_models.dart';
import 'package:app/features/booking/data/models/booking_api_models.dart';
import 'package:app/features/pets/data/models/pet_models.dart';
import 'package:app/features/sample_posts/data/models/sample_post_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi()
abstract class AppApiService {
  factory AppApiService(Dio dio, {String baseUrl}) = _AppApiService;

  @POST(ApiEndpoints.authLogin)
  Future<AuthApiResponseModel> signIn(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.authRegister)
  Future<AuthApiResponseModel> signUp(@Body() Map<String, dynamic> body);

  @POST(ApiEndpoints.authGoogle)
  Future<AuthApiResponseModel> signInWithGoogle(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.authZalo)
  Future<AuthApiResponseModel> signInWithZalo(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.authForgotPassword)
  Future<SimpleApiResponseModel> forgotPassword(
    @Body() Map<String, dynamic> body,
  );

  @POST(ApiEndpoints.authVerifyResetOtp)
  Future<SimpleApiResponseModel> verifyResetOtp(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiEndpoints.pets)
  Future<PetsApiResponseModel> getPets();

  @POST(ApiEndpoints.pets)
  Future<PetApiResponseModel> createPet(@Body() Map<String, dynamic> body);

  @GET(ApiEndpoints.petDetail)
  Future<PetApiResponseModel> getPet(@Path('petId') String petId);

  @GET(ApiEndpoints.bookingAvailability)
  Future<BookingAvailabilityResponseModel> getBookingAvailability(
    @Queries() Map<String, dynamic> query,
  );

  @GET(ApiEndpoints.bookings)
  Future<BookingsApiResponseModel> getBookings();

  @POST(ApiEndpoints.bookings)
  Future<BookingApiResponseModel> createBooking(
    @Body() Map<String, dynamic> body,
  );

  @GET(ApiEndpoints.bookingDetail)
  Future<BookingApiResponseModel> getBooking(
    @Path('bookingId') String bookingId,
  );

  @PATCH(ApiEndpoints.bookingCancel)
  Future<BookingApiResponseModel> cancelBooking(
    @Path('bookingId') String bookingId,
  );

  @GET(ApiEndpoints.posts)
  Future<List<SamplePostModel>> getSamplePosts();
}

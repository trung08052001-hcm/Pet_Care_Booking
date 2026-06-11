abstract final class ApiConfig {
  static const String devBaseUrl = 'http://192.168.1.29:5000/api/v1';
  static const String stgBaseUrl = 'https://stg-api.pawsitive-care.com/api/v1';
  static const String prodBaseUrl = 'https://api.pawsitive-care.com/api/v1';

  static const Duration connectTimeout = Duration(seconds: 8);
  static const Duration receiveTimeout = Duration(seconds: 12);
}

abstract final class ApiEndpoints {
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authGoogle = '/auth/social/google';
  static const String authZalo = '/auth/social/zalo';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authVerifyResetOtp = '/auth/verify-reset-otp';
  static const String authMe = '/auth/me';
  static const String authMeProfile = '/auth/me/profile';
  static const String authMePassword = '/auth/me/password';
  static const String authMeAddress = '/auth/me/address';

  static const String pets = '/pets';
  static const String petDetail = '/pets/{petId}';

  static const String bookings = '/bookings';
  static const String bookingDetail = '/bookings/{bookingId}';
  static const String bookingCancel = '/bookings/{bookingId}/cancel';
  static const String bookingAvailability = '/bookings/availability';
  static const String notificationDeviceToken = '/notifications/device-token';

  static const String posts = '/posts';
  static const String helpCenter = '/help-center';
  static const String helpCenterFeedback = '/help-center/feedback';
  static const String appReviews = '/app-reviews';
}

import 'package:app/core/network/api_config.dart';
import 'package:dio/dio.dart';

class AppReviewRemoteDataSource {
  const AppReviewRemoteDataSource(this._dio);

  final Dio _dio;

  Future<void> submitReview({
    required int rating,
    required String comment,
  }) async {
    await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.appReviews,
      data: {
        'rating': rating,
        'comment': comment,
      },
    );
  }
}

import 'package:app/features/profile/data/datasources/app_review_remote_data_source.dart';

class SubmitAppReviewUseCase {
  const SubmitAppReviewUseCase(this._dataSource);

  final AppReviewRemoteDataSource _dataSource;

  Future<void> call({
    required int rating,
    required String comment,
  }) {
    return _dataSource.submitReview(
      rating: rating,
      comment: comment,
    );
  }
}

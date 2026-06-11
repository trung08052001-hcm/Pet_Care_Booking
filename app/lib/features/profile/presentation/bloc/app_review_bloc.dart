import 'package:app/features/profile/domain/usecases/submit_app_review_usecase.dart';
import 'package:app/features/profile/presentation/bloc/app_review_event.dart';
import 'package:app/features/profile/presentation/bloc/app_review_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppReviewBloc extends Bloc<AppReviewEvent, AppReviewState> {
  AppReviewBloc(this._submitAppReviewUseCase)
      : super(const AppReviewState()) {
    on<AppReviewRatingSelected>(_onRatingSelected);
    on<AppReviewCommentChanged>(_onCommentChanged);
    on<AppReviewSubmitted>(_onSubmitted);
    on<AppReviewMessageConsumed>(_onMessageConsumed);
  }

  final SubmitAppReviewUseCase _submitAppReviewUseCase;

  void _onRatingSelected(
    AppReviewRatingSelected event,
    Emitter<AppReviewState> emit,
  ) {
    emit(
      state.copyWith(
        rating: event.rating,
        clearMessage: true,
        interaction: AppReviewInteraction.none,
      ),
    );
  }

  void _onCommentChanged(
    AppReviewCommentChanged event,
    Emitter<AppReviewState> emit,
  ) {
    emit(
      state.copyWith(
        comment: event.comment,
        clearMessage: true,
        interaction: AppReviewInteraction.none,
      ),
    );
  }

  Future<void> _onSubmitted(
    AppReviewSubmitted event,
    Emitter<AppReviewState> emit,
  ) async {
    if (state.rating <= 0) {
      emit(state.copyWith(message: 'Vui lòng chọn số sao đánh giá.'));
      return;
    }

    final comment = state.comment.trim();
    if (comment.isEmpty) {
      emit(state.copyWith(message: 'Vui lòng nhập bình luận của bạn.'));
      return;
    }

    emit(
      state.copyWith(
        status: AppReviewStatus.submitting,
        clearMessage: true,
        interaction: AppReviewInteraction.none,
      ),
    );

    try {
      await _submitAppReviewUseCase(
        rating: state.rating,
        comment: comment,
      );
      emit(
        state.copyWith(
          status: AppReviewStatus.editing,
          comment: '',
          message: 'Đã gửi đánh giá. Cảm ơn bạn đã góp ý!',
          interaction: AppReviewInteraction.submitted,
        ),
      );
    } on Exception catch (error) {
      emit(
        state.copyWith(
          status: AppReviewStatus.editing,
          message: error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  void _onMessageConsumed(
    AppReviewMessageConsumed event,
    Emitter<AppReviewState> emit,
  ) {
    emit(
      state.copyWith(
        clearMessage: true,
        interaction: AppReviewInteraction.none,
      ),
    );
  }
}

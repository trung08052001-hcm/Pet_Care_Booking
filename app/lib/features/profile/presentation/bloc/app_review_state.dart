import 'package:equatable/equatable.dart';

enum AppReviewStatus {
  editing,
  submitting,
}

enum AppReviewInteraction {
  none,
  submitted,
}

class AppReviewState extends Equatable {
  const AppReviewState({
    this.status = AppReviewStatus.editing,
    this.rating = 0,
    this.comment = '',
    this.message,
    this.interaction = AppReviewInteraction.none,
  });

  final AppReviewStatus status;
  final int rating;
  final String comment;
  final String? message;
  final AppReviewInteraction interaction;

  bool get isSubmitting => status == AppReviewStatus.submitting;

  bool get canSubmit => rating > 0 && comment.trim().isNotEmpty && !isSubmitting;

  AppReviewState copyWith({
    AppReviewStatus? status,
    int? rating,
    String? comment,
    String? message,
    AppReviewInteraction? interaction,
    bool clearMessage = false,
  }) {
    return AppReviewState(
      status: status ?? this.status,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
    );
  }

  @override
  List<Object?> get props => [
        status,
        rating,
        comment,
        message,
        interaction,
      ];
}

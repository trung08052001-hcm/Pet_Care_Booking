import 'package:equatable/equatable.dart';

sealed class AppReviewEvent extends Equatable {
  const AppReviewEvent();

  @override
  List<Object?> get props => const [];
}

final class AppReviewRatingSelected extends AppReviewEvent {
  const AppReviewRatingSelected(this.rating);

  final int rating;

  @override
  List<Object?> get props => [rating];
}

final class AppReviewCommentChanged extends AppReviewEvent {
  const AppReviewCommentChanged(this.comment);

  final String comment;

  @override
  List<Object?> get props => [comment];
}

final class AppReviewSubmitted extends AppReviewEvent {
  const AppReviewSubmitted();
}

final class AppReviewMessageConsumed extends AppReviewEvent {
  const AppReviewMessageConsumed();
}

import 'package:equatable/equatable.dart';

class BlogWeeklyTip extends Equatable {
  const BlogWeeklyTip({
    required this.badgeLabel,
    required this.body,
    required this.ctaLabel,
  });

  final String badgeLabel;
  final String body;
  final String ctaLabel;

  @override
  List<Object?> get props => [badgeLabel, body, ctaLabel];
}

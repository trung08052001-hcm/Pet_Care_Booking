import 'package:equatable/equatable.dart';

class HomePromo extends Equatable {
  const HomePromo({
    required this.badgeLabel,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
  });

  final String badgeLabel;
  final String title;
  final String subtitle;
  final String ctaLabel;

  @override
  List<Object?> get props => [badgeLabel, title, subtitle, ctaLabel];
}

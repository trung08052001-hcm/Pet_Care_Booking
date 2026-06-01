import 'package:equatable/equatable.dart';

class PetPromoBanner extends Equatable {
  const PetPromoBanner({
    required this.title,
    required this.description,
    required this.ctaLabel,
  });

  final String title;
  final String description;
  final String ctaLabel;

  @override
  List<Object?> get props => [title, description, ctaLabel];
}

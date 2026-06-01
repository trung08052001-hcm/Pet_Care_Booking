import 'package:equatable/equatable.dart';

class HomePetTip extends Equatable {
  const HomePetTip({
    required this.id,
    required this.category,
    required this.title,
    required this.imagePlaceholderColor,
    this.imageUrl,
  });

  final String id;
  final String category;
  final String title;
  final int imagePlaceholderColor;
  final String? imageUrl;

  @override
  List<Object?> get props => [
        id,
        category,
        title,
        imagePlaceholderColor,
        imageUrl,
      ];
}

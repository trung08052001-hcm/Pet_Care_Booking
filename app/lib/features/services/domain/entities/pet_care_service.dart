import 'package:app/features/services/domain/entities/service_pet_type.dart';
import 'package:equatable/equatable.dart';

class PetCareService extends Equatable {
  const PetCareService({
    required this.id,
    required this.title,
    required this.description,
    required this.priceFromVnd,
    required this.petTypes,
    required this.imagePlaceholderColor,
    this.isPopular = false,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String description;
  final int priceFromVnd;
  final List<ServicePetType> petTypes;
  final int imagePlaceholderColor;
  final bool isPopular;
  final String? imageUrl;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        priceFromVnd,
        petTypes,
        imagePlaceholderColor,
        isPopular,
        imageUrl,
      ];
}

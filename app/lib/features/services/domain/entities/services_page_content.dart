import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:equatable/equatable.dart';

class ServicesPageContent extends Equatable {
  const ServicesPageContent({
    required this.title,
    required this.subtitle,
    required this.services,
  });

  final String title;
  final String subtitle;
  final List<PetCareService> services;

  @override
  List<Object?> get props => [title, subtitle, services];
}

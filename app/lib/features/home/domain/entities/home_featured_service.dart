import 'package:equatable/equatable.dart';

enum HomeFeaturedServiceType {
  grooming,
  petHotel,
  veterinarian,
}

class HomeFeaturedService extends Equatable {
  const HomeFeaturedService({
    required this.id,
    required this.type,
    required this.label,
  });

  final String id;
  final HomeFeaturedServiceType type;
  final String label;

  @override
  List<Object?> get props => [id, type, label];
}

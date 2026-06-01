import 'package:app/features/home/domain/entities/home_featured_service.dart';
import 'package:app/features/home/domain/entities/home_pet_tip.dart';
import 'package:app/features/home/domain/entities/home_promo.dart';
import 'package:app/features/home/domain/entities/home_welcome.dart';
import 'package:equatable/equatable.dart';

class HomeDashboard extends Equatable {
  const HomeDashboard({
    required this.welcome,
    required this.featuredServices,
    required this.promo,
    required this.petTips,
    this.featuredServicesSectionTitle = 'Dịch vụ nổi bật',
    this.petTipsSectionTitle = 'Mẹo chăm sóc thú cưng',
  });

  final HomeWelcome welcome;
  final List<HomeFeaturedService> featuredServices;
  final HomePromo promo;
  final List<HomePetTip> petTips;
  final String featuredServicesSectionTitle;
  final String petTipsSectionTitle;

  @override
  List<Object?> get props => [
        welcome,
        featuredServices,
        promo,
        petTips,
        featuredServicesSectionTitle,
        petTipsSectionTitle,
      ];
}

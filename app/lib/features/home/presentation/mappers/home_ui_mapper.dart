import 'package:app/features/home/domain/entities/home_featured_service.dart';
import 'package:flutter/material.dart';

abstract final class HomeUiMapper {
  static IconData featuredServiceIcon(HomeFeaturedServiceType type) {
    return switch (type) {
      HomeFeaturedServiceType.grooming => Icons.content_cut_rounded,
      HomeFeaturedServiceType.petHotel => Icons.apartment_rounded,
      HomeFeaturedServiceType.veterinarian => Icons.medical_services_outlined,
    };
  }

  static Color tipPlaceholderColor(int argb) => Color(argb);
}

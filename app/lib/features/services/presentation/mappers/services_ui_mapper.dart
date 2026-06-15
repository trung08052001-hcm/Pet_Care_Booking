import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:flutter/material.dart';

abstract final class ServicesUiMapper {
  static String categoryLabel(ServiceCategoryFilter category) {
    return switch (category) {
      ServiceCategoryFilter.all => 'Tất cả',
      ServiceCategoryFilter.dog => 'Chó',
      ServiceCategoryFilter.cat => 'Mèo',
    };
  }

  static String subtitle(ServiceCategoryFilter category) {
    return switch (category) {
      ServiceCategoryFilter.all => 'Tận tâm nâng niu thú cưng của bạn mỗi ngày',
      ServiceCategoryFilter.dog => 'Các dịch vụ chuyên biệt dành cho chó của bạn',
      ServiceCategoryFilter.cat => 'Các dịch vụ nhẹ nhàng và an toàn dành cho mèo',
    };
  }

  static Widget categoryLeading(ServiceCategoryFilter category) {
    return switch (category) {
      ServiceCategoryFilter.all => const Icon(Icons.pets_rounded, size: 18),
      ServiceCategoryFilter.dog => const Text(
          '🐕',
          style: TextStyle(fontSize: 16, height: 1),
        ),
      ServiceCategoryFilter.cat => const Text(
          '🐈',
          style: TextStyle(fontSize: 16, height: 1),
        ),
    };
  }
}

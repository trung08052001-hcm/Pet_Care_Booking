import 'package:app/features/services/domain/entities/service_category_filter.dart';
import 'package:flutter/material.dart';

abstract final class ServicesUiMapper {
  static String formatPriceFrom(int priceVnd) {
    final digits = priceVnd.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return 'Từ $bufferđ';
  }

  static String categoryLabel(ServiceCategoryFilter category) {
    return switch (category) {
      ServiceCategoryFilter.all => 'Tất cả',
      ServiceCategoryFilter.dog => 'Chó',
      ServiceCategoryFilter.cat => 'Mèo',
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

  static Color placeholderColor(int argb) => Color(argb);
}

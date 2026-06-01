import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:app/features/booking/domain/entities/bookable_service_icon.dart';
import 'package:flutter/material.dart';

abstract final class BookingServiceUiMapper {
  static String formatPrice(int priceVnd, {String? unitSuffix}) {
    final digits = priceVnd.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    final suffix = unitSuffix ?? '';
    return '$bufferđ$suffix';
  }

  static IconData serviceIcon(BookableServiceIcon icon) {
    return switch (icon) {
      BookableServiceIcon.spa => Icons.content_cut_rounded,
      BookableServiceIcon.boarding => Icons.hotel_rounded,
      BookableServiceIcon.healthCheck => Icons.health_and_safety_outlined,
      BookableServiceIcon.walking => Icons.directions_walk_rounded,
    };
  }

  static IconData? tagIconFor(BookableService service) {
    final label = service.tagLabel?.toLowerCase() ?? '';
    if (label.contains('phút')) {
      return Icons.schedule_outlined;
    }
    if (label.contains('sao')) {
      return Icons.star_outline_rounded;
    }
    if (label.contains('bác sĩ')) {
      return Icons.medical_services_outlined;
    }
    if (label.contains('công viên')) {
      return Icons.park_outlined;
    }
    return Icons.info_outline_rounded;
  }

  static Color cardColor(int argb) => Color(argb);
}

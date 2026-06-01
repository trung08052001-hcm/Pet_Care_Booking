import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:flutter/material.dart';

abstract final class BlogUiMapper {
  static const _monthLabels = [
    '',
    'Th01',
    'Th02',
    'Th03',
    'Th04',
    'Th05',
    'Th06',
    'Th07',
    'Th08',
    'Th09',
    'Th10',
    'Th11',
    'Th12',
  ];

  static String categoryLabel(BlogCategoryFilter category) {
    return switch (category) {
      BlogCategoryFilter.all => 'Tất cả',
      BlogCategoryFilter.nutrition => 'Dinh dưỡng',
      BlogCategoryFilter.health => 'Sức khỏe',
      BlogCategoryFilter.training => 'Huấn luyện',
    };
  }

  static List<BlogCategoryFilter> get filterChips => const [
        BlogCategoryFilter.all,
        BlogCategoryFilter.nutrition,
        BlogCategoryFilter.health,
        BlogCategoryFilter.training,
      ];

  static String formatPublishedDate(DateTime date) {
    final month = date.month;
    final label = month >= 1 && month <= 12 ? _monthLabels[month] : 'Th??';
    return '${date.day.toString().padLeft(2, '0')} $label';
  }

  static String formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      final value = count / 1000;
      final text = value >= 10
          ? value.toStringAsFixed(0)
          : value.toStringAsFixed(1);
      return '${text}k';
    }
    return count.toString();
  }

  static String formatReadTime(int minutes) => '$minutes phút đọc';

  static Color placeholderColor(int argb) => Color(argb);
}

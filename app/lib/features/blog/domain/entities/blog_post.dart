import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:equatable/equatable.dart';

class BlogPost extends Equatable {
  const BlogPost({
    required this.id,
    required this.title,
    required this.category,
    required this.categoryLabel,
    required this.imagePlaceholderColor,
    required this.publishedAt,
    required this.viewCount,
    this.readTimeMinutes,
    this.authorName,
    this.imageUrl,
  });

  final String id;
  final String title;
  final BlogCategoryFilter category;
  final String categoryLabel;
  final int imagePlaceholderColor;
  final DateTime publishedAt;
  final int viewCount;
  final int? readTimeMinutes;
  final String? authorName;
  final String? imageUrl;

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        categoryLabel,
        imagePlaceholderColor,
        publishedAt,
        viewCount,
        readTimeMinutes,
        authorName,
        imageUrl,
      ];
}

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
    this.slug,
    this.shortDescription,
    this.publishedDateLabel,
    this.readTimeLabel,
    this.intro,
    this.sections = const [],
    this.tip,
    this.conclusion,
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
  final String? slug;
  final String? shortDescription;
  final String? publishedDateLabel;
  final String? readTimeLabel;
  final String? intro;
  final List<BlogPostSection> sections;
  final String? tip;
  final String? conclusion;

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
        slug,
        shortDescription,
        publishedDateLabel,
        readTimeLabel,
        intro,
        sections,
        tip,
        conclusion,
      ];
}

class BlogPostSection extends Equatable {
  const BlogPostSection({
    required this.heading,
    required this.body,
  });

  final String heading;
  final String body;

  @override
  List<Object?> get props => [heading, body];
}

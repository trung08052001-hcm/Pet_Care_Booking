import 'package:app/core/network/api_config.dart';
import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/entities/blog_social.dart';
import 'package:dio/dio.dart';

class BlogRemoteDataSource {
  const BlogRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<BlogPost>> getPosts({
    int limit = 5,
    BlogCategoryFilter category = BlogCategoryFilter.all,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.blogPosts,
      queryParameters: {
        'limit': limit,
        if (category != BlogCategoryFilter.all)
          'mainCategory': _mainCategoryValue(category),
      },
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final articles = data['articles'];
      if (articles is List) {
        return articles
            .whereType<Map<String, dynamic>>()
            .map(_postFromJson)
            .toList(growable: false);
      }
    }

    throw StateError('Invalid blog posts response.');
  }

  Future<BlogSocial> getSocial(String articleId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.blogPosts}/$articleId/social',
    );
    return _socialFromResponse(response.data);
  }

  Future<BlogSocial> toggleLike(String articleId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiEndpoints.blogPosts}/$articleId/likes',
    );
    return _socialFromResponse(response.data);
  }

  Future<BlogSocial> addComment(String articleId, String body) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiEndpoints.blogPosts}/$articleId/comments',
      data: {'body': body},
    );
    return _socialFromResponse(response.data);
  }

  Future<BlogSocial> registerShare(String articleId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${ApiEndpoints.blogPosts}/$articleId/shares',
    );
    return _socialFromResponse(response.data);
  }

  BlogPost _postFromJson(Map<String, dynamic> json) {
    final content = json['content'];
    final contentMap =
        content is Map ? Map<String, dynamic>.from(content) : const <String, dynamic>{};
    final sections = contentMap['sections'];
    final category = _categoryFromMainCategory(json['mainCategory']);
    final readTimeLabel = (json['readTime'] ?? '').toString();

    return BlogPost(
      id: (json['slug'] ?? json['sourceId'] ?? json['id'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      category: category,
      categoryLabel: (json['mainCategory'] ?? json['category'] ?? '').toString().toUpperCase(),
      imagePlaceholderColor: _placeholderColor(category),
      publishedAt: _publishedDateFromLabel((json['publishedDate'] ?? '').toString()),
      publishedDateLabel: (json['publishedDate'] ?? '').toString(),
      viewCount: 0,
      readTimeMinutes: _minutesFromReadTime(readTimeLabel),
      readTimeLabel: readTimeLabel,
      authorName: (json['author'] ?? '').toString(),
      imageUrl: (json['image'] ?? '').toString(),
      shortDescription: (json['shortDescription'] ?? '').toString(),
      intro: (contentMap['intro'] ?? '').toString(),
      sections: sections is List
          ? sections
              .whereType<Map<String, dynamic>>()
              .map(
                (section) => BlogPostSection(
                  heading: (section['heading'] ?? '').toString(),
                  body: (section['body'] ?? '').toString(),
                  imageUrl: (section['image'] ?? '').toString(),
                ),
              )
              .toList(growable: false)
          : const [],
      tip: (contentMap['tip'] ?? '').toString(),
      conclusion: (contentMap['conclusion'] ?? '').toString(),
    );
  }

  BlogCategoryFilter _categoryFromMainCategory(Object? value) {
    return switch (value?.toString().toLowerCase()) {
      'dinh dưỡng' => BlogCategoryFilter.nutrition,
      'sức khỏe' => BlogCategoryFilter.health,
      'huấn luyện' => BlogCategoryFilter.training,
      _ => BlogCategoryFilter.all,
    };
  }

  String _mainCategoryValue(BlogCategoryFilter category) {
    return switch (category) {
      BlogCategoryFilter.nutrition => 'Dinh dưỡng',
      BlogCategoryFilter.health => 'Sức khỏe',
      BlogCategoryFilter.training => 'Huấn luyện',
      BlogCategoryFilter.all => '',
    };
  }

  int _placeholderColor(BlogCategoryFilter category) {
    return switch (category) {
      BlogCategoryFilter.nutrition => 0xFFF5E6D3,
      BlogCategoryFilter.health => 0xFFE8D5C4,
      BlogCategoryFilter.training => 0xFFD4E4E8,
      BlogCategoryFilter.all => 0xFFE8D5C4,
    };
  }

  DateTime _publishedDateFromLabel(String label) {
    final match = RegExp(r'(\d{1,2})\s+Thg\s+(\d{1,2}),\s+(\d{4})').firstMatch(label);
    if (match == null) {
      return DateTime(2026);
    }

    return DateTime(
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
    );
  }

  int? _minutesFromReadTime(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    if (match == null) {
      return null;
    }
    return int.tryParse(match.group(0)!);
  }

  BlogSocial _socialFromResponse(Map<String, dynamic>? response) {
    final data = response?['data'];
    final social = data is Map ? data['social'] : null;
    if (social is! Map) {
      throw StateError('Invalid blog social response.');
    }

    final comments = social['comments'];
    return BlogSocial(
      likeCount: int.tryParse((social['likeCount'] ?? 0).toString()) ?? 0,
      commentCount: int.tryParse((social['commentCount'] ?? 0).toString()) ?? 0,
      shareCount: int.tryParse((social['shareCount'] ?? 0).toString()) ?? 0,
      likedByMe: social['likedByMe'] == true,
      comments: comments is List
          ? comments
              .whereType<Map<String, dynamic>>()
              .map(
                (comment) => BlogComment(
                  id: (comment['id'] ?? '').toString(),
                  userId: (comment['userId'] ?? '').toString(),
                  userName: (comment['userName'] ?? 'Người dùng').toString(),
                  userAvatar: (comment['userAvatar'] ?? '').toString(),
                  body: (comment['body'] ?? '').toString(),
                  createdAt: DateTime.tryParse(
                        (comment['createdAt'] ?? '').toString(),
                      ) ??
                      DateTime.now(),
                ),
              )
              .toList(growable: false)
          : const [],
    );
  }
}

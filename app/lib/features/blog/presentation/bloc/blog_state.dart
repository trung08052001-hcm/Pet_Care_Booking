import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:equatable/equatable.dart';

enum BlogStatus {
  initial,
  loading,
  success,
  failure,
}

enum BlogInteraction {
  none,
  notifications,
  featuredPost,
  post,
  seeAllPosts,
  weeklyTip,
}

class BlogState extends Equatable {
  const BlogState({
    this.status = BlogStatus.initial,
    this.content,
    this.selectedCategory = BlogCategoryFilter.all,
    this.searchQuery = '',
    this.visibleFeatured,
    this.visibleLatestPosts = const [],
    this.message,
    this.interaction = BlogInteraction.none,
    this.selectedPostId,
  });

  final BlogStatus status;
  final BlogPageContent? content;
  final BlogCategoryFilter selectedCategory;
  final String searchQuery;
  final BlogPost? visibleFeatured;
  final List<BlogPost> visibleLatestPosts;
  final String? message;
  final BlogInteraction interaction;
  final String? selectedPostId;

  bool get isLoading =>
      status == BlogStatus.loading || status == BlogStatus.initial;

  BlogState copyWith({
    BlogStatus? status,
    BlogPageContent? content,
    BlogCategoryFilter? selectedCategory,
    String? searchQuery,
    BlogPost? visibleFeatured,
    List<BlogPost>? visibleLatestPosts,
    String? message,
    BlogInteraction? interaction,
    String? selectedPostId,
    bool clearMessage = false,
    bool clearSelection = false,
    bool clearFeatured = false,
  }) {
    return BlogState(
      status: status ?? this.status,
      content: content ?? this.content,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      visibleFeatured: clearFeatured ? null : (visibleFeatured ?? this.visibleFeatured),
      visibleLatestPosts: visibleLatestPosts ?? this.visibleLatestPosts,
      message: clearMessage ? null : (message ?? this.message),
      interaction: interaction ?? this.interaction,
      selectedPostId:
          clearSelection ? null : (selectedPostId ?? this.selectedPostId),
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        selectedCategory,
        searchQuery,
        visibleFeatured,
        visibleLatestPosts,
        message,
        interaction,
        selectedPostId,
      ];
}

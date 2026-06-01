import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:equatable/equatable.dart';

sealed class BlogEvent extends Equatable {
  const BlogEvent();

  @override
  List<Object?> get props => const [];
}

final class BlogStarted extends BlogEvent {
  const BlogStarted();
}

final class BlogRefreshRequested extends BlogEvent {
  const BlogRefreshRequested();
}

final class BlogCategoryFilterChanged extends BlogEvent {
  const BlogCategoryFilterChanged(this.category);

  final BlogCategoryFilter category;

  @override
  List<Object?> get props => [category];
}

final class BlogSearchQueryChanged extends BlogEvent {
  const BlogSearchQueryChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class BlogNotificationsPressed extends BlogEvent {
  const BlogNotificationsPressed();
}

final class BlogFeaturedPostPressed extends BlogEvent {
  const BlogFeaturedPostPressed(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class BlogPostPressed extends BlogEvent {
  const BlogPostPressed(this.postId);

  final String postId;

  @override
  List<Object?> get props => [postId];
}

final class BlogSeeAllPostsPressed extends BlogEvent {
  const BlogSeeAllPostsPressed();
}

final class BlogWeeklyTipActionPressed extends BlogEvent {
  const BlogWeeklyTipActionPressed();
}

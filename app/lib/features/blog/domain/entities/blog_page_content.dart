import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/entities/blog_weekly_tip.dart';
import 'package:equatable/equatable.dart';

class BlogPageContent extends Equatable {
  const BlogPageContent({
    required this.searchHint,
    required this.forYouSectionTitle,
    required this.latestSectionTitle,
    required this.featuredPost,
    required this.latestPosts,
    required this.weeklyTip,
  });

  final String searchHint;
  final String forYouSectionTitle;
  final String latestSectionTitle;
  final BlogPost featuredPost;
  final List<BlogPost> latestPosts;
  final BlogWeeklyTip weeklyTip;

  @override
  List<Object?> get props => [
        searchHint,
        forYouSectionTitle,
        latestSectionTitle,
        featuredPost,
        latestPosts,
        weeklyTip,
      ];
}

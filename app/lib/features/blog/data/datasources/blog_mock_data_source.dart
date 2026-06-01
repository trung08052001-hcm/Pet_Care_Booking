import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/entities/blog_weekly_tip.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BlogMockDataSource {
  BlogPageContent getPageContent() {
    final featured = BlogPost(
      id: 'featured-nutrition-1',
      title: '5 Bí quyết giúp thú cưng ăn ngon miệng và đủ chất',
      category: BlogCategoryFilter.nutrition,
      categoryLabel: 'DINH DƯỠNG',
      imagePlaceholderColor: 0xFFC8E6C9,
      publishedAt: BlogMockDates.apr10,
      viewCount: 3200,
      readTimeMinutes: 5,
      authorName: 'Bác sĩ thú y Linh Trần',
    );

    return BlogPageContent(
      searchHint: 'Tìm kiếm kinh nghiệm chăm sóc...',
      forYouSectionTitle: 'Dành cho bạn',
      latestSectionTitle: 'Bài viết mới nhất',
      featuredPost: featured,
      latestPosts: [
        BlogPost(
          id: 'post-health-1',
          title: 'Dấu hiệu nhận biết thú cưng đang bị stress và cách xử lý',
          category: BlogCategoryFilter.health,
          categoryLabel: 'SỨC KHỎE',
          imagePlaceholderColor: 0xFFE8D5C4,
          publishedAt: BlogMockDates.apr12,
          viewCount: 1200,
        ),
        BlogPost(
          id: 'post-training-1',
          title: 'Huấn luyện cơ bản cho chó con trong 30 ngày đầu',
          category: BlogCategoryFilter.training,
          categoryLabel: 'HUẤN LUYỆN',
          imagePlaceholderColor: 0xFFD4E4E8,
          publishedAt: BlogMockDates.apr08,
          viewCount: 890,
        ),
        BlogPost(
          id: 'post-nutrition-2',
          title: 'Thực đơn mẫu cho mèo trưởng thành cân đối dinh dưỡng',
          category: BlogCategoryFilter.nutrition,
          categoryLabel: 'DINH DƯỠNG',
          imagePlaceholderColor: 0xFFF5E6D3,
          publishedAt: BlogMockDates.apr05,
          viewCount: 2100,
        ),
        BlogPost(
          id: 'post-health-2',
          title: 'Lịch tiêm phòng chuẩn cho chó và mèo năm 2026',
          category: BlogCategoryFilter.health,
          categoryLabel: 'SỨC KHỎE',
          imagePlaceholderColor: 0xFFE0E8F0,
          publishedAt: BlogMockDates.mar28,
          viewCount: 4500,
        ),
      ],
      weeklyTip: const BlogWeeklyTip(
        badgeLabel: 'Mẹo hay trong tuần',
        body:
            'Đừng quên vệ sinh răng miệng cho cún 2 lần mỗi tuần để phòng tránh '
            'các bệnh về nướu và mùi hôi miệng nhé!',
        ctaLabel: 'Khám phá bộ kit vệ sinh',
      ),
    );
  }
}

abstract final class BlogMockDates {
  static final apr12 = DateTime(2026, 4, 12);
  static final apr10 = DateTime(2026, 4, 10);
  static final apr08 = DateTime(2026, 4, 8);
  static final apr05 = DateTime(2026, 4, 5);
  static final mar28 = DateTime(2026, 3, 28);
}

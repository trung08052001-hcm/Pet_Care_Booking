import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/blog/data/datasources/blog_mock_data_source.dart';
import 'package:app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/entities/blog_weekly_tip.dart';
import 'package:app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BlogRepository)
class BlogRepositoryImpl implements BlogRepository {
  BlogRepositoryImpl(
    this._mockDataSource, [
    this._remoteDataSource,
    this._networkInfo,
  ]);

  final BlogMockDataSource _mockDataSource;
  final BlogRemoteDataSource? _remoteDataSource;
  final NetworkInfo? _networkInfo;

  @override
  ResultFuture<BlogPageContent> getBlogPageContent() async {
    try {
      final fallback = _mockDataSource.getPageContent();
      final remoteDataSource = _remoteDataSource;
      if (remoteDataSource == null ||
          (_networkInfo != null && !await _networkInfo.isConnected)) {
        return Right(fallback);
      }

      final posts = await remoteDataSource.getPosts(limit: 40);
      if (posts.isEmpty) {
        return Right(fallback);
      }

      return Right(
        BlogPageContent(
          searchHint: fallback.searchHint,
          forYouSectionTitle: fallback.forYouSectionTitle,
          latestSectionTitle: fallback.latestSectionTitle,
          featuredPost: posts.first,
          latestPosts: posts.skip(1).toList(growable: false),
          weeklyTip: const BlogWeeklyTip(
            badgeLabel: 'Mẹo hay trong tuần',
            body:
                'Theo dõi Blog PawSitive Care mỗi ngày để cập nhật thêm kiến thức chăm sóc thú cưng hữu ích.',
            ctaLabel: 'Khám phá thêm',
          ),
        ),
      );
    } on Exception catch (exception, stackTrace) {
      final fallback = _mockDataSource.getPageContent();
      if (fallback.latestPosts.isNotEmpty) {
        return Right(fallback);
      }

      return Left(FailureMapper.fromException(exception, stackTrace: stackTrace));
    }
  }
}

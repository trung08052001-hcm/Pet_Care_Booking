import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/blog/data/datasources/blog_mock_data_source.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/repositories/blog_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: BlogRepository)
class BlogRepositoryImpl implements BlogRepository {
  BlogRepositoryImpl(this._mockDataSource);

  final BlogMockDataSource _mockDataSource;

  @override
  ResultFuture<BlogPageContent> getBlogPageContent() async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 250));
      return Right(_mockDataSource.getPageContent());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}

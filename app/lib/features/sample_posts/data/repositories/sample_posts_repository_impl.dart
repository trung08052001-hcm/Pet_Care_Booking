import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/sample_posts/data/datasources/sample_posts_data_sources.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:app/features/sample_posts/domain/repositories/sample_posts_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SamplePostsRepository)
class SamplePostsRepositoryImpl implements SamplePostsRepository {
  SamplePostsRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  final SamplePostsRemoteDataSource _remoteDataSource;
  final SamplePostsLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<SamplePost>>> getSamplePosts() async {
    try {
      if (await _networkInfo.isConnected) {
        final models = await _remoteDataSource.getSamplePosts();
        await _localDataSource.cacheSamplePosts(models);
        return Right(
          models
              .map(
                (model) => SamplePost(
                  userId: model.userId,
                  id: model.id,
                  title: model.title,
                  body: model.body,
                ),
              )
              .toList(growable: false),
        );
      }

      final cachedModels = await _localDataSource.getCachedSamplePosts();
      return Right(
        cachedModels
            .map(
              (model) => SamplePost(
                userId: model.userId,
                id: model.id,
                title: model.title,
                body: model.body,
              ),
            )
            .toList(growable: false),
      );
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

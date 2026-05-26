import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/sample_posts/data/datasources/sample_posts_data_sources.dart';
import 'package:app/features/sample_posts/data/models/sample_post_model.dart';
import 'package:app/features/sample_posts/data/repositories/sample_posts_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSamplePostsRemoteDataSource extends Mock
    implements SamplePostsRemoteDataSource {}

class MockSamplePostsLocalDataSource extends Mock
    implements SamplePostsLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockSamplePostsRemoteDataSource remoteDataSource;
  late MockSamplePostsLocalDataSource localDataSource;
  late MockNetworkInfo networkInfo;
  late SamplePostsRepositoryImpl repository;

  const sampleModel = SamplePostModel(
    userId: 1,
    id: 1,
    title: 'Post title',
    body: 'Post body',
  );

  setUp(() {
    remoteDataSource = MockSamplePostsRemoteDataSource();
    localDataSource = MockSamplePostsLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = SamplePostsRepositoryImpl(
      remoteDataSource,
      localDataSource,
      networkInfo,
    );
  });

  test('returns remote data and caches it when online', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => true);
    when(() => remoteDataSource.getSamplePosts())
        .thenAnswer((_) async => [sampleModel]);
    when(() => localDataSource.cacheSamplePosts([sampleModel]))
        .thenAnswer((_) async {});

    final result = await repository.getSamplePosts();

    result.fold(
      (_) => fail('Expected right result.'),
      (posts) => expect(posts.first.title, sampleModel.title),
    );
    verify(() => remoteDataSource.getSamplePosts()).called(1);
    verify(() => localDataSource.cacheSamplePosts([sampleModel])).called(1);
  });

  test('returns cached data when offline', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    when(() => localDataSource.getCachedSamplePosts())
        .thenAnswer((_) async => [sampleModel]);

    final result = await repository.getSamplePosts();

    result.fold(
      (_) => fail('Expected right result.'),
      (posts) => expect(posts.first.id, sampleModel.id),
    );
    verify(() => localDataSource.getCachedSamplePosts()).called(1);
    verifyNever(() => remoteDataSource.getSamplePosts());
  });

  test('maps exception to failure', () async {
    when(() => networkInfo.isConnected).thenAnswer((_) async => false);
    when(() => localDataSource.getCachedSamplePosts()).thenThrow(
      const CacheException(message: 'No cached posts available.'),
    );

    final result = await repository.getSamplePosts();

    result.fold(
      (failure) => expect(failure.message, 'No cached posts available.'),
      (_) => fail('Expected left result.'),
    );
  });
}

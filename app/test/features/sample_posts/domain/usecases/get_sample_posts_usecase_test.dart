import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:app/features/sample_posts/domain/repositories/sample_posts_repository.dart';
import 'package:app/features/sample_posts/domain/usecases/get_sample_posts_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSamplePostsRepository extends Mock
    implements SamplePostsRepository {}

void main() {
  late MockSamplePostsRepository repository;
  late GetSamplePostsUseCase useCase;

  setUp(() {
    repository = MockSamplePostsRepository();
    useCase = GetSamplePostsUseCase(repository);
  });

  test('returns posts from repository', () async {
    const posts = [
      SamplePost(
        userId: 1,
        id: 1,
        title: 'Post title',
        body: 'Post body',
      ),
    ];

    when(() => repository.getSamplePosts())
        .thenAnswer((_) async => const Right(posts));

    final result = await useCase(const NoParams());

    result.fold(
      (_) => fail('Expected right result.'),
      (data) => expect(data, posts),
    );
    verify(() => repository.getSamplePosts()).called(1);
  });
}

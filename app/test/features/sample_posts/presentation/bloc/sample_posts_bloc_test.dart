import 'package:app/core/error/app_error.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:app/features/sample_posts/domain/usecases/get_sample_posts_usecase.dart';
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetSamplePostsUseCase extends Mock implements GetSamplePostsUseCase {}

void main() {
  late MockGetSamplePostsUseCase getSamplePostsUseCase;

  const posts = [
    SamplePost(
      userId: 1,
      id: 1,
      title: 'Post title',
      body: 'Post body',
    ),
  ];

  setUp(() {
    getSamplePostsUseCase = MockGetSamplePostsUseCase();
  });

  blocTest<SamplePostsBloc, SamplePostsState>(
    'emits loading then success when use case succeeds',
    build: () {
      when(() => getSamplePostsUseCase(const NoParams()))
          .thenAnswer((_) async => const Right(posts));
      return SamplePostsBloc(getSamplePostsUseCase);
    },
    act: (bloc) => bloc.add(const SamplePostsRequested()),
    expect: () => const [
      SamplePostsState(status: SamplePostsStatus.loading),
      SamplePostsState(
        status: SamplePostsStatus.success,
        posts: posts,
      ),
    ],
  );

  blocTest<SamplePostsBloc, SamplePostsState>(
    'emits loading then failure when use case fails',
    build: () {
      when(() => getSamplePostsUseCase(const NoParams())).thenAnswer(
        (_) async => const Left(
          Failure(message: 'Something went wrong.'),
        ),
      );
      return SamplePostsBloc(getSamplePostsUseCase);
    },
    act: (bloc) => bloc.add(const SamplePostsRequested()),
    expect: () => const [
      SamplePostsState(status: SamplePostsStatus.loading),
      SamplePostsState(
        status: SamplePostsStatus.failure,
        message: 'Something went wrong.',
      ),
    ],
  );
}

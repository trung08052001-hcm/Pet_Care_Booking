import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';
import 'package:app/features/sample_posts/domain/repositories/sample_posts_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSamplePostsUseCase implements UseCase<List<SamplePost>, NoParams> {
  GetSamplePostsUseCase(this._repository);

  final SamplePostsRepository _repository;

  @override
  ResultFuture<List<SamplePost>> call(NoParams params) {
    return _repository.getSamplePosts();
  }
}

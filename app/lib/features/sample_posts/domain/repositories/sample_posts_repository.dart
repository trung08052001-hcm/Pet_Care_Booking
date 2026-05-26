import 'package:app/core/common/typedefs.dart';
import 'package:app/features/sample_posts/domain/entities/sample_post.dart';

abstract interface class SamplePostsRepository {
  ResultFuture<List<SamplePost>> getSamplePosts();
}

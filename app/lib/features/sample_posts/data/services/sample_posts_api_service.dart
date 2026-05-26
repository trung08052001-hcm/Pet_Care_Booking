import 'package:app/features/sample_posts/data/models/sample_post_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'sample_posts_api_service.g.dart';

@RestApi()
abstract class SamplePostsApiService {
  factory SamplePostsApiService(
    Dio dio, {
    String baseUrl,
  }) = _SamplePostsApiService;

  @GET('/posts')
  Future<List<SamplePostModel>> getSamplePosts();
}

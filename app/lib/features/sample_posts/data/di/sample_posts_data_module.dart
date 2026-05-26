import 'package:app/core/config/app_config.dart';
import 'package:app/features/sample_posts/data/services/sample_posts_api_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class SamplePostsDataModule {
  @lazySingleton
  SamplePostsApiService samplePostsApiService(
    Dio dio,
    AppConfig appConfig,
  ) {
    return SamplePostsApiService(
      dio,
      baseUrl: appConfig.baseUrl,
    );
  }
}

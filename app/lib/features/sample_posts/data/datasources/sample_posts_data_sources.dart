import 'dart:convert';

import 'package:app/core/error/app_error.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/sample_posts/data/models/sample_post_model.dart';
import 'package:app/features/sample_posts/data/services/sample_posts_api_service.dart';
import 'package:injectable/injectable.dart';

abstract interface class SamplePostsRemoteDataSource {
  Future<List<SamplePostModel>> getSamplePosts();
}

@LazySingleton(as: SamplePostsRemoteDataSource)
class SamplePostsRemoteDataSourceImpl implements SamplePostsRemoteDataSource {
  SamplePostsRemoteDataSourceImpl(this._apiService);

  final SamplePostsApiService _apiService;

  @override
  Future<List<SamplePostModel>> getSamplePosts() {
    return _apiService.getSamplePosts();
  }
}

abstract interface class SamplePostsLocalDataSource {
  Future<void> cacheSamplePosts(List<SamplePostModel> posts);

  Future<List<SamplePostModel>> getCachedSamplePosts();
}

@LazySingleton(as: SamplePostsLocalDataSource)
class SamplePostsLocalDataSourceImpl implements SamplePostsLocalDataSource {
  SamplePostsLocalDataSourceImpl(this._preferences);

  final AppPreferences _preferences;

  @override
  Future<void> cacheSamplePosts(List<SamplePostModel> posts) async {
    final payload = jsonEncode(
      posts.map((post) => post.toJson()).toList(growable: false),
    );
    await _preferences.writeString(
      key: StorageKeys.cachedSamplePosts,
      value: payload,
    );
  }

  @override
  Future<List<SamplePostModel>> getCachedSamplePosts() async {
    final payload = _preferences.readString(StorageKeys.cachedSamplePosts);

    if (payload == null || payload.isEmpty) {
      throw const CacheException(message: 'No cached posts available.');
    }

    final decoded = jsonDecode(payload);
    if (decoded is! List<dynamic>) {
      throw const CacheException(message: 'Cached posts are corrupted.');
    }

    return decoded
        .map(
          (item) => SamplePostModel.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList(growable: false);
  }
}

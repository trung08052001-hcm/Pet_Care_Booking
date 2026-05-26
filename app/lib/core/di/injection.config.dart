// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/app/router/app_router.dart' as _i567;
import 'package:app/core/common/app_bloc_observer.dart' as _i452;
import 'package:app/core/config/app_config.dart' as _i1068;
import 'package:app/core/di/register_module.dart' as _i313;
import 'package:app/core/network/dio_factory.dart' as _i75;
import 'package:app/core/network/network_info.dart' as _i992;
import 'package:app/core/storage/storage_service.dart' as _i179;
import 'package:app/features/sample_posts/data/datasources/sample_posts_data_sources.dart'
    as _i309;
import 'package:app/features/sample_posts/data/di/sample_posts_data_module.dart'
    as _i1046;
import 'package:app/features/sample_posts/data/repositories/sample_posts_repository_impl.dart'
    as _i110;
import 'package:app/features/sample_posts/data/services/sample_posts_api_service.dart'
    as _i1031;
import 'package:app/features/sample_posts/domain/repositories/sample_posts_repository.dart'
    as _i1070;
import 'package:app/features/sample_posts/domain/usecases/get_sample_posts_usecase.dart'
    as _i25;
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart'
    as _i1061;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final samplePostsDataModule = _$SamplePostsDataModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences(),
      preResolve: true,
    );
    gh.singleton<_i1068.AppConfig>(() => registerModule.appConfig);
    gh.lazySingleton<_i567.AppRouter>(() => _i567.AppRouter());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage(),
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity());
    gh.lazySingleton<_i179.SecureStorageService>(
      () => _i179.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i974.Logger>(
      () => registerModule.logger(gh<_i1068.AppConfig>()),
    );
    gh.lazySingleton<_i179.AppPreferences>(
      () => _i179.AppPreferences(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i75.AuthInterceptor>(
      () => _i75.AuthInterceptor(gh<_i179.SecureStorageService>()),
    );
    gh.lazySingleton<_i992.NetworkInfo>(
      () => _i992.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i452.AppBlocObserver>(
      () => _i452.AppBlocObserver(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i75.ErrorLoggerInterceptor>(
      () => _i75.ErrorLoggerInterceptor(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i75.NetworkLoggerInterceptor>(
      () => _i75.NetworkLoggerInterceptor(
        gh<_i1068.AppConfig>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i75.DioFactory>(
      () => _i75.DioFactory(
        gh<_i1068.AppConfig>(),
        gh<_i75.AuthInterceptor>(),
        gh<_i75.NetworkLoggerInterceptor>(),
        gh<_i75.ErrorLoggerInterceptor>(),
      ),
    );
    gh.lazySingleton<_i309.SamplePostsLocalDataSource>(
      () => _i309.SamplePostsLocalDataSourceImpl(gh<_i179.AppPreferences>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i75.DioFactory>()),
    );
    gh.lazySingleton<_i1031.SamplePostsApiService>(
      () => samplePostsDataModule.samplePostsApiService(
        gh<_i361.Dio>(),
        gh<_i1068.AppConfig>(),
      ),
    );
    gh.lazySingleton<_i309.SamplePostsRemoteDataSource>(
      () => _i309.SamplePostsRemoteDataSourceImpl(
        gh<_i1031.SamplePostsApiService>(),
      ),
    );
    gh.lazySingleton<_i1070.SamplePostsRepository>(
      () => _i110.SamplePostsRepositoryImpl(
        gh<_i309.SamplePostsRemoteDataSource>(),
        gh<_i309.SamplePostsLocalDataSource>(),
        gh<_i992.NetworkInfo>(),
      ),
    );
    gh.factory<_i25.GetSamplePostsUseCase>(
      () => _i25.GetSamplePostsUseCase(gh<_i1070.SamplePostsRepository>()),
    );
    gh.factory<_i1061.SamplePostsBloc>(
      () => _i1061.SamplePostsBloc(gh<_i25.GetSamplePostsUseCase>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i313.RegisterModule {}

class _$SamplePostsDataModule extends _i1046.SamplePostsDataModule {}

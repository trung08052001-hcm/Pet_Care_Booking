import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injection.config.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/data/datasources/auth_data_sources.dart';
import 'package:app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:app/features/authentication/data/services/auth_api_service.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:app/features/authentication/domain/usecases/restore_session_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final GetIt getIt = GetIt.instance;
AppConfig? _currentAppConfig;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: false,
  asExtension: true,
)
Future<void> configureDependencies(AppConfig appConfig) async {
  await getIt.reset();
  _currentAppConfig = appConfig;
  await getIt.init();
  _registerAuthDependencies();
}

AppConfig get currentAppConfig {
  final appConfig = _currentAppConfig;
  if (appConfig == null) {
    throw StateError('AppConfig has not been initialized.');
  }
  return appConfig;
}

void _registerAuthDependencies() {
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(
      getIt<Dio>(),
      baseUrl: getIt<AppConfig>().baseUrl,
    ),
  );
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<AuthApiService>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      getIt<SecureStorageService>(),
      getIt<AppPreferences>(),
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<AuthLocalDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );
  getIt.registerFactory<SignInUseCase>(
    () => SignInUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignUpUseCase>(
    () => SignUpUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<SignInUseCase>(),
      getIt<SignUpUseCase>(),
      getIt<RestoreSessionUseCase>(),
    ),
  );
}

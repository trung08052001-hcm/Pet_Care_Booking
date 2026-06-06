import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injection.config.dart';
import 'package:app/core/network/api_service.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/data/datasources/auth_data_sources.dart';
import 'package:app/features/authentication/data/repositories/auth_repository_impl.dart';
import 'package:app/features/authentication/data/services/google_auth_service.dart';
import 'package:app/features/authentication/data/services/zalo_auth_service.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:app/features/authentication/domain/usecases/restore_session_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_in_with_zalo_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/booking/data/datasources/booking_appointment_mock_data_source.dart';
import 'package:app/features/booking/data/datasources/booking_confirmation_mock_data_source.dart';
import 'package:app/features/booking/data/datasources/booking_detail_local_data_source.dart';
import 'package:app/features/booking/data/repositories/booking_appointment_repository_impl.dart';
import 'package:app/features/booking/data/repositories/booking_confirmation_repository_impl.dart';
import 'package:app/features/booking/data/repositories/booking_detail_repository_impl.dart';
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart';
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart';
import 'package:app/features/booking/domain/repositories/booking_detail_repository.dart';
import 'package:app/features/booking/domain/usecases/cancel_booking_usecase.dart';
import 'package:app/features/booking/domain/usecases/get_appointment_page_content_usecase.dart';
import 'package:app/features/booking/domain/usecases/get_booking_confirmation_usecase.dart';
import 'package:app/features/booking/domain/usecases/get_booking_detail_usecase.dart';
import 'package:app/features/booking/domain/usecases/submit_booking_usecase.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_detail_bloc.dart';
import 'package:app/features/pets/data/datasources/pets_mock_data_source.dart';
import 'package:app/features/pets/data/datasources/pets_remote_data_source.dart';
import 'package:app/features/pets/data/repositories/pets_repository_impl.dart';
import 'package:app/features/pets/domain/repositories/pets_repository.dart';
import 'package:app/features/pets/domain/usecases/create_pet_usecase.dart';
import 'package:app/features/pets/domain/usecases/get_my_pets_page_content_usecase.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
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
  await _registerPetsDependencies();
  await _registerBookingDependencies();
}

AppConfig get currentAppConfig {
  final appConfig = _currentAppConfig;
  if (appConfig == null) {
    throw StateError('AppConfig has not been initialized.');
  }
  return appConfig;
}

void _registerAuthDependencies() {
  getIt.registerLazySingleton<AppApiService>(() => AppApiService(getIt<Dio>()));
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<AppApiService>()),
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
  getIt.registerFactory<SignInWithZaloUseCase>(
    () => SignInWithZaloUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<GoogleAuthService>(
    () => const GoogleAuthService(),
  );
  getIt.registerLazySingleton<ZaloAuthService>(() => const ZaloAuthService());
  getIt.registerFactory<RestoreSessionUseCase>(
    () => RestoreSessionUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthBloc>(
    () => AuthBloc(
      getIt<SignInUseCase>(),
      getIt<SignInWithGoogleUseCase>(),
      getIt<SignInWithZaloUseCase>(),
      getIt<SignUpUseCase>(),
      getIt<RestoreSessionUseCase>(),
    ),
  );
}

Future<void> _replaceRegistration<T extends Object>(
  T Function() factoryFunc, {
  bool lazySingleton = true,
}) async {
  if (getIt.isRegistered<T>()) {
    await getIt.unregister<T>();
  }

  if (lazySingleton) {
    getIt.registerLazySingleton<T>(factoryFunc);
  } else {
    getIt.registerFactory<T>(factoryFunc);
  }
}

Future<void> _registerPetsDependencies() async {
  await _replaceRegistration<PetsRemoteDataSource>(
    () => PetsRemoteDataSourceImpl(getIt<AppApiService>()),
  );
  await _replaceRegistration<PetsRepository>(
    () => PetsRepositoryImpl(
      getIt<PetsMockDataSource>(),
      getIt<PetsRemoteDataSource>(),
      getIt<NetworkInfo>(),
    ),
  );
  await _replaceRegistration<GetMyPetsPageContentUseCase>(
    () => GetMyPetsPageContentUseCase(getIt<PetsRepository>()),
    lazySingleton: false,
  );
  await _replaceRegistration<CreatePetUseCase>(
    () => CreatePetUseCase(getIt<PetsRepository>()),
    lazySingleton: false,
  );
  await _replaceRegistration<PetsBloc>(
    () => PetsBloc(
      getIt<GetMyPetsPageContentUseCase>(),
      getIt<CreatePetUseCase>(),
    ),
    lazySingleton: false,
  );
}

Future<void> _registerBookingDependencies() async {
  await _replaceRegistration<BookingAppointmentRepository>(
    () => BookingAppointmentRepositoryImpl(
      getIt<BookingAppointmentMockDataSource>(),
      getIt<AppApiService>(),
    ),
  );
  await _replaceRegistration<BookingConfirmationRepository>(
    () => BookingConfirmationRepositoryImpl(
      getIt<BookingConfirmationMockDataSource>(),
      getIt<AppApiService>(),
    ),
  );
  await _replaceRegistration<BookingDetailRepository>(
    () => BookingDetailRepositoryImpl(
      getIt<BookingDetailLocalDataSource>(),
      getIt<AppApiService>(),
    ),
  );
  await _replaceRegistration<GetAppointmentPageContentUseCase>(
    () => GetAppointmentPageContentUseCase(
      getIt<BookingAppointmentRepository>(),
    ),
    lazySingleton: false,
  );
  await _replaceRegistration<GetBookingConfirmationUseCase>(
    () => GetBookingConfirmationUseCase(
      getIt<BookingConfirmationRepository>(),
    ),
    lazySingleton: false,
  );
  await _replaceRegistration<SubmitBookingUseCase>(
    () => SubmitBookingUseCase(getIt<BookingConfirmationRepository>()),
    lazySingleton: false,
  );
  await _replaceRegistration<GetBookingDetailUseCase>(
    () => GetBookingDetailUseCase(getIt<BookingDetailRepository>()),
    lazySingleton: false,
  );
  await _replaceRegistration<CancelBookingUseCase>(
    () => CancelBookingUseCase(getIt<BookingDetailRepository>()),
    lazySingleton: false,
  );
  await _replaceRegistration<BookingAppointmentBloc>(
    () => BookingAppointmentBloc(getIt<GetAppointmentPageContentUseCase>()),
    lazySingleton: false,
  );
  await _replaceRegistration<BookingConfirmationBloc>(
    () => BookingConfirmationBloc(
      getIt<GetBookingConfirmationUseCase>(),
      getIt<SubmitBookingUseCase>(),
    ),
    lazySingleton: false,
  );
  await _replaceRegistration<BookingDetailBloc>(
    () => BookingDetailBloc(
      getIt<GetBookingDetailUseCase>(),
      getIt<CancelBookingUseCase>(),
    ),
    lazySingleton: false,
  );
}

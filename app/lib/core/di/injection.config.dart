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
import 'package:app/core/network/api_service.dart' as _i1031;
import 'package:app/core/network/dio_factory.dart' as _i75;
import 'package:app/core/network/network_info.dart' as _i992;
import 'package:app/core/storage/storage_service.dart' as _i179;
import 'package:app/features/authentication/domain/repositories/auth_repository.dart'
    as _i853;
import 'package:app/features/blog/data/datasources/blog_mock_data_source.dart'
    as _i864;
import 'package:app/features/blog/data/repositories/blog_repository_impl.dart'
    as _i498;
import 'package:app/features/blog/domain/repositories/blog_repository.dart'
    as _i591;
import 'package:app/features/blog/domain/usecases/get_blog_page_content_usecase.dart'
    as _i774;
import 'package:app/features/blog/presentation/bloc/blog_bloc.dart' as _i72;
import 'package:app/features/booking/data/datasources/booking_appointment_mock_data_source.dart'
    as _i291;
import 'package:app/features/booking/data/datasources/booking_confirmation_mock_data_source.dart'
    as _i737;
import 'package:app/features/booking/data/datasources/booking_detail_local_data_source.dart'
    as _i829;
import 'package:app/features/booking/data/datasources/booking_service_mock_data_source.dart'
    as _i1072;
import 'package:app/features/booking/data/repositories/booking_appointment_repository_impl.dart'
    as _i998;
import 'package:app/features/booking/data/repositories/booking_confirmation_repository_impl.dart'
    as _i283;
import 'package:app/features/booking/data/repositories/booking_detail_repository_impl.dart'
    as _i624;
import 'package:app/features/booking/data/repositories/booking_service_repository_impl.dart'
    as _i506;
import 'package:app/features/booking/domain/repositories/booking_appointment_repository.dart'
    as _i572;
import 'package:app/features/booking/domain/repositories/booking_confirmation_repository.dart'
    as _i576;
import 'package:app/features/booking/domain/repositories/booking_detail_repository.dart'
    as _i852;
import 'package:app/features/booking/domain/repositories/booking_service_repository.dart'
    as _i882;
import 'package:app/features/booking/domain/usecases/cancel_booking_usecase.dart'
    as _i479;
import 'package:app/features/booking/domain/usecases/get_appointment_page_content_usecase.dart'
    as _i839;
import 'package:app/features/booking/domain/usecases/get_booking_confirmation_usecase.dart'
    as _i460;
import 'package:app/features/booking/domain/usecases/get_booking_detail_usecase.dart'
    as _i1023;
import 'package:app/features/booking/domain/usecases/get_booking_services_usecase.dart'
    as _i518;
import 'package:app/features/booking/domain/usecases/submit_booking_usecase.dart'
    as _i568;
import 'package:app/features/booking/presentation/bloc/booking_appointment_bloc.dart'
    as _i670;
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart'
    as _i178;
import 'package:app/features/booking/presentation/bloc/booking_confirmation_bloc.dart'
    as _i949;
import 'package:app/features/booking/presentation/bloc/booking_detail_bloc.dart'
    as _i136;
import 'package:app/features/booking/presentation/bloc/booking_service_selection_bloc.dart'
    as _i632;
import 'package:app/features/chat/data/datasources/chat_mock_data_source.dart'
    as _i273;
import 'package:app/features/chat/data/repositories/chat_repository_impl.dart'
    as _i387;
import 'package:app/features/chat/domain/repositories/chat_repository.dart'
    as _i336;
import 'package:app/features/chat/domain/usecases/get_chat_page_content_usecase.dart'
    as _i141;
import 'package:app/features/chat/domain/usecases/send_chat_message_usecase.dart'
    as _i504;
import 'package:app/features/chat/presentation/bloc/chat_bloc.dart' as _i744;
import 'package:app/features/home/data/datasources/home_mock_data_source.dart'
    as _i197;
import 'package:app/features/home/data/repositories/home_repository_impl.dart'
    as _i1058;
import 'package:app/features/home/domain/repositories/home_repository.dart'
    as _i252;
import 'package:app/features/home/domain/usecases/get_home_dashboard_usecase.dart'
    as _i696;
import 'package:app/features/home/presentation/bloc/home_bloc.dart' as _i448;
import 'package:app/features/pets/data/datasources/pets_mock_data_source.dart'
    as _i741;
import 'package:app/features/pets/data/repositories/pets_repository_impl.dart'
    as _i73;
import 'package:app/features/pets/domain/repositories/pets_repository.dart'
    as _i124;
import 'package:app/features/pets/domain/usecases/get_my_pets_page_content_usecase.dart'
    as _i428;
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart' as _i475;
import 'package:app/features/profile/data/datasources/profile_mock_data_source.dart'
    as _i699;
import 'package:app/features/profile/data/repositories/profile_repository_impl.dart'
    as _i329;
import 'package:app/features/profile/domain/repositories/profile_repository.dart'
    as _i752;
import 'package:app/features/profile/domain/usecases/get_profile_page_content_usecase.dart'
    as _i9;
import 'package:app/features/profile/domain/usecases/logout_usecase.dart'
    as _i922;
import 'package:app/features/profile/presentation/bloc/profile_bloc.dart'
    as _i651;
import 'package:app/features/sample_posts/data/datasources/sample_posts_data_sources.dart'
    as _i309;
import 'package:app/features/sample_posts/data/repositories/sample_posts_repository_impl.dart'
    as _i110;
import 'package:app/features/sample_posts/domain/repositories/sample_posts_repository.dart'
    as _i1070;
import 'package:app/features/sample_posts/domain/usecases/get_sample_posts_usecase.dart'
    as _i25;
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart'
    as _i1061;
import 'package:app/features/services/data/datasources/services_mock_data_source.dart'
    as _i696;
import 'package:app/features/services/data/repositories/services_repository_impl.dart'
    as _i684;
import 'package:app/features/services/domain/repositories/services_repository.dart'
    as _i1048;
import 'package:app/features/services/domain/usecases/get_services_page_content_usecase.dart'
    as _i528;
import 'package:app/features/services/presentation/bloc/services_bloc.dart'
    as _i174;
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
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.sharedPreferences(),
      preResolve: true,
    );
    gh.factory<_i178.BookingBloc>(() => _i178.BookingBloc());
    gh.singleton<_i1068.AppConfig>(() => registerModule.appConfig);
    gh.lazySingleton<_i567.AppRouter>(() => _i567.AppRouter());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage(),
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity());
    gh.lazySingleton<_i864.BlogMockDataSource>(
      () => _i864.BlogMockDataSource(),
    );
    gh.lazySingleton<_i291.BookingAppointmentMockDataSource>(
      () => _i291.BookingAppointmentMockDataSource(),
    );
    gh.lazySingleton<_i829.BookingDetailLocalDataSource>(
      () => _i829.BookingDetailLocalDataSource(),
    );
    gh.lazySingleton<_i1072.BookingServiceMockDataSource>(
      () => _i1072.BookingServiceMockDataSource(),
    );
    gh.lazySingleton<_i273.ChatMockDataSource>(
      () => _i273.ChatMockDataSource(),
    );
    gh.lazySingleton<_i197.HomeMockDataSource>(
      () => _i197.HomeMockDataSource(),
    );
    gh.lazySingleton<_i741.PetsMockDataSource>(
      () => _i741.PetsMockDataSource(),
    );
    gh.lazySingleton<_i699.ProfileMockDataSource>(
      () => _i699.ProfileMockDataSource(),
    );
    gh.lazySingleton<_i696.ServicesMockDataSource>(
      () => _i696.ServicesMockDataSource(),
    );
    gh.lazySingleton<_i179.SecureStorageService>(
      () => _i179.SecureStorageServiceImpl(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i974.Logger>(
      () => registerModule.logger(gh<_i1068.AppConfig>()),
    );
    gh.lazySingleton<_i572.BookingAppointmentRepository>(
      () => _i998.BookingAppointmentRepositoryImpl(
        gh<_i291.BookingAppointmentMockDataSource>(),
      ),
    );
    gh.lazySingleton<_i591.BlogRepository>(
      () => _i498.BlogRepositoryImpl(gh<_i864.BlogMockDataSource>()),
    );
    gh.lazySingleton<_i252.HomeRepository>(
      () => _i1058.HomeRepositoryImpl(gh<_i197.HomeMockDataSource>()),
    );
    gh.factory<_i839.GetAppointmentPageContentUseCase>(
      () => _i839.GetAppointmentPageContentUseCase(
        gh<_i572.BookingAppointmentRepository>(),
      ),
    );
    gh.lazySingleton<_i737.BookingConfirmationMockDataSource>(
      () => _i737.BookingConfirmationMockDataSource(
        gh<_i1072.BookingServiceMockDataSource>(),
        gh<_i829.BookingDetailLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i179.AppPreferences>(
      () => _i179.AppPreferences(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1048.ServicesRepository>(
      () => _i684.ServicesRepositoryImpl(gh<_i696.ServicesMockDataSource>()),
    );
    gh.lazySingleton<_i752.ProfileRepository>(
      () => _i329.ProfileRepositoryImpl(gh<_i699.ProfileMockDataSource>()),
    );
    gh.lazySingleton<_i75.AuthInterceptor>(
      () => _i75.AuthInterceptor(gh<_i179.SecureStorageService>()),
    );
    gh.lazySingleton<_i124.PetsRepository>(
      () => _i73.PetsRepositoryImpl(gh<_i741.PetsMockDataSource>()),
    );
    gh.lazySingleton<_i336.ChatRepository>(
      () => _i387.ChatRepositoryImpl(gh<_i273.ChatMockDataSource>()),
    );
    gh.factory<_i922.LogoutUseCase>(
      () => _i922.LogoutUseCase(gh<_i853.AuthRepository>()),
    );
    gh.factory<_i670.BookingAppointmentBloc>(
      () => _i670.BookingAppointmentBloc(
        gh<_i839.GetAppointmentPageContentUseCase>(),
      ),
    );
    gh.lazySingleton<_i992.NetworkInfo>(
      () => _i992.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.factory<_i774.GetBlogPageContentUseCase>(
      () => _i774.GetBlogPageContentUseCase(gh<_i591.BlogRepository>()),
    );
    gh.factory<_i9.GetProfilePageContentUseCase>(
      () => _i9.GetProfilePageContentUseCase(gh<_i752.ProfileRepository>()),
    );
    gh.lazySingleton<_i452.AppBlocObserver>(
      () => _i452.AppBlocObserver(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i75.ErrorLoggerInterceptor>(
      () => _i75.ErrorLoggerInterceptor(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i852.BookingDetailRepository>(
      () => _i624.BookingDetailRepositoryImpl(
        gh<_i829.BookingDetailLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i882.BookingServiceRepository>(
      () => _i506.BookingServiceRepositoryImpl(
        gh<_i1072.BookingServiceMockDataSource>(),
      ),
    );
    gh.factory<_i651.ProfileBloc>(
      () => _i651.ProfileBloc(
        gh<_i9.GetProfilePageContentUseCase>(),
        gh<_i922.LogoutUseCase>(),
      ),
    );
    gh.factory<_i479.CancelBookingUseCase>(
      () => _i479.CancelBookingUseCase(gh<_i852.BookingDetailRepository>()),
    );
    gh.factory<_i1023.GetBookingDetailUseCase>(
      () => _i1023.GetBookingDetailUseCase(gh<_i852.BookingDetailRepository>()),
    );
    gh.factory<_i696.GetHomeDashboardUseCase>(
      () => _i696.GetHomeDashboardUseCase(gh<_i252.HomeRepository>()),
    );
    gh.factory<_i528.GetServicesPageContentUseCase>(
      () =>
          _i528.GetServicesPageContentUseCase(gh<_i1048.ServicesRepository>()),
    );
    gh.lazySingleton<_i75.NetworkLoggerInterceptor>(
      () => _i75.NetworkLoggerInterceptor(
        gh<_i1068.AppConfig>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i428.GetMyPetsPageContentUseCase>(
      () => _i428.GetMyPetsPageContentUseCase(gh<_i124.PetsRepository>()),
    );
    gh.lazySingleton<_i576.BookingConfirmationRepository>(
      () => _i283.BookingConfirmationRepositoryImpl(
        gh<_i737.BookingConfirmationMockDataSource>(),
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
    gh.factory<_i174.ServicesBloc>(
      () => _i174.ServicesBloc(gh<_i528.GetServicesPageContentUseCase>()),
    );
    gh.factory<_i72.BlogBloc>(
      () => _i72.BlogBloc(gh<_i774.GetBlogPageContentUseCase>()),
    );
    gh.lazySingleton<_i309.SamplePostsLocalDataSource>(
      () => _i309.SamplePostsLocalDataSourceImpl(gh<_i179.AppPreferences>()),
    );
    gh.factory<_i141.GetChatPageContentUseCase>(
      () => _i141.GetChatPageContentUseCase(gh<_i336.ChatRepository>()),
    );
    gh.factory<_i504.SendChatMessageUseCase>(
      () => _i504.SendChatMessageUseCase(gh<_i336.ChatRepository>()),
    );
    gh.factory<_i460.GetBookingConfirmationUseCase>(
      () => _i460.GetBookingConfirmationUseCase(
        gh<_i576.BookingConfirmationRepository>(),
      ),
    );
    gh.factory<_i568.SubmitBookingUseCase>(
      () =>
          _i568.SubmitBookingUseCase(gh<_i576.BookingConfirmationRepository>()),
    );
    gh.factory<_i136.BookingDetailBloc>(
      () => _i136.BookingDetailBloc(
        gh<_i1023.GetBookingDetailUseCase>(),
        gh<_i479.CancelBookingUseCase>(),
      ),
    );
    gh.factory<_i518.GetBookingServicesUseCase>(
      () =>
          _i518.GetBookingServicesUseCase(gh<_i882.BookingServiceRepository>()),
    );
    gh.factory<_i448.HomeBloc>(
      () => _i448.HomeBloc(gh<_i696.GetHomeDashboardUseCase>()),
    );
    gh.factory<_i475.PetsBloc>(
      () => _i475.PetsBloc(gh<_i428.GetMyPetsPageContentUseCase>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => registerModule.dio(gh<_i75.DioFactory>()),
    );
    gh.factory<_i949.BookingConfirmationBloc>(
      () => _i949.BookingConfirmationBloc(
        gh<_i460.GetBookingConfirmationUseCase>(),
        gh<_i568.SubmitBookingUseCase>(),
      ),
    );
    gh.factory<_i744.ChatBloc>(
      () => _i744.ChatBloc(
        gh<_i141.GetChatPageContentUseCase>(),
        gh<_i504.SendChatMessageUseCase>(),
        gh<_i336.ChatRepository>(),
      ),
    );
    gh.factory<_i632.BookingServiceSelectionBloc>(
      () => _i632.BookingServiceSelectionBloc(
        gh<_i518.GetBookingServicesUseCase>(),
      ),
    );
    gh.lazySingleton<_i309.SamplePostsRemoteDataSource>(
      () => _i309.SamplePostsRemoteDataSourceImpl(gh<_i1031.AppApiService>()),
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

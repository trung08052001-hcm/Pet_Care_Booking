import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/services/data/datasources/services_local_data_source.dart';
import 'package:app/features/services/data/datasources/services_mock_data_source.dart';
import 'package:app/features/services/data/datasources/services_remote_data_source.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';
import 'package:app/features/services/domain/repositories/services_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ServicesRepository)
class ServicesRepositoryImpl implements ServicesRepository {
  ServicesRepositoryImpl(
    this._mockDataSource, [
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  ]);

  final ServicesMockDataSource _mockDataSource;
  final ServicesRemoteDataSource? _remoteDataSource;
  final ServicesLocalDataSource? _localDataSource;
  final NetworkInfo? _networkInfo;

  @override
  ResultFuture<ServicesPageContent> getServicesPageContent() async {
    try {
      final mockContent = _mockDataSource.getPageContent();
      final remoteDataSource = _remoteDataSource;

      if (remoteDataSource == null) {
        return Right(mockContent);
      }

      if (_networkInfo != null && !await _networkInfo.isConnected) {
        return Right(_contentWithCachedOrMock(mockContent));
      }

      final services = await remoteDataSource.getServices();
      await _localDataSource?.saveServices(services);
      return Right(
        ServicesPageContent(
          title: mockContent.title,
          subtitle: mockContent.subtitle,
          services: services,
        ),
      );
    } on Exception catch (exception, stackTrace) {
      final fallbackContent = _mockDataSource.getPageContent();
      final cachedContent = _contentWithCachedOrMock(fallbackContent);
      if (cachedContent.services.isNotEmpty) {
        return Right(cachedContent);
      }

      return Left(FailureMapper.fromException(exception, stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<List<PetCareService>> getFeaturedServices() async {
    try {
      final remoteDataSource = _remoteDataSource;
      if (remoteDataSource == null) {
        return Right(_mockFeaturedServices());
      }

      if (_networkInfo != null && !await _networkInfo.isConnected) {
        return Right(_cachedFeaturedOrMock());
      }

      final services = await remoteDataSource.getFeaturedServices();
      await _saveFeaturedServices(services);
      for (final service in services) {
        await _localDataSource?.saveServiceDetail(service);
      }
      return Right(services);
    } on Exception catch (exception, stackTrace) {
      final cached = _cachedFeaturedOrMock();
      if (cached.isNotEmpty) {
        return Right(cached);
      }

      return Left(FailureMapper.fromException(exception, stackTrace: stackTrace));
    }
  }

  @override
  ResultFuture<PetCareService> getServiceDetail(String serviceId) async {
    try {
      final remoteDataSource = _remoteDataSource;
      if (remoteDataSource == null) {
        return _mockServiceDetail(serviceId);
      }

      if (_networkInfo != null && !await _networkInfo.isConnected) {
        final cached = _localDataSource?.getCachedServiceDetail(serviceId);
        if (cached != null) {
          return Right(cached);
        }
        return _mockServiceDetail(serviceId);
      }

      final service = await remoteDataSource.getServiceDetail(serviceId);
      await _localDataSource?.saveServiceDetail(service);
      return Right(service);
    } on Exception catch (exception, stackTrace) {
      final cached = _localDataSource?.getCachedServiceDetail(serviceId);
      if (cached != null) {
        return Right(cached);
      }

      final mock = await _mockServiceDetail(serviceId);
      if (mock.isRight()) {
        return mock;
      }

      return Left(FailureMapper.fromException(exception, stackTrace: stackTrace));
    }
  }

  ServicesPageContent _contentWithCachedOrMock(ServicesPageContent fallback) {
    final cachedServices = _localDataSource?.getCachedServices() ?? const [];
    if (cachedServices.isEmpty) {
      return fallback;
    }

    return ServicesPageContent(
      title: fallback.title,
      subtitle: fallback.subtitle,
      services: cachedServices,
    );
  }

  List<PetCareService> _cachedFeaturedOrMock() {
    final cached = _localDataSource
            ?.getCachedServices()
            .where((service) => service.isFeatured)
            .toList(growable: false) ??
        const [];
    return cached.isNotEmpty ? cached : _mockFeaturedServices();
  }

  List<PetCareService> _mockFeaturedServices() {
    return _mockDataSource
        .getPageContent()
        .services
        .where((service) => service.isFeatured)
        .toList(growable: false);
  }

  Future<void> _saveFeaturedServices(List<PetCareService> services) async {
    final localDataSource = _localDataSource;
    if (localDataSource == null) {
      return;
    }

    final byId = <String, PetCareService>{
      for (final service in localDataSource.getCachedServices())
        service.routeId: service,
    };
    for (final service in services) {
      byId[service.routeId] = service;
    }

    await localDataSource.saveServices(byId.values.toList(growable: false));
  }

  ResultFuture<PetCareService> _mockServiceDetail(String serviceId) async {
    final services = _mockDataSource.getPageContent().services;
    for (final service in services) {
      if (service.id == serviceId || service.slug == serviceId) {
        return Right(service);
      }
    }

    return const Left(
      Failure(message: 'Không tìm thấy dịch vụ.'),
    );
  }
}

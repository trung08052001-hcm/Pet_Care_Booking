import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/home/data/datasources/home_mock_data_source.dart';
import 'package:app/features/home/domain/entities/home_dashboard.dart';
import 'package:app/features/home/domain/entities/home_featured_service.dart';
import 'package:app/features/home/domain/repositories/home_repository.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:app/features/services/domain/repositories/services_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(
    this._mockDataSource, [
    this._servicesRepository,
  ]);

  final HomeMockDataSource _mockDataSource;
  final ServicesRepository? _servicesRepository;

  @override
  ResultFuture<HomeDashboard> getHomeDashboard() async {
    try {
      final dashboard = _mockDataSource.getDashboard();
      final servicesRepository = _servicesRepository;
      if (servicesRepository == null) {
        return Right(dashboard);
      }

      final result = await servicesRepository.getFeaturedServices();
      return result.fold(
        (_) => Right(dashboard),
        (services) => Right(
          services.isEmpty
              ? dashboard
              : dashboard.copyWith(
                  featuredServices:
                      services.map(_featuredServiceFromApi).toList(growable: false),
                ),
        ),
      );
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  HomeFeaturedService _featuredServiceFromApi(PetCareService service) {
    return HomeFeaturedService(
      id: service.routeId,
      type: _featuredType(service),
      label: service.title,
    );
  }

  HomeFeaturedServiceType _featuredType(PetCareService service) {
    final value = '${service.icon} ${service.slug} ${service.title}'.toLowerCase();
    if (value.contains('hotel')) {
      return HomeFeaturedServiceType.petHotel;
    }
    if (value.contains('medical') ||
        value.contains('vet') ||
        value.contains('bác') ||
        value.contains('thu y') ||
        value.contains('thú y')) {
      return HomeFeaturedServiceType.veterinarian;
    }
    return HomeFeaturedServiceType.grooming;
  }
}

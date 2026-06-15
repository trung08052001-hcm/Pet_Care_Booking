import 'package:app/core/network/api_config.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';
import 'package:dio/dio.dart';

class ServicesRemoteDataSource {
  const ServicesRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<PetCareService>> getServices() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.services,
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final services = data['services'];
      if (services is List) {
        return _servicesFromJson(services);
      }
    }

    throw StateError('Invalid services response.');
  }

  Future<List<PetCareService>> getFeaturedServices() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.services}/featured',
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final services = data['services'];
      if (services is List) {
        return _servicesFromJson(services);
      }
    }

    throw StateError('Invalid featured services response.');
  }

  Future<PetCareService> getServiceDetail(String serviceId) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.services}/${Uri.encodeComponent(serviceId)}',
    );

    final data = response.data?['data'];
    if (data is Map<String, dynamic>) {
      final service = data['service'];
      if (service is Map<String, dynamic>) {
        return PetCareService.fromJson(service);
      }
    }

    throw StateError('Invalid service detail response.');
  }

  List<PetCareService> _servicesFromJson(List<dynamic> services) {
    return services
        .whereType<Map<String, dynamic>>()
        .map(PetCareService.fromJson)
        .toList(growable: false);
  }
}

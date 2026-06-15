import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/features/services/domain/entities/pet_care_service.dart';

class ServicesLocalDataSource {
  const ServicesLocalDataSource(this._store);

  static const _cacheKey = 'services';
  static const _detailPrefix = 'service-detail-';

  final HiveLocalStore _store;

  Future<void> saveServices(List<PetCareService> services) {
    return _store.putMap(
      boxName: HiveBoxNames.appCache,
      key: _cacheKey,
      value: {
        'items': services.map((service) => service.toJson()).toList(),
        'cachedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  List<PetCareService> getCachedServices() {
    final cached = _store.getMap(
      boxName: HiveBoxNames.appCache,
      key: _cacheKey,
    );
    final items = cached?['items'];
    if (items is! List) {
      return const [];
    }

    return items
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => PetCareService.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<void> saveServiceDetail(PetCareService service) async {
    await _store.putMap(
      boxName: HiveBoxNames.appCache,
      key: '$_detailPrefix${service.routeId}',
      value: service.toJson(),
    );
    if (service.id != service.routeId) {
      await _store.putMap(
        boxName: HiveBoxNames.appCache,
        key: '$_detailPrefix${service.id}',
        value: service.toJson(),
      );
    }
  }

  PetCareService? getCachedServiceDetail(String serviceId) {
    final cached = _store.getMap(
      boxName: HiveBoxNames.appCache,
      key: '$_detailPrefix$serviceId',
    );
    if (cached != null) {
      return PetCareService.fromJson(Map<String, dynamic>.from(cached));
    }

    for (final service in getCachedServices()) {
      if (service.id == serviceId || service.slug == serviceId) {
        return service;
      }
    }

    return null;
  }
}

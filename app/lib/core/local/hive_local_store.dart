import 'package:app/core/local/hive_box_names.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveLocalStore {
  const HiveLocalStore();

  static Future<void> init() async {
    await Hive.initFlutter();
    await Future.wait([
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.appCache),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.pets),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.petDrafts),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.bookingCache),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.syncQueue),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.notifications),
      Hive.openBox<Map<dynamic, dynamic>>(HiveBoxNames.animalInfo),
    ]);
  }

  Box<Map<dynamic, dynamic>> box(String name) =>
      Hive.box<Map<dynamic, dynamic>>(name);

  Future<void> putMap({
    required String boxName,
    required String key,
    required Map<String, dynamic> value,
  }) {
    return box(boxName).put(key, Map<String, dynamic>.from(value));
  }

  Map<String, dynamic>? getMap({required String boxName, required String key}) {
    final value = box(boxName).get(key);
    if (value == null) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  List<Map<String, dynamic>> values(String boxName) {
    return box(boxName).values.map(Map<String, dynamic>.from).toList();
  }

  Future<void> delete({required String boxName, required String key}) {
    return box(boxName).delete(key);
  }

  Future<void> clear(String boxName) {
    return box(boxName).clear();
  }
}

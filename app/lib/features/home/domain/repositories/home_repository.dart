import 'package:app/core/common/typedefs.dart';
import 'package:app/features/home/domain/entities/home_dashboard.dart';

abstract interface class HomeRepository {
  ResultFuture<HomeDashboard> getHomeDashboard();
}

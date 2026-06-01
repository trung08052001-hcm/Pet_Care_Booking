import 'package:app/core/common/typedefs.dart';
import 'package:app/features/services/domain/entities/services_page_content.dart';

abstract interface class ServicesRepository {
  ResultFuture<ServicesPageContent> getServicesPageContent();
}

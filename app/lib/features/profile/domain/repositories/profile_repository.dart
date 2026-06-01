import 'package:app/core/common/typedefs.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';

abstract interface class ProfileRepository {
  ResultFuture<ProfilePageContent> getProfilePageContent();
}

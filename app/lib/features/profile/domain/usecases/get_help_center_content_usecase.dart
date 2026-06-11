import 'package:app/features/profile/data/datasources/help_center_remote_data_source.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';

class GetHelpCenterContentUseCase {
  const GetHelpCenterContentUseCase(this._dataSource);

  final HelpCenterRemoteDataSource _dataSource;

  Future<HelpCenterContent> call() {
    return _dataSource.getContent();
  }

  Future<void> submitFeedback(String message) {
    return _dataSource.submitFeedback(message);
  }
}

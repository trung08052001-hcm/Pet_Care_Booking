import 'package:app/features/profile/data/datasources/help_center_mock_data_source.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';

class GetHelpCenterContentUseCase {
  const GetHelpCenterContentUseCase(this._dataSource);

  final HelpCenterMockDataSource _dataSource;

  HelpCenterContent call() {
    return _dataSource.getContent();
  }
}

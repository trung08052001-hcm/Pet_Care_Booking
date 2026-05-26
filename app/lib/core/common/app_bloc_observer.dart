import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger);

  final Logger _logger;

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    if (!kDebugMode) {
      return;
    }
    _logger.i('[${bloc.runtimeType}] event => $event');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    if (!kDebugMode) {
      return;
    }
    _logger.d('[${bloc.runtimeType}] change => $change');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    _logger.e(
      '[${bloc.runtimeType}] error => $error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}

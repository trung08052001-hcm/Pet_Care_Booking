import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_resolveInitialLocale());

  static const Locale _fallbackLocale = Locale('en');
  static const _supportedLanguageCodes = {'en', 'vi'};

  static Locale _resolveInitialLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;

    if (_supportedLanguageCodes.contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }

    return _fallbackLocale;
  }

  void changeLocale(Locale locale) {
    emit(locale);
  }
}

import 'dart:ui';

import 'package:app/core/storage/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._preferences) : super(_resolveInitialLocale(_preferences));

  final AppPreferences _preferences;

  static const Locale _fallbackLocale = Locale('en');
  static const _supportedLanguageCodes = {'en', 'vi'};

  static Locale _resolveInitialLocale(AppPreferences preferences) {
    final savedLanguageCode = preferences.readString(
      StorageKeys.localeLanguageCode,
    );

    if (savedLanguageCode != null &&
        _supportedLanguageCodes.contains(savedLanguageCode)) {
      return Locale(savedLanguageCode);
    }

    final systemLocale = PlatformDispatcher.instance.locale;

    if (_supportedLanguageCodes.contains(systemLocale.languageCode)) {
      return Locale(systemLocale.languageCode);
    }

    return _fallbackLocale;
  }

  Future<void> changeLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) {
      return;
    }
    await _preferences.writeString(
      key: StorageKeys.localeLanguageCode,
      value: locale.languageCode,
    );
    emit(locale);
  }
}

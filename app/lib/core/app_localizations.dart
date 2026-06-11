import 'package:app/core/l10n/app_strings_en.dart';
import 'package:app/core/l10n/app_strings_vi.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en'),
    Locale('vi'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': appStringsEn,
    'vi': appStringsVi,
  };

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );

    assert(localizations != null, 'AppLocalizations not found in context.');

    return localizations!;
  }

  String _text(String key) {
    final languageCode = _localizedValues.containsKey(locale.languageCode)
        ? locale.languageCode
        : 'en';

    return _localizedValues[languageCode]![key] ??
        _localizedValues['en']![key] ??
        key;
  }

  String get appTitle => _text('appTitle');
  String get pageTitle => _text('pageTitle');
  String get onboardingBrand => _text('onboardingBrand');
  String get skip => _text('skip');
  String get continueLabel => _text('continueLabel');
  String get getStarted => _text('getStarted');
  String get swipeToContinue => _text('swipeToContinue');
  String get signInTitle => _text('signInTitle');
  String get signInSubtitle => _text('signInSubtitle');
  String get signInCta => _text('signInCta');
  String get signUpTitle => _text('signUpTitle');
  String get signUpSubtitle => _text('signUpSubtitle');
  String get signUpCta => _text('signUpCta');
  String get identifierLabel => _text('identifierLabel');
  String get identifierHint => _text('identifierHint');
  String get emailLabel => _text('emailLabel');
  String get emailHint => _text('emailHint');
  String get passwordLabel => _text('passwordLabel');
  String get passwordHint => _text('passwordHint');
  String get rememberMe => _text('rememberMe');
  String get forgotPassword => _text('forgotPassword');
  String get orContinueWith => _text('orContinueWith');
  String get noAccountPrompt => _text('noAccountPrompt');
  String get alreadyHaveAccountPrompt => _text('alreadyHaveAccountPrompt');
  String get signUpLink => _text('signUpLink');
  String get signInLink => _text('signInLink');
  String get fullNameLabel => _text('fullNameLabel');
  String get fullNameHint => _text('fullNameHint');
  String get phoneLabel => _text('phoneLabel');
  String get phoneHint => _text('phoneHint');
  String get addressLabel => _text('addressLabel');
  String get addressHint => _text('addressHint');
  String get confirmPasswordLabel => _text('confirmPasswordLabel');
  String get confirmPasswordHint => _text('confirmPasswordHint');
  String get acceptTermsPrefix => _text('acceptTermsPrefix');
  String get termsAndPolicy => _text('termsAndPolicy');
  String get identifierRequiredError => _text('identifierRequiredError');
  String get identifierInvalidError => _text('identifierInvalidError');
  String get emailRequiredError => _text('emailRequiredError');
  String get emailInvalidError => _text('emailInvalidError');
  String get passwordRequiredError => _text('passwordRequiredError');
  String get passwordShortError => _text('passwordShortError');
  String get fullNameRequiredError => _text('fullNameRequiredError');
  String get phoneRequiredError => _text('phoneRequiredError');
  String get phoneInvalidError => _text('phoneInvalidError');
  String get addressRequiredError => _text('addressRequiredError');
  String get addressTooLongError => _text('addressTooLongError');
  String get confirmPasswordRequiredError =>
      _text('confirmPasswordRequiredError');
  String get confirmPasswordMismatchError =>
      _text('confirmPasswordMismatchError');
  String get acceptTermsError => _text('acceptTermsError');
  String get forgotPasswordTitle => _text('forgotPasswordTitle');
  String get forgotPasswordSubtitle => _text('forgotPasswordSubtitle');
  String get sendOtpCta => _text('sendOtpCta');
  String get otpTitle => _text('otpTitle');
  String get otpLabel => _text('otpLabel');
  String get verifyOtpCta => _text('verifyOtpCta');
  String get resendOtp => _text('resendOtp');
  String get otpSentMessage => _text('otpSentMessage');
  String get otpVerifiedMessage => _text('otpVerifiedMessage');
  String get resendingOtp => _text('resendingOtp');
  String get otpRequiredError => _text('otpRequiredError');
  String get otpInvalidError => _text('otpInvalidError');
  String get resetPasswordTitle => _text('resetPasswordTitle');
  String get resetPasswordCta => _text('resetPasswordCta');
  String get newPasswordLabel => _text('newPasswordLabel');
  String get newPasswordHint => _text('newPasswordHint');
  String get confirmNewPasswordLabel => _text('confirmNewPasswordLabel');
  String get confirmNewPasswordHint => _text('confirmNewPasswordHint');
  String get onboardingTitle1 => _text('onboardingTitle1');
  String get onboardingDescription1 => _text('onboardingDescription1');
  String get onboardingBadge1 => _text('onboardingBadge1');
  String get onboardingTitle2 => _text('onboardingTitle2');
  String get onboardingDescription2 => _text('onboardingDescription2');
  String get onboardingBadge2 => _text('onboardingBadge2');
  String get onboardingTitle3 => _text('onboardingTitle3');
  String get onboardingDescription3 => _text('onboardingDescription3');
  String get onboardingBadge3 => _text('onboardingBadge3');
  String get headline => _text('headline');
  String get description => _text('description');
  String get couldNotLoadPosts => _text('couldNotLoadPosts');
  String get retry => _text('retry');
  String get unknownError => _text('unknownError');
  String get changeLanguage => _text('changeLanguage');
  String get english => _text('english');
  String get vietnamese => _text('vietnamese');
  String get languageSettingsTitle => _text('languageSettingsTitle');
  String get languageSettingsSubtitle => _text('languageSettingsSubtitle');
  String get chooseLanguage => _text('chooseLanguage');
  String get englishDescription => _text('englishDescription');
  String get vietnameseDescription => _text('vietnameseDescription');
  String get currentLanguage => _text('currentLanguage');
  String get languageSaved => _text('languageSaved');
  String get profileEditLabel => _text('profileEditLabel');
  String get profileSupportTitle => _text('profileSupportTitle');
  String get profileLogout => _text('profileLogout');
  String get profileVersion => _text('profileVersion');
  String get profileMemberSince => _text('profileMemberSince');
  String get profileMyPets => _text('profileMyPets');
  String get profileBookingHistory => _text('profileBookingHistory');
  String get profileWallet => _text('profileWallet');
  String get profileAddresses => _text('profileAddresses');
  String get profileHelpCenter => _text('profileHelpCenter');
  String get profileRateApp => _text('profileRateApp');
  String get profileLanguage => _text('profileLanguage');
  String get navHome => _text('navHome');
  String get navServices => _text('navServices');
  String get navBlog => _text('navBlog');
  String get navChat => _text('navChat');
  String get navProfile => _text('navProfile');

  String flavorLabel(String value) =>
      _text('flavor').replaceFirst('{value}', value);

  String baseUrlLabel(String value) =>
      _text('baseUrl').replaceFirst('{value}', value);

  String otpSubtitle(String value) =>
      _text('otpSubtitle').replaceFirst('{value}', value);

  String resetPasswordSubtitle(String value) =>
      _text('resetPasswordSubtitle').replaceFirst('{value}', value);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations.supportedLocales.any(
      (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

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
    'en': {
      'appTitle': 'Flutter Product Base',
      'pageTitle': 'Flutter Product Base',
      'onboardingBrand': 'PawSitive Care',
      'skip': 'Skip',
      'continueLabel': 'Continue',
      'getStarted': 'Get Started',
      'swipeToContinue': 'Swipe to continue',
      'signInTitle': 'Welcome back',
      'signInSubtitle':
          'Sign in to continue caring for your pet with easy booking and trusted support.',
      'signInCta': 'Sign In',
      'signUpTitle': 'Create account',
      'signUpSubtitle':
          'Set up your PawSitive Care account to manage appointments and pet care in one place.',
      'signUpCta': 'Sign Up',
      'identifierLabel': 'Email or phone number',
      'identifierHint': 'example@email.com or 0901234567',
      'emailLabel': 'Email',
      'emailHint': 'example@email.com',
      'passwordLabel': 'Password',
      'passwordHint': 'Enter your password',
      'rememberMe': 'Remember me',
      'forgotPassword': 'Forgot password?',
      'orContinueWith': 'Or continue with',
      'noAccountPrompt': 'Don\'t have an account?',
      'alreadyHaveAccountPrompt': 'Already have an account?',
      'signUpLink': 'Sign Up',
      'signInLink': 'Sign In',
      'fullNameLabel': 'Full name',
      'fullNameHint': 'Nguyen Van A',
      'phoneLabel': 'Phone number',
      'phoneHint': '090 123 4567',
      'confirmPasswordLabel': 'Confirm password',
      'confirmPasswordHint': 'Re-enter your password',
      'acceptTermsPrefix': 'I agree to the ',
      'termsAndPolicy': 'Terms & Privacy Policy',
      'emailRequiredError': 'Please enter your email.',
      'emailInvalidError': 'Please enter a valid email.',
      'identifierRequiredError': 'Please enter your email or phone number.',
      'identifierInvalidError': 'Please enter a valid email or phone number.',
      'passwordRequiredError': 'Please enter your password.',
      'passwordShortError': 'Password must be at least 8 characters.',
      'fullNameRequiredError': 'Please enter your full name.',
      'phoneRequiredError': 'Please enter your phone number.',
      'phoneInvalidError': 'Please enter a valid phone number.',
      'confirmPasswordRequiredError': 'Please confirm your password.',
      'confirmPasswordMismatchError': 'Passwords do not match.',
      'acceptTermsError': 'Please accept the terms to continue.',
      'forgotPasswordTitle': 'Forgot password',
      'forgotPasswordSubtitle':
          'Enter your email and we will send a 6-digit verification code.',
      'sendOtpCta': 'Send OTP',
      'otpSentMessage':
          'If the account exists, a verification code has been sent.',
      'otpVerifiedMessage': 'OTP verified successfully.',
      'resendingOtp': 'Sending...',
      'otpTitle': 'Verify OTP',
      'otpSubtitle': 'We sent a 6-digit verification code to {value}.',
      'otpLabel': 'Verification code',
      'verifyOtpCta': 'Verify code',
      'resendOtp': 'Resend code',
      'otpRequiredError': 'Please enter the OTP code.',
      'otpInvalidError': 'OTP must contain 6 digits.',
      'resetPasswordTitle': 'Create new password',
      'resetPasswordSubtitle':
          'Set a new password for {value} to secure your account again.',
      'resetPasswordCta': 'Update password',
      'newPasswordLabel': 'New password',
      'newPasswordHint': 'Enter your new password',
      'confirmNewPasswordLabel': 'Confirm new password',
      'confirmNewPasswordHint': 'Re-enter your new password',
      'onboardingTitle1': 'Care with heart',
      'onboardingDescription1':
          'Everything your pet needs in one calm place, from daily support to trusted guidance.',
      'onboardingBadge1': 'Dedicated care',
      'onboardingTitle2': 'Expert companions',
      'onboardingDescription2':
          'Connect with experienced pet specialists who understand nutrition, health, and behavior.',
      'onboardingBadge2': 'Top experts',
      'onboardingTitle3': 'Easy booking',
      'onboardingDescription3':
          'Book appointments in minutes and keep every important visit organized in one flow.',
      'onboardingBadge3': 'Fast schedule',
      'headline': 'Production-ready Flutter base',
      'description':
          'Feature-first clean architecture using Bloc, Dio, Retrofit, and GetIt.',
      'flavor': 'Flavor: {value}',
      'baseUrl': 'Base URL: {value}',
      'couldNotLoadPosts': 'Could not load sample posts',
      'retry': 'Retry',
      'unknownError': 'Unknown error.',
      'changeLanguage': 'Change language',
      'english': 'English',
      'vietnamese': 'Vietnamese',
    },
    'vi': {
      'appTitle': 'Nen tang Flutter',
      'pageTitle': 'Nen tang Flutter',
      'onboardingBrand': 'PawSitive Care',
      'skip': 'Bo qua',
      'continueLabel': 'Tiep tuc',
      'getStarted': 'Bat dau ngay',
      'swipeToContinue': 'Vuot de tiep tuc',
      'signInTitle': 'Chao mung ban tro lai',
      'signInSubtitle':
          'Dang nhap de tiep tuc cham soc thu cung, dat lich nhanh va theo doi moi ho so de dang.',
      'signInCta': 'Dang nhap',
      'signUpTitle': 'Tao tai khoan moi',
      'signUpSubtitle':
          'Tao tai khoan PawSitive Care de quan ly lich hen va hanh trinh cham soc thu cung o mot noi.',
      'signUpCta': 'Dang ky',
      'identifierLabel': 'Email hoac so dien thoai',
      'identifierHint': 'example@email.com hoac 0901234567',
      'emailLabel': 'Email',
      'emailHint': 'example@email.com',
      'passwordLabel': 'Mat khau',
      'passwordHint': 'Nhap mat khau cua ban',
      'rememberMe': 'Nho dang nhap',
      'forgotPassword': 'Quen mat khau?',
      'orContinueWith': 'Hoac dang nhap nhanh voi',
      'noAccountPrompt': 'Chua co tai khoan?',
      'alreadyHaveAccountPrompt': 'Da co tai khoan?',
      'signUpLink': 'Dang ky ngay',
      'signInLink': 'Dang nhap',
      'fullNameLabel': 'Ho va ten',
      'fullNameHint': 'Nguyen Van A',
      'phoneLabel': 'So dien thoai',
      'phoneHint': '090 123 4567',
      'confirmPasswordLabel': 'Xac nhan mat khau',
      'confirmPasswordHint': 'Nhap lai mat khau',
      'acceptTermsPrefix': 'Toi dong y voi ',
      'termsAndPolicy': 'Dieu khoan & Chinh sach',
      'emailRequiredError': 'Vui long nhap email.',
      'emailInvalidError': 'Email khong hop le.',
      'identifierRequiredError': 'Vui long nhap email hoac so dien thoai.',
      'identifierInvalidError': 'Email hoac so dien thoai khong hop le.',
      'passwordRequiredError': 'Vui long nhap mat khau.',
      'passwordShortError': 'Mat khau phai co it nhat 8 ky tu.',
      'fullNameRequiredError': 'Vui long nhap ho va ten.',
      'phoneRequiredError': 'Vui long nhap so dien thoai.',
      'phoneInvalidError': 'So dien thoai khong hop le.',
      'confirmPasswordRequiredError': 'Vui long nhap lai mat khau.',
      'confirmPasswordMismatchError': 'Mat khau xac nhan khong khop.',
      'acceptTermsError': 'Ban can dong y dieu khoan de tiep tuc.',
      'forgotPasswordTitle': 'Quen mat khau',
      'forgotPasswordSubtitle':
          'Nhap email de nhan ma xac minh 6 so.',
      'sendOtpCta': 'Gui ma OTP',
      'otpSentMessage':
          'Neu tai khoan ton tai, ma xac minh da duoc gui.',
      'otpVerifiedMessage': 'Xac minh OTP thanh cong.',
      'resendingOtp': 'Dang gui...',
      'otpTitle': 'Nhap ma OTP',
      'otpSubtitle': 'Chung toi da gui ma xac minh 6 so den {value}.',
      'otpLabel': 'Ma xac minh',
      'verifyOtpCta': 'Xac minh',
      'resendOtp': 'Gui lai ma',
      'otpRequiredError': 'Vui long nhap ma OTP.',
      'otpInvalidError': 'Ma OTP phai gom 6 chu so.',
      'resetPasswordTitle': 'Tao mat khau moi',
      'resetPasswordSubtitle':
          'Dat mat khau moi cho {value} de bao ve tai khoan cua ban.',
      'resetPasswordCta': 'Cap nhat mat khau',
      'newPasswordLabel': 'Mat khau moi',
      'newPasswordHint': 'Nhap mat khau moi',
      'confirmNewPasswordLabel': 'Xac nhan mat khau moi',
      'confirmNewPasswordHint': 'Nhap lai mat khau moi',
      'onboardingTitle1': 'Cham soc tan tam',
      'onboardingDescription1':
          'Chung toi cham soc cac be thu cung cua ban bang su tan tam, nhe nhang va dang tin cay moi ngay.',
      'onboardingBadge1': 'Tan tam',
      'onboardingTitle2': 'Doi ngu chuyen gia',
      'onboardingDescription2':
          'Ket noi voi doi ngu chuyen gia giau kinh nghiem trong cham soc, dinh duong va suc khoe thu cung.',
      'onboardingBadge2': 'Chuyen gia',
      'onboardingTitle3': 'Dat lich de dang',
      'onboardingDescription3':
          'Dat lich nhanh gon, theo doi lich hen de dang va luon san sang cho moi lan tham kham.',
      'onboardingBadge3': 'Dat lich nhanh',
      'headline': 'Bo khung Flutter san sang cho production',
      'description':
          'Kien truc feature-first clean architecture voi Bloc, Dio, Retrofit va GetIt.',
      'flavor': 'Moi truong: {value}',
      'baseUrl': 'Duong dan API: {value}',
      'couldNotLoadPosts': 'Khong the tai danh sach bai viet mau',
      'retry': 'Thu lai',
      'unknownError': 'Da xay ra loi khong xac dinh.',
      'changeLanguage': 'Doi ngon ngu',
      'english': 'Tieng Anh',
      'vietnamese': 'Tieng Viet',
    },
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

    return _localizedValues[languageCode]![key]!;
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

  String flavorLabel(String value) => _text('flavor').replaceFirst('{value}', value);

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

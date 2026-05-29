import 'package:app/core/app_localizations.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/authentication/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordOtpPage extends StatefulWidget {
  const ForgotPasswordOtpPage({
    super.key,
    required this.email,
  });

  static const routeName = 'forgot-password-otp';
  static const routePath = '/forgot-password-otp';

  final String email;

  @override
  State<ForgotPasswordOtpPage> createState() => _ForgotPasswordOtpPageState();
}

class _ForgotPasswordOtpPageState extends State<ForgotPasswordOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await getIt<AuthRepository>().verifyPasswordResetOtp(
      email: widget.email,
      otp: _otpController.text.trim(),
    );

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otpVerifiedMessage)),
        );
        context.goNamed(SignInPage.routeName);
      },
    );
  }

  Future<void> _resend() async {
    if (_isResending || _isLoading) {
      return;
    }

    setState(() => _isResending = true);

    final result = await getIt<AuthRepository>().requestPasswordResetOtp(
      email: widget.email,
    );

    if (!mounted) {
      return;
    }

    setState(() => _isResending = false);

    final l10n = AppLocalizations.of(context);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.otpSentMessage)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthShell(
      title: l10n.otpTitle,
      subtitle: l10n.otpSubtitle(widget.email),
      primaryButtonLabel: l10n.verifyOtpCta,
      isPrimaryLoading: _isLoading,
      onPrimaryPressed: _submit,
      showSocialSection: false,
      topLeading: IconButton(
        onPressed: _isLoading ? null : () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded),
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF6E6E6E),
        ),
      ),
      formChildren: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 10,
                  color: Color(0xFF3A3A3A),
                ),
                decoration: InputDecoration(
                  labelText: l10n.otpLabel,
                  hintText: '000000',
                  counterText: '',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  filled: true,
                  fillColor: const Color(0xFFFFFBF7),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFEADFD6)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Color(0xFFEADFD6)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(
                      color: Color(0xFFFFB37A),
                      width: 1.2,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.otpRequiredError;
                  }
                  if (value.trim().length < 6) {
                    return l10n.otpInvalidError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isResending ? null : _resend,
                child: Text(
                  _isResending ? l10n.resendingOtp : l10n.resendOtp,
                  style: const TextStyle(
                    color: Color(0xFFB45A17),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

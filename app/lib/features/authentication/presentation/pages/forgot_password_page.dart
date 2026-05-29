import 'package:app/core/app_localizations.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_otp_page.dart';
import 'package:app/features/authentication/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static const routeName = 'forgot-password';
  static const routePath = '/forgot-password';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _isLoading) {
      return;
    }

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);

    final result = await getIt<AuthRepository>().requestPasswordResetOtp(
      email: email,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).otpSentMessage)),
        );
        context.pushNamed(
          ForgotPasswordOtpPage.routeName,
          extra: email,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthShell(
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      primaryButtonLabel: l10n.sendOtpCta,
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
          child: AuthTextField(
            label: l10n.emailLabel,
            hintText: l10n.emailHint,
            controller: _emailController,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final email = value?.trim() ?? '';
              if (email.isEmpty) {
                return l10n.emailRequiredError;
              }
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                return l10n.emailInvalidError;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

import 'package:app/core/app_localizations.dart';
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
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.pushNamed(
      ForgotPasswordOtpPage.routeName,
      extra: _phoneController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthShell(
      title: l10n.forgotPasswordTitle,
      subtitle: l10n.forgotPasswordSubtitle,
      primaryButtonLabel: l10n.sendOtpCta,
      onPrimaryPressed: _submit,
      showSocialSection: false,
      topLeading: IconButton(
        onPressed: () {
          context.pop();
        },
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
            label: l10n.phoneLabel,
            hintText: l10n.phoneHint,
            controller: _phoneController,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.phoneRequiredError;
              }
              if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
                return l10n.phoneInvalidError;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

import 'package:app/core/app_localizations.dart';
import 'package:app/features/authentication/presentation/pages/sign_in_page.dart';
import 'package:app/features/authentication/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    super.key,
    required this.phoneNumber,
  });

  static const routeName = 'reset-password';
  static const routePath = '/reset-password';

  final String phoneNumber;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.goNamed(SignInPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AuthShell(
      title: l10n.resetPasswordTitle,
      subtitle: l10n.resetPasswordSubtitle(widget.phoneNumber),
      primaryButtonLabel: l10n.resetPasswordCta,
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
          child: Column(
            children: [
              AuthTextField(
                label: l10n.newPasswordLabel,
                hintText: l10n.newPasswordHint,
                controller: _passwordController,
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFFC4B7AB),
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.passwordRequiredError;
                  }
                  if (value.length < 8) {
                    return l10n.passwordShortError;
                  }
                  return null;
                },
              ),
              AuthTextField(
                label: l10n.confirmNewPasswordLabel,
                hintText: l10n.confirmNewPasswordHint,
                controller: _confirmPasswordController,
                prefixIcon: Icons.lock_person_outlined,
                obscureText: _obscureConfirmPassword,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFFC4B7AB),
                    size: 20,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.confirmPasswordRequiredError;
                  }
                  if (value != _passwordController.text) {
                    return l10n.confirmPasswordMismatchError;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:app/core/app_localizations.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:app/features/authentication/presentation/pages/forgot_password_page.dart';
import 'package:app/features/authentication/presentation/pages/sign_up_page.dart';
import 'package:app/features/authentication/presentation/widgets/auth_shell.dart';
import 'package:app/features/sample_posts/presentation/pages/sample_posts_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static const routeName = 'sign-in';
  static const routePath = '/sign-in';

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isValidIdentifier(String value) {
    final normalized = value.trim();
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');

    return emailRegex.hasMatch(normalized) ||
        phoneRegex.hasMatch(normalized.replaceAll(RegExp(r'\s+'), ''));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
          AuthSignInRequested(
            identifier: _identifierController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current.action == AuthAction.signIn &&
          previous.submissionStatus != current.submissionStatus,
      listener: (context, state) {
        if (state.submissionStatus == AuthSubmissionStatus.failure &&
            state.message != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
          context.read<AuthBloc>().add(const AuthFeedbackCleared());
        }

        if (state.submissionStatus == AuthSubmissionStatus.success &&
            state.status == AuthStatus.authenticated) {
          context.read<AuthBloc>().add(const AuthFeedbackCleared());
          context.goNamed(SamplePostsPage.routeName);
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state.isLoading && state.action == AuthAction.signIn;

        return AuthShell(
          title: l10n.signInTitle,
          subtitle: l10n.signInSubtitle,
          primaryButtonLabel: l10n.signInCta,
          onPrimaryPressed: _submit,
          isPrimaryLoading: isSubmitting,
          footerPrompt: l10n.noAccountPrompt,
          footerActionLabel: l10n.signUpLink,
          onFooterActionPressed: () {
            context.pushNamed(SignUpPage.routeName);
          },
          formChildren: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    label: l10n.identifierLabel,
                    hintText: l10n.identifierHint,
                    controller: _identifierController,
                    prefixIcon: Icons.alternate_email_rounded,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.identifierRequiredError;
                      }
                      if (!_isValidIdentifier(value)) {
                        return l10n.identifierInvalidError;
                      }
                      return null;
                    },
                  ),
                  AuthTextField(
                    label: l10n.passwordLabel,
                    hintText: l10n.passwordHint,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFFF8A3D),
                          side: const BorderSide(color: Color(0xFFD9CEC4)),
                        ),
                        Expanded(
                          child: Text(
                            l10n.rememberMe,
                            style: const TextStyle(
                              color: Color(0xFF8D8D8D),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pushNamed(ForgotPasswordPage.routeName);
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFB45A17),
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            l10n.forgotPassword,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

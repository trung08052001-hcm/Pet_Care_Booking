import 'package:app/app/shell/main_shell_page.dart';
import 'package:app/core/app_localizations.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:app/features/authentication/presentation/widgets/auth_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static const routeName = 'sign-up';
  static const routePath = '/sign-up';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).acceptTermsError),
        ),
      );
      return;
    }

    context.read<AuthBloc>().add(
          AuthSignUpRequested(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
            acceptTerms: _acceptedTerms,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current.action == AuthAction.signUp &&
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
          context.goNamed(MainShellPage.routeName);
        }
      },
      builder: (context, state) {
        final isSubmitting =
            state.isLoading && state.action == AuthAction.signUp;

        return AuthShell(
          title: l10n.signUpTitle,
          subtitle: l10n.signUpSubtitle,
          primaryButtonLabel: l10n.signUpCta,
          onPrimaryPressed: _submit,
          isPrimaryLoading: isSubmitting,
          footerPrompt: l10n.alreadyHaveAccountPrompt,
          footerActionLabel: l10n.signInLink,
          onFooterActionPressed: () {
            context.pop();
          },
          formChildren: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  AuthTextField(
                    label: l10n.fullNameLabel,
                    hintText: l10n.fullNameHint,
                    controller: _fullNameController,
                    prefixIcon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.fullNameRequiredError;
                      }
                      return null;
                    },
                  ),
                  AuthTextField(
                    label: l10n.emailLabel,
                    hintText: l10n.emailHint,
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.emailRequiredError;
                      }
                      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return l10n.emailInvalidError;
                      }
                      return null;
                    },
                  ),
                  AuthTextField(
                    label: l10n.phoneLabel,
                    hintText: l10n.phoneHint,
                    controller: _phoneController,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.phoneRequiredError;
                      }
                      final normalized = value.replaceAll(RegExp(r'\s+'), '');
                      final phoneRegex = RegExp(r'^\+?[0-9]{9,15}$');
                      if (!phoneRegex.hasMatch(normalized)) {
                        return l10n.phoneInvalidError;
                      }
                      return null;
                    },
                  ),
                  AuthTextField(
                    label: l10n.addressLabel,
                    hintText: l10n.addressHint,
                    controller: _addressController,
                    prefixIcon: Icons.location_on_outlined,
                    keyboardType: TextInputType.streetAddress,
                    minLines: 2,
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.addressRequiredError;
                      }
                      if (value.trim().length > 300) {
                        return l10n.addressTooLongError;
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
                  AuthTextField(
                    label: l10n.confirmPasswordLabel,
                    hintText: l10n.confirmPasswordHint,
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptedTerms,
                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFFF8A3D),
                          side: const BorderSide(color: Color(0xFFD9CEC4)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  color: Color(0xFF8D8D8D),
                                  fontSize: 12,
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(text: l10n.acceptTermsPrefix),
                                  TextSpan(
                                    text: l10n.termsAndPolicy,
                                    style: const TextStyle(
                                      color: Color(0xFFB45A17),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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

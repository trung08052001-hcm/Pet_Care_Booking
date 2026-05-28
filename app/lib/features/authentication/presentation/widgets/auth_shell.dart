import 'package:app/core/app_localizations.dart';
import 'package:flutter/material.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.formChildren,
    required this.primaryButtonLabel,
    required     this.onPrimaryPressed,
    this.isPrimaryLoading = false,
    this.onGooglePressed,
    this.onZaloPressed,
    this.isSocialLoading = false,
    this.isGoogleLoading = false,
    this.isZaloLoading = false,
    this.footerPrompt,
    this.footerActionLabel,
    this.onFooterActionPressed,
    this.showSocialSection = true,
    this.topLeading,
  });

  final String title;
  final String subtitle;
  final List<Widget> formChildren;
  final String primaryButtonLabel;
  final VoidCallback onPrimaryPressed;
  final bool isPrimaryLoading;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onZaloPressed;
  final bool isSocialLoading;
  final bool isGoogleLoading;
  final bool isZaloLoading;
  final String? footerPrompt;
  final String? footerActionLabel;
  final VoidCallback? onFooterActionPressed;
  final bool showSocialSection;
  final Widget? topLeading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F1E7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBF7),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (topLeading != null) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: topLeading!,
                      ),
                      const SizedBox(height: 10),
                    ],
                    const _AuthBrandHeader(),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF2F2F2F),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF8E8E8E),
                              fontSize: 13,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 22),
                          ...formChildren,
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 54,
                            child: FilledButton(
                              onPressed: isPrimaryLoading ? null : onPrimaryPressed,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8A3D),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              child: isPrimaryLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(primaryButtonLabel),
                                        const SizedBox(width: 8),
                                        const Icon(Icons.arrow_forward_rounded),
                                      ],
                                    ),
                            ),
                          ),
                          if (showSocialSection) ...[
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                const Expanded(child: Divider()),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    l10n.orContinueWith,
                                    style: const TextStyle(
                                      color: Color(0xFF9D9D9D),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                const Expanded(child: Divider()),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Expanded(
                                  child: _SocialAuthButton(
                                    brand: _SocialBrand.google,
                                    onPressed: onGooglePressed,
                                    isLoading:
                                        isGoogleLoading || isSocialLoading,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _SocialAuthButton(
                                    brand: _SocialBrand.zalo,
                                    onPressed: onZaloPressed,
                                    isLoading: isZaloLoading || isSocialLoading,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (footerPrompt != null &&
                        footerActionLabel != null &&
                        onFooterActionPressed != null) ...[
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            footerPrompt!,
                            style: const TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: onFooterActionPressed,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFB45A17),
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              footerActionLabel!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthBrandHeader extends StatelessWidget {
  const _AuthBrandHeader();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: const BoxDecoration(
            color: Color(0xFFFFF1E6),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.pets_rounded,
            color: Color(0xFFFF8A3D),
            size: 28,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          l10n.onboardingBrand,
          style: const TextStyle(
            color: Color(0xFFB45A17),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8B8B8B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(
                prefixIcon,
                color: const Color(0xFFC4B7AB),
                size: 20,
              ),
              suffixIcon: suffix,
              filled: true,
              fillColor: const Color(0xFFFFFBF7),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFEADFD6),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFEADFD6),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Color(0xFFFFB37A),
                  width: 1.2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE57373)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE57373)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _SocialBrand {
  google,
  zalo,
}

class _SocialAuthButton extends StatelessWidget {
  const _SocialAuthButton({
    required this.brand,
    this.onPressed,
    this.isLoading = false,
  });

  final _SocialBrand brand;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isGoogle = brand == _SocialBrand.google;
    final label = isGoogle ? 'Google' : 'Zalo';

    return Material(
      color: const Color(0xFFF2F7F8),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE4ECEE)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else ...[
                isGoogle ? const _GoogleMark() : const _ZaloMark(),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF65727A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleMark extends StatelessWidget {
  const _GoogleMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: RichText(
        text: const TextSpan(
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          children: [
            TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
            TextSpan(text: '', style: TextStyle(color: Color(0xFFEA4335))),
          ],
        ),
      ),
    );
  }
}

class _ZaloMark extends StatelessWidget {
  const _ZaloMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFD7E6FF)),
      ),
      alignment: Alignment.center,
      child: const Text(
        'Z',
        style: TextStyle(
          color: Color(0xFF0068FF),
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/app_localizations.dart';
import 'package:app/core/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguageSettingsPage extends StatelessWidget {
  const LanguageSettingsPage({super.key});

  static const String routeName = 'language-settings';
  static const String routePath = '/profile/language';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LanguageHeader(
                      title: l10n.languageSettingsTitle,
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      l10n.languageSettingsTitle,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.languageSettingsSubtitle,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.35,
                        color: AppColors.brownText.withValues(alpha: 0.58),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.chooseLanguage,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 14),
                    BlocBuilder<LocaleCubit, Locale>(
                      builder: (context, locale) {
                        return Column(
                          children: [
                            _LanguageTile(
                              title: l10n.vietnamese,
                              description: l10n.vietnameseDescription,
                              languageCode: 'VI',
                              selected: locale.languageCode == 'vi',
                              currentLabel: l10n.currentLanguage,
                              onTap: () => _changeLocale(
                                context,
                                const Locale('vi'),
                              ),
                            ),
                            const SizedBox(height: 14),
                            _LanguageTile(
                              title: l10n.english,
                              description: l10n.englishDescription,
                              languageCode: 'EN',
                              selected: locale.languageCode == 'en',
                              currentLabel: l10n.currentLanguage,
                              onTap: () => _changeLocale(
                                context,
                                const Locale('en'),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLocale(BuildContext context, Locale locale) async {
    final l10n = AppLocalizations.of(context);
    await context.read<LocaleCubit>().changeLocale(locale);
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(l10n.languageSaved),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}

class _LanguageHeader extends StatelessWidget {
  const _LanguageHeader({
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.brown,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.heroBg.withValues(alpha: 0.7),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.title,
    required this.description,
    required this.languageCode,
    required this.selected,
    required this.currentLabel,
    required this.onTap,
  });

  final String title;
  final String description;
  final String languageCode;
  final bool selected;
  final String currentLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.primary.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.divider.withValues(alpha: 0.9),
              width: selected ? 1.4 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.heroBg.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  languageCode,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.brownText.withValues(alpha: 0.58),
                      ),
                    ),
                    if (selected) ...[
                      const SizedBox(height: 8),
                      Text(
                        currentLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected ? AppColors.primary : AppColors.mutedText,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

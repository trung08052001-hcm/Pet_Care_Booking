import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:app/features/profile/presentation/bloc/help_center_bloc.dart';
import 'package:app/features/profile/presentation/bloc/help_center_event.dart';
import 'package:app/features/profile/presentation/bloc/help_center_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const String routeName = 'help-center';
  static const String routePath = '/profile/help-center';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HelpCenterBloc, HelpCenterState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message == null) {
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        context
            .read<HelpCenterBloc>()
            .add(const HelpCenterFeedbackConsumed());
      },
      builder: (context, state) {
        final content = state.filteredContent;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HelpHeader(onBack: () => Navigator.pop(context)),
                        const SizedBox(height: 26),
                        _SearchField(
                          onChanged: (value) => context
                              .read<HelpCenterBloc>()
                              .add(HelpCenterSearchChanged(value)),
                        ),
                        const SizedBox(height: 34),
                        const Text(
                          'Bạn cần hỗ trợ về?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.brownText,
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (state.isLoading || content == null)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else ...[
                          _CategoryGrid(categories: content.categories),
                          const SizedBox(height: 30),
                          const _ContactSupportCard(),
                          const SizedBox(height: 32),
                          _FaqHeader(
                            onViewAll: () => context
                                .read<HelpCenterBloc>()
                                .add(const HelpCenterRequestPressed()),
                          ),
                          const SizedBox(height: 16),
                          _FaqList(questions: content.faqs),
                          const SizedBox(height: 32),
                          const _RequestSupportCard(),
                          const SizedBox(height: 28),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HelpHeader extends StatelessWidget {
  const _HelpHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.brown,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.heroBg.withValues(alpha: 0.7),
            fixedSize: const Size(48, 48),
          ),
        ),
        const Expanded(
          child: Text(
            'Trung tâm trợ giúp',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 27,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontSize: 16, color: AppColors.brownText),
      decoration: InputDecoration(
        hintText: 'Tìm kiếm câu hỏi, chủ đề...',
        hintStyle: TextStyle(
          color: AppColors.brownText.withValues(alpha: 0.48),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.mutedText,
          size: 28,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F5F4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<HelpCenterCategory> categories;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const _EmptySearchResult();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(category: category);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final HelpCenterCategory category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context
            .read<HelpCenterBloc>()
            .add(HelpCenterCategoryPressed(category.id)),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.045),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  category.icon,
                  color: AppColors.primaryDark,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        color: AppColors.brownText.withValues(alpha: 0.58),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD9C7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primaryDark,
              size: 42,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Không tìm thấy giải pháp?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đội ngũ PawSitive Care luôn sẵn sàng hỗ trợ bạn.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.brownText.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          FilledButton(
            onPressed: () => context
                .read<HelpCenterBloc>()
                .add(const HelpCenterContactPressed()),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Liên hệ ngay',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Câu hỏi thường gặp',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          child: const Text('Xem tất cả'),
        ),
      ],
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList({required this.questions});

  final List<String> questions;

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const _EmptySearchResult();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List.generate(questions.length, (index) {
          final question = questions[index];
          final isLast = index == questions.length - 1;

          return Column(
            children: [
              ListTile(
                onTap: () => context
                    .read<HelpCenterBloc>()
                    .add(HelpCenterFaqPressed(question)),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 3,
                ),
                title: Text(
                  question,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.brownText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.mutedText,
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                  color: AppColors.divider.withValues(alpha: 0.8),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _RequestSupportCard extends StatelessWidget {
  const _RequestSupportCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.description_outlined,
              color: AppColors.primaryDark,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bạn chưa tìm thấy câu trả lời?',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Gửi yêu cầu hỗ trợ, chúng tôi sẽ phản hồi sớm nhất.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.brownText.withValues(alpha: 0.58),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          TextButton(
            onPressed: () => context
                .read<HelpCenterBloc>()
                .add(const HelpCenterRequestPressed()),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.14),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Gửi yêu cầu',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Không tìm thấy nội dung phù hợp.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.mutedText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

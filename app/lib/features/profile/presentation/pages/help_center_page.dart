import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:app/features/profile/presentation/bloc/help_center_bloc.dart';
import 'package:app/features/profile/presentation/bloc/help_center_event.dart';
import 'package:app/features/profile/presentation/bloc/help_center_state.dart';
import 'package:app/features/profile/presentation/pages/help_center_detail_page.dart';
import 'package:app/features/profile/presentation/pages/help_center_faq_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  static const String routeName = 'help-center';
  static const String routePath = '/profile/help-center';

  Future<void> _callSupport(BuildContext context, String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    final launched = await launchUrl(uri);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể mở cuộc gọi tới $phone.')),
      );
    }
  }

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
        final content = state.content;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HelpHeader(onBack: () => Navigator.pop(context)),
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
                        if (state.isLoading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else if (state.status == HelpCenterStatus.failure ||
                            content == null)
                          _ErrorPanel(
                            onRetry: () => context
                                .read<HelpCenterBloc>()
                                .add(const HelpCenterStarted()),
                          )
                        else
                          _HelpContent(
                            content: content,
                            onCallSupport: () =>
                                _callSupport(context, content.contactPhone),
                          ),
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

class _HelpContent extends StatelessWidget {
  const _HelpContent({
    required this.content,
    required this.onCallSupport,
  });

  final HelpCenterContent content;
  final VoidCallback onCallSupport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CategoryGrid(categories: content.categories),
        const SizedBox(height: 28),
        _ContactSupportCard(onCallSupport: onCallSupport),
        const SizedBox(height: 30),
        _FaqHeader(
          onViewAll: () => context
              .read<HelpCenterBloc>()
              .add(const HelpCenterRequestPressed()),
        ),
        const SizedBox(height: 16),
        _FaqList(faqs: content.faqs),
        const SizedBox(height: 30),
        const _RequestSupportCard(),
      ],
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({required this.categories});

  final List<HelpCenterCategory> categories;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.92,
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
            .pushNamed(
              HelpCenterDetailPage.routeName,
              pathParameters: {'topicName': category.name},
              extra: category,
            ),
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(
                      _iconFor(category.icon),
                      color: AppColors.primaryDark,
                      size: 31,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.mutedText,
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                category.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.15,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brownText,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Text(
                  category.detail,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: AppColors.brownText.withValues(alpha: 0.58),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String icon) {
    return switch (icon) {
      'booking' => Icons.calendar_month_outlined,
      'payment' => Icons.account_balance_wallet_outlined,
      'security' => Icons.verified_user_outlined,
      'pets' => Icons.pets_rounded,
      _ => Icons.help_outline_rounded,
    };
  }
}

class _ContactSupportCard extends StatelessWidget {
  const _ContactSupportCard({required this.onCallSupport});

  final VoidCallback onCallSupport;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Column(
        children: [
          Row(
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
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onCallSupport,
              icon: const Icon(Icons.phone_rounded, size: 19),
              label: const Text('Liên hệ ngay'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brown,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
                elevation: 0,
              ),
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
  const _FaqList({required this.faqs});

  final List<HelpCenterFaq> faqs;

  @override
  Widget build(BuildContext context) {
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
        children: List.generate(faqs.length, (index) {
          final faq = faqs[index];
          final isLast = index == faqs.length - 1;

          return Column(
            children: [
              ListTile(
                onTap: () => context.pushNamed(
                  HelpCenterFaqDetailPage.routeName,
                  pathParameters: {'faqId': faq.id},
                  extra: faq,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 3,
                ),
                title: Text(
                  faq.title,
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

  Future<void> _showFeedbackDialog(BuildContext context) async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Gửi yêu cầu hỗ trợ',
            style: TextStyle(
              color: AppColors.brownText,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              minLines: 4,
              maxLines: 6,
              maxLength: 1000,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Nhập nội dung bạn cần hỗ trợ...',
                filled: true,
                fillColor: AppColors.heroBg.withValues(alpha: 0.35),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.8),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: AppColors.divider.withValues(alpha: 0.8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập nội dung cần hỗ trợ.';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                final message = controller.text.trim();
                Navigator.pop(dialogContext);
                context
                    .read<HelpCenterBloc>()
                    .add(HelpCenterFeedbackSubmitted(message));
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brown,
                foregroundColor: Colors.white,
              ),
              child: const Text('Gửi'),
            ),
          ],
        );
      },
    );

    controller.dispose();
  }

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
            onPressed: () => _showFeedbackDialog(context),
            style: TextButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.14),
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Text(
            'Không tải được trung tâm trợ giúp.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.mutedText,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

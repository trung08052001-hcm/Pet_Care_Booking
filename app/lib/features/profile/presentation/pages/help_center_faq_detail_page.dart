import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/domain/entities/help_center_content.dart';
import 'package:flutter/material.dart';

class HelpCenterFaqDetailPage extends StatelessWidget {
  const HelpCenterFaqDetailPage({
    super.key,
    required this.faq,
  });

  static const String routeName = 'help-center-faq-detail';
  static const String routePath = '/profile/help-center/faq/:faqId';

  final HelpCenterFaq faq;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FaqHeader(
                      title: faq.title,
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 24),
                    _FaqImage(imageUrl: faq.imageUrl),
                    const SizedBox(height: 24),
                    _FaqInfoCard(
                      icon: Icons.help_outline_rounded,
                      title: 'Thông tin câu hỏi',
                      child: Text(
                        faq.description,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.45,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _FaqInfoCard(
                      icon: Icons.description_outlined,
                      title: 'Chi tiết hỗ trợ',
                      child: Text(
                        faq.detail,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.45,
                          color: Colors.black87,
                        ),
                      ),
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
}

class _FaqHeader extends StatelessWidget {
  const _FaqHeader({
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          color: AppColors.brown,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.heroBg.withValues(alpha: 0.75),
            fixedSize: const Size(54, 54),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 25,
              height: 1.12,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqImage extends StatelessWidget {
  const _FaqImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: AspectRatio(
        aspectRatio: 1.6,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: AppColors.heroBg,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.primary,
                size: 44,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FaqInfoCard extends StatelessWidget {
  const _FaqInfoCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.heroBg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
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
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.13),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryDark),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brownText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/domain/entities/help_center_category.dart';
import 'package:flutter/material.dart';

class HelpCenterDetailPage extends StatelessWidget {
  const HelpCenterDetailPage({
    super.key,
    required this.topic,
  });

  static const String routeName = 'help-center-detail';
  static const String routePath = '/profile/help-center/:topicName';

  final HelpCenterCategory topic;

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
                  children: [
                    _DetailHeader(
                      title: topic.name,
                      onBack: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 28),
                    _TopicImage(imageUrl: topic.imageUrl),
                    const SizedBox(height: 26),
                    _SupportInfoCard(topic: topic),
                    const SizedBox(height: 22),
                    _ProgramDescriptionCard(description: topic.programDescription),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: FilledButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Đã ghi nhận yêu cầu ${topic.name}.',
                              ),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.brown,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          topic.actionLabel,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
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

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24),
          color: AppColors.brown,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.heroBg.withValues(alpha: 0.75),
            fixedSize: const Size(58, 58),
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 30,
              height: 1.1,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
        ),
        const SizedBox(width: 58),
      ],
    );
  }
}

class _TopicImage extends StatelessWidget {
  const _TopicImage({required this.imageUrl});

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

class _SupportInfoCard extends StatelessWidget {
  const _SupportInfoCard({required this.topic});

  final HelpCenterCategory topic;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.pets_rounded,
      title: 'Thông tin hỗ trợ',
      child: Column(
        children: topic.supportInfo
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.label,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 1.25,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ProgramDescriptionCard extends StatelessWidget {
  const _ProgramDescriptionCard({required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      icon: Icons.description_outlined,
      title: 'Mô tả chương trình',
      child: Text(
        description,
        style: const TextStyle(
          fontSize: 17,
          height: 1.45,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brownText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

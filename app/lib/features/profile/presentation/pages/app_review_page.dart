import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/presentation/bloc/app_review_bloc.dart';
import 'package:app/features/profile/presentation/bloc/app_review_event.dart';
import 'package:app/features/profile/presentation/bloc/app_review_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppReviewPage extends StatefulWidget {
  const AppReviewPage({super.key});

  static const String routeName = 'app-review';
  static const String routePath = '/profile/app-review';

  @override
  State<AppReviewPage> createState() => _AppReviewPageState();
}

class _AppReviewPageState extends State<AppReviewPage> {
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppReviewBloc, AppReviewState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message == null) {
          return;
        }
        if (state.interaction == AppReviewInteraction.submitted) {
          _commentController.clear();
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        context.read<AppReviewBloc>().add(const AppReviewMessageConsumed());
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFEFFBFB),
          body: SafeArea(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                    child: Column(
                      children: [
                        _ReviewHeader(onBack: () => Navigator.pop(context)),
                        const SizedBox(height: 28),
                        const _ReviewHeroImage(),
                        const SizedBox(height: 28),
                        _ReviewFormCard(
                          state: state,
                          controller: _commentController,
                          onRatingSelected: (rating) => context
                              .read<AppReviewBloc>()
                              .add(AppReviewRatingSelected(rating)),
                          onCommentChanged: (comment) => context
                              .read<AppReviewBloc>()
                              .add(AppReviewCommentChanged(comment)),
                          onSubmit: () => context
                              .read<AppReviewBloc>()
                              .add(const AppReviewSubmitted()),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primaryDark,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          child: const Text('Để sau'),
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

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.primaryDark,
        ),
        const SizedBox(width: 6),
        const Expanded(
          child: Text(
            'PawSitive Care',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
        ),
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors.heroBg,
          child: Text(
            'P',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w900,
              color: AppColors.brown.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewHeroImage extends StatelessWidget {
  const _ReviewHeroImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      height: 184,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=600&q=80',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: AppColors.heroBg,
            child: const Icon(
              Icons.pets_rounded,
              color: AppColors.primary,
              size: 58,
            ),
          );
        },
      ),
    );
  }
}

class _ReviewFormCard extends StatelessWidget {
  const _ReviewFormCard({
    required this.state,
    required this.controller,
    required this.onRatingSelected,
    required this.onCommentChanged,
    required this.onSubmit,
  });

  final AppReviewState state;
  final TextEditingController controller;
  final ValueChanged<int> onRatingSelected;
  final ValueChanged<String> onCommentChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Bạn thấy app thế nào?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Chia sẻ trải nghiệm của bạn để giúp chúng mình hoàn thiện hơn nhé!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.28,
              color: AppColors.brownText.withValues(alpha: 0.66),
            ),
          ),
          const SizedBox(height: 22),
          _StarPicker(
            rating: state.rating,
            onRatingSelected: onRatingSelected,
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Để lại bình luận',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.brownText.withValues(alpha: 0.82),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            minLines: 4,
            maxLines: 5,
            maxLength: 1000,
            onChanged: onCommentChanged,
            textInputAction: TextInputAction.newline,
            style: const TextStyle(
              fontSize: 14,
              height: 1.35,
              color: AppColors.brownText,
            ),
            decoration: InputDecoration(
              hintText: 'App rất dễ dùng, nhân viên chăm sóc rất chu đáo...',
              hintStyle: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.45),
                fontSize: 14,
              ),
              counterText: '',
              filled: true,
              fillColor: const Color(0xFFEAF7F7),
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              onPressed: state.canSubmit ? onSubmit : null,
              iconAlignment: IconAlignment.end,
              icon: state.isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.2,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 18),
              label: Text(state.isSubmitting ? 'Đang gửi...' : 'Gửi đánh giá'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
                foregroundColor: AppColors.brownText,
                disabledForegroundColor:
                    AppColors.brownText.withValues(alpha: 0.45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 0,
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StarPicker extends StatelessWidget {
  const _StarPicker({
    required this.rating,
    required this.onRatingSelected,
  });

  final int rating;
  final ValueChanged<int> onRatingSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final value = index + 1;
        final selected = value <= rating;
        return IconButton(
          onPressed: () => onRatingSelected(value),
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          padding: EdgeInsets.zero,
          icon: Icon(
            selected ? Icons.star_rounded : Icons.star_border_rounded,
            size: 31,
            color: selected
                ? AppColors.primary
                : AppColors.brown.withValues(alpha: 0.34),
          ),
        );
      }),
    );
  }
}

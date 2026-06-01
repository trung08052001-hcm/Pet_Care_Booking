import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/entities/blog_weekly_tip.dart';
import 'package:app/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:app/features/blog/presentation/bloc/blog_event.dart';
import 'package:app/features/blog/presentation/bloc/blog_state.dart';
import 'package:app/features/blog/presentation/mappers/blog_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogBloc, BlogState>(
      builder: (context, state) {
        if (state.status == BlogStatus.failure) {
          return _BlogErrorView(
            message: state.message ?? 'Không tải được nội dung blog.',
            onRetry: () =>
                context.read<BlogBloc>().add(const BlogRefreshRequested()),
          );
        }

        if (state.isLoading || state.content == null) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return _BlogContent(
          content: state.content!,
          selectedCategory: state.selectedCategory,
          searchQuery: state.searchQuery,
          featured: state.visibleFeatured,
          latestPosts: state.visibleLatestPosts,
        );
      },
    );
  }
}

class _BlogErrorView extends StatelessWidget {
  const _BlogErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedText),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogContent extends StatelessWidget {
  const _BlogContent({
    required this.content,
    required this.selectedCategory,
    required this.searchQuery,
    required this.featured,
    required this.latestPosts,
  });

  final BlogPageContent content;
  final BlogCategoryFilter selectedCategory;
  final String searchQuery;
  final BlogPost? featured;
  final List<BlogPost> latestPosts;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<BlogBloc>();

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        bloc.add(const BlogRefreshRequested());
        await bloc.stream.firstWhere(
          (state) =>
              state.status == BlogStatus.success ||
              state.status == BlogStatus.failure,
        );
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _BlogAppBar(
              onNotificationsPressed: () =>
                  bloc.add(const BlogNotificationsPressed()),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BlogSearchBar(
                    hint: content.searchHint,
                    initialQuery: searchQuery,
                    onQueryChanged: (query) =>
                        bloc.add(BlogSearchQueryChanged(query)),
                  ),
                  const SizedBox(height: 16),
                  _CategoryFilterRow(
                    selectedCategory: selectedCategory,
                    onCategorySelected: (category) =>
                        bloc.add(BlogCategoryFilterChanged(category)),
                  ),
                  const SizedBox(height: 24),
                  if (featured != null) ...[
                    Text(
                      content.forYouSectionTitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _FeaturedPostCard(
                      post: featured!,
                      onTap: () =>
                          bloc.add(BlogFeaturedPostPressed(featured!.id)),
                    ),
                    const SizedBox(height: 24),
                  ],
                  _SectionHeader(
                    title: content.latestSectionTitle,
                    onSeeAll: () => bloc.add(const BlogSeeAllPostsPressed()),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          if (latestPosts.isEmpty && featured == null)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  'Không tìm thấy bài viết phù hợp.',
                  style: TextStyle(color: AppColors.mutedText),
                ),
              ),
            )
          else if (latestPosts.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList.separated(
                itemCount: latestPosts.length,
                separatorBuilder: (context, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final post = latestPosts[index];
                  return _LatestPostTile(
                    post: post,
                    onTap: () => bloc.add(BlogPostPressed(post.id)),
                  );
                },
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: _WeeklyTipCard(
                tip: content.weeklyTip,
                onAction: () => bloc.add(const BlogWeeklyTipActionPressed()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlogAppBar extends StatelessWidget {
  const _BlogAppBar({required this.onNotificationsPressed});

  final VoidCallback onNotificationsPressed;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 8, 4),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'PawSitive Care',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
                letterSpacing: -0.3,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: onNotificationsPressed,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.brownText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlogSearchBar extends StatefulWidget {
  const _BlogSearchBar({
    required this.hint,
    required this.initialQuery,
    required this.onQueryChanged,
  });

  final String hint;
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;

  @override
  State<_BlogSearchBar> createState() => _BlogSearchBarState();
}

class _BlogSearchBarState extends State<_BlogSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onQueryChanged,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(
          color: AppColors.mutedText.withValues(alpha: 0.9),
          fontSize: 14,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.mutedText,
        ),
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(color: AppColors.divider.withValues(alpha: 0.8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final BlogCategoryFilter selectedCategory;
  final ValueChanged<BlogCategoryFilter> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: BlogUiMapper.filterChips.length,
        separatorBuilder: (context, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = BlogUiMapper.filterChips[index];
          final isSelected = category == selectedCategory;

          return GestureDetector(
            onTap: () => onCategorySelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.cardBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary,
                  width: isSelected ? 0 : 1,
                ),
              ),
              child: Text(
                BlogUiMapper.categoryLabel(category),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onSeeAll,
  });

  final String title;
  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.brownText,
            ),
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _FeaturedPostCard extends StatelessWidget {
  const _FeaturedPostCard({
    required this.post,
    required this.onTap,
  });

  final BlogPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF9CCC65),
              Color(0xFFD7CCC8),
            ],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -12,
              bottom: -8,
              child: Icon(
                Icons.pets,
                size: 120,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      post.categoryLabel,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    post.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if (post.readTimeMinutes != null) ...[
                        Icon(
                          Icons.schedule_rounded,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          BlogUiMapper.formatReadTime(post.readTimeMinutes!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(width: 14),
                      ],
                      if (post.authorName != null) ...[
                        Icon(
                          Icons.medical_services_outlined,
                          size: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            post.authorName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LatestPostTile extends StatelessWidget {
  const _LatestPostTile({
    required this.post,
    required this.onTap,
  });

  final BlogPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: BlogUiMapper.placeholderColor(post.imagePlaceholderColor),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.image_outlined,
                color: AppColors.brownText.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.categoryLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: AppColors.brownText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.mutedText.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        BlogUiMapper.formatPublishedDate(post.publishedAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.visibility_outlined,
                        size: 13,
                        color: AppColors.mutedText.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        BlogUiMapper.formatViewCount(post.viewCount),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyTipCard extends StatelessWidget {
  const _WeeklyTipCard({
    required this.tip,
    required this.onAction,
  });

  final BlogWeeklyTip tip;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.heroBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline_rounded,
                size: 20,
                color: AppColors.primary.withValues(alpha: 0.9),
              ),
              const SizedBox(width: 8),
              Text(
                tip.badgeLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.brownText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tip.body,
            style: TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.brownText.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              elevation: 0,
            ),
            child: Text(
              tip.ctaLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/entities/blog_social.dart';
import 'package:app/features/blog/presentation/mappers/blog_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class BlogDetailPage extends StatefulWidget {
  const BlogDetailPage({
    required this.postId,
    this.initialPost,
    super.key,
  });

  static const routeName = 'blog-detail';
  static const routePath = '/blog/:postId';

  final String postId;
  final BlogPost? initialPost;

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  final TextEditingController _commentController = TextEditingController();
  late final BlogRemoteDataSource _remoteDataSource;
  late final BlogArticleContent _article;
  BlogSocial _social = const BlogSocial();
  bool _isSocialLoading = true;
  bool _isSendingComment = false;
  String _socialError = '';

  @override
  void initState() {
    super.initState();
    _remoteDataSource = getIt<BlogRemoteDataSource>();
    _article = BlogArticleContent.fromPostId(widget.postId, widget.initialPost);
    _loadSocial();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _loadSocial() async {
    try {
      final social = await _remoteDataSource.getSocial(_article.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _social = social;
        _isSocialLoading = false;
        _socialError = '';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isSocialLoading = false;
        _socialError = 'Không tải được tương tác bài viết.';
      });
    }
  }

  Future<void> _toggleLike() async {
    try {
      final social = await _remoteDataSource.toggleLike(_article.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _social = social;
        _socialError = '';
      });
    } catch (_) {
      _showSnack('Bạn cần đăng nhập để thích bài viết.');
    }
  }

  Future<void> _sendComment() async {
    final body = _commentController.text.trim();
    if (body.isEmpty || _isSendingComment) {
      return;
    }

    setState(() => _isSendingComment = true);

    try {
      final social = await _remoteDataSource.addComment(_article.id, body);
      if (!mounted) {
        return;
      }
      _commentController.clear();
      FocusScope.of(context).unfocus();
      setState(() {
        _social = social;
        _isSendingComment = false;
        _socialError = '';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }
      setState(() => _isSendingComment = false);
      _showSnack('Bạn cần đăng nhập để bình luận.');
    }
  }

  Future<void> _registerShare() async {
    try {
      final social = await _remoteDataSource.registerShare(_article.id);
      if (mounted) {
        setState(() => _social = social);
      }
    } catch (_) {
      // Share UI should still work even if the counter cannot be synced.
    }
  }

  Future<void> _openShareSheet() async {
    await _registerShare();
    if (!mounted) {
      return;
    }
    final shareLink = 'https://pawsitive-care.local/blog/${_article.id}';
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) => _ShareSheet(
        title: _article.title,
        link: shareLink,
        onCopied: () => _showSnack('Đã copy link bài viết.'),
      ),
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _ArticleHero(article: _article)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 148),
                sliver: SliverList.list(
                  children: [
                    _ArticleSummary(
                      article: _article,
                      social: _social,
                      onLike: _toggleLike,
                      onShare: _openShareSheet,
                    ),
                    const SizedBox(height: 22),
                    _ArticleOutline(items: _article.outline),
                    const SizedBox(height: 24),
                    Text(
                      _article.intro,
                      style: _bodyStyle,
                    ),
                    const SizedBox(height: 26),
                    for (final section in _article.sections) ...[
                      _ArticleSection(section: section),
                      const SizedBox(height: 28),
                    ],
                    _VetCtaCard(article: _article),
                    const SizedBox(height: 26),
                    const Text(
                      'Kết luận',
                      style: _headingStyle,
                    ),
                    const SizedBox(height: 10),
                    Text(_article.conclusion, style: _bodyStyle),
                    const SizedBox(height: 30),
                    _CommentsSection(
                      social: _social,
                      isLoading: _isSocialLoading,
                      error: _socialError,
                    ),
                    const SizedBox(height: 30),
                    _RelatedPosts(posts: _article.relatedPosts),
                    const SizedBox(height: 28),
                    _AuthorCard(article: _article),
                    const SizedBox(height: 24),
                    const _NewsletterCard(),
                    const SizedBox(height: 24),
                    const _ArticleRatingCard(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BlogBottomChrome(
              article: _article,
              controller: _commentController,
              social: _social,
              isSendingComment: _isSendingComment,
              onCommentSubmitted: _sendComment,
              onLike: _toggleLike,
              onShare: _openShareSheet,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleHero extends StatelessWidget {
  const _ArticleHero({required this.article});

  final BlogArticleContent article;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: 360,
          width: double.infinity,
          child: _ArticleImage(url: article.heroImageUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: topPadding + 14,
          left: 16,
          right: 16,
          child: Row(
            children: [
              _RoundButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onTap: () => Navigator.of(context).maybePop(),
              ),
              const Spacer(),
              _RoundButton(
                icon: Icons.bookmark_border_rounded,
                onTap: () {},
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 280),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryPill(label: article.categoryLabel),
              const SizedBox(height: 16),
              Text(
                article.title,
                style: const TextStyle(
                  fontSize: 25,
                  height: 1.24,
                  fontWeight: FontWeight.w900,
                  color: AppColors.brownText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 42,
          height: 42,
          child: Icon(icon, size: 20, color: AppColors.brownText),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class _ArticleSummary extends StatelessWidget {
  const _ArticleSummary({
    required this.article,
    required this.social,
    required this.onLike,
    required this.onShare,
  });

  final BlogArticleContent article;
  final BlogSocial social;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.14),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                color: AppColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${article.authorName}  •  ${article.publishedLabel}  •  ${article.readTimeLabel}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.brownText.withValues(alpha: 0.62),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(article.summary, style: _bodyStyle),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _ArticleAction(
              icon: social.likedByMe
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              label: '${social.likeCount} Thích',
              active: social.likedByMe,
              onTap: onLike,
            ),
            _ArticleAction(
              icon: Icons.chat_bubble_outline_rounded,
              label: '${social.commentCount} Bình luận',
            ),
            _ArticleAction(
              icon: Icons.share_outlined,
              label: '${social.shareCount} Chia sẻ',
              onTap: onShare,
            ),
          ],
        ),
      ],
    );
  }
}

class _ArticleAction extends StatelessWidget {
  const _ArticleAction({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.mutedText;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleOutline extends StatelessWidget {
  const _ArticleOutline({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trong bài viết',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.brownText,
            ),
          ),
          const SizedBox(height: 14),
          for (var index = 0; index < items.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.45,
                      color: AppColors.brownText.withValues(alpha: 0.72),
                    ),
                  ),
                ),
              ],
            ),
            if (index != items.length - 1) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _ArticleSection extends StatelessWidget {
  const _ArticleSection({required this.section});

  final BlogArticleSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: _headingStyle),
        const SizedBox(height: 12),
        Text(section.body, style: _bodyStyle),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: AspectRatio(
            aspectRatio: 1.55,
            child: _ArticleImage(url: section.imageUrl, fit: BoxFit.cover),
          ),
        ),
        if (section.tip != null) ...[
          const SizedBox(height: 14),
          _TipBox(text: section.tip!),
        ],
      ],
    );
  }
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage({
    required this.url,
    required this.fit,
  });

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => ColoredBox(
        color: const Color(0xFFF7E8DA),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            color: AppColors.brownText.withValues(alpha: 0.25),
            size: 48,
          ),
        ),
      ),
    );
  }
}

class _TipBox extends StatelessWidget {
  const _TipBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.lightbulb_outline_rounded,
            color: AppColors.primary,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: _smallBodyStyle)),
        ],
      ),
    );
  }
}

class _VetCtaCard extends StatelessWidget {
  const _VetCtaCard({required this.article});

  final BlogArticleContent article;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đặt lịch khám thú y dễ dàng qua ứng dụng PawSitive Care',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nhanh chóng - Tiện lợi - An tâm',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.brownText.withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đặt lịch ngay',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RelatedPosts extends StatelessWidget {
  const _RelatedPosts({required this.posts});

  final List<RelatedBlogPost> posts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bài viết liên quan', style: _headingStyle),
        const SizedBox(height: 16),
        for (final post in posts) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 92,
                  height: 100,
                  child: _ArticleImage(url: post.imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.categoryLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.meta,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (post != posts.last)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Divider(color: AppColors.divider.withValues(alpha: 0.8)),
            ),
        ],
      ],
    );
  }
}

class _AuthorCard extends StatelessWidget {
  const _AuthorCard({required this.article});

  final BlogArticleContent article;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: AppColors.primary,
                  size: 34,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.authorName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Nền tảng chăm sóc thú cưng hàng đầu Việt Nam. Chia sẻ kiến thức và kinh nghiệm chăm sóc hữu ích mỗi ngày.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.45,
                        color: AppColors.brownText.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialCircle(icon: Icons.facebook_rounded, color: Color(0xFF2266D4)),
              SizedBox(width: 14),
              _SocialCircle(icon: Icons.camera_alt_outlined, color: Color(0xFFFF4B7D)),
              SizedBox(width: 14),
              _SocialCircle(icon: Icons.play_arrow_rounded, color: Color(0xFFFF4A42)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialCircle extends StatelessWidget {
  const _SocialCircle({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.8)),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _NewsletterCard extends StatelessWidget {
  const _NewsletterCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhận thêm nhiều kiến thức hữu ích về chăm sóc thú cưng',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Đăng ký để nhận những bài viết mới nhất từ PawSitive Care.',
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: AppColors.brownText.withValues(alpha: 0.62),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Nhập email của bạn',
              prefixIcon: const Icon(Icons.mail_outline_rounded),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Đăng ký ngay',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chúng tôi cam kết không gửi spam. Bạn có thể hủy đăng ký bất kỳ lúc nào.',
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: AppColors.brownText.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleRatingCard extends StatelessWidget {
  const _ArticleRatingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Bạn thấy bài viết này hữu ích chứ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_border_rounded, color: AppColors.primary, size: 30),
              Icon(Icons.star_border_rounded, color: AppColors.primary, size: 30),
              Icon(Icons.star_border_rounded, color: AppColors.primary, size: 30),
              Icon(Icons.star_border_rounded, color: AppColors.primary, size: 30),
              Icon(Icons.star_border_rounded, color: AppColors.primary, size: 30),
            ],
          ),
          SizedBox(height: 10),
          Text(
            '4.8 (120 đánh giá)',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.brownText,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentsSection extends StatelessWidget {
  const _CommentsSection({
    required this.social,
    required this.isLoading,
    required this.error,
  });

  final BlogSocial social;
  final bool isLoading;
  final String error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Bình luận', style: _headingStyle),
            const SizedBox(width: 8),
            Text(
              '(${social.commentCount})',
              style: const TextStyle(
                color: AppColors.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (isLoading)
          const _CommentStatusCard(text: 'Đang tải bình luận...')
        else if (error.isNotEmpty)
          _CommentStatusCard(text: error)
        else if (social.comments.isEmpty)
          const _CommentStatusCard(text: 'Chưa có bình luận nào.')
        else
          for (final comment in social.comments) ...[
            _CommentTile(comment: comment),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _CommentStatusCard extends StatelessWidget {
  const _CommentStatusCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final BlogComment comment;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary.withValues(alpha: 0.14),
          backgroundImage:
              comment.userAvatar.isNotEmpty ? NetworkImage(comment.userAvatar) : null,
          child: comment.userAvatar.isEmpty
              ? Text(
                  comment.userName.isNotEmpty
                      ? comment.userName.characters.first.toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.userName,
                  style: const TextStyle(
                    color: AppColors.brownText,
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(comment.body, style: _smallBodyStyle),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ShareSheet extends StatelessWidget {
  const _ShareSheet({
    required this.title,
    required this.link,
    required this.onCopied,
  });

  final String title;
  final String link;
  final VoidCallback onCopied;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Chia sẻ bài viết', style: _headingStyle),
            const SizedBox(height: 6),
            Text(title, style: _smallBodyStyle),
            const SizedBox(height: 18),
            _ShareOption(
              icon: Icons.copy_rounded,
              label: 'Copy link',
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: link));
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
                onCopied();
              },
            ),
            _ShareOption(
              icon: Icons.sms_outlined,
              label: 'Share qua tin nhắn',
              onTap: () => _launchShareUri(context, Uri.parse('sms:?body=$link')),
            ),
            _ShareOption(
              icon: Icons.mail_outline_rounded,
              label: 'Share qua email',
              onTap: () => _launchShareUri(
                context,
                Uri(
                  scheme: 'mailto',
                  queryParameters: {
                    'subject': title,
                    'body': link,
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchShareUri(BuildContext context, Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _ShareOption extends StatelessWidget {
  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.brownText,
          fontWeight: FontWeight.w800,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _BlogBottomChrome extends StatelessWidget {
  const _BlogBottomChrome({
    required this.article,
    required this.controller,
    required this.social,
    required this.isSendingComment,
    required this.onCommentSubmitted,
    required this.onLike,
    required this.onShare,
  });

  final BlogArticleContent article;
  final TextEditingController controller;
  final BlogSocial social;
  final bool isSendingComment;
  final VoidCallback onCommentSubmitted;
  final VoidCallback onLike;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 8 + bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 3,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onCommentSubmitted(),
                  decoration: InputDecoration(
                    hintText: 'Viết bình luận...',
                    prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
                    suffixIcon: IconButton(
                      onPressed: isSendingComment ? null : onCommentSubmitted,
                      icon: isSendingComment
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF6F7F8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(22),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: onLike,
                icon: Icon(
                  social.likedByMe
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: social.likedByMe ? AppColors.primary : AppColors.brownText,
                ),
              ),
              const SizedBox(width: 18),
              IconButton(
                onPressed: onShare,
                icon: const Icon(Icons.share_outlined, color: AppColors.brownText),
              ),
              const SizedBox(width: 18),
              const Icon(Icons.bookmark_border_rounded, color: AppColors.brownText),
            ],
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _DetailNavItem(icon: Icons.home_outlined, label: 'Home'),
              _DetailNavItem(icon: Icons.pets_outlined, label: 'Services'),
              _DetailNavItem(icon: Icons.article_outlined, label: 'Blog', active: true),
              _DetailNavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Chat'),
              _DetailNavItem(icon: Icons.person_outline_rounded, label: 'Profile'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailNavItem extends StatelessWidget {
  const _DetailNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : AppColors.navInactive;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 21, color: color),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

const _headingStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w900,
  color: AppColors.brownText,
  height: 1.3,
);

const _bodyStyle = TextStyle(
  fontSize: 14,
  height: 1.72,
  color: Color(0xFF5D5353),
);

const _smallBodyStyle = TextStyle(
  fontSize: 13,
  height: 1.52,
  color: Color(0xFF5D5353),
);

class BlogArticleContent {
  const BlogArticleContent({
    required this.id,
    required this.title,
    required this.categoryLabel,
    required this.authorName,
    required this.publishedLabel,
    required this.readTimeLabel,
    required this.heroImageUrl,
    required this.summary,
    required this.outline,
    required this.intro,
    required this.sections,
    required this.conclusion,
    required this.relatedPosts,
  });

  factory BlogArticleContent.fromPostId(String postId, BlogPost? post) {
    final title = post?.title ??
        '5 dấu hiệu cho thấy thú cưng của bạn đang cần được nghỉ ngơi';
    final category = post?.category ?? BlogCategoryFilter.health;
    final categoryLabel = post?.categoryLabel ?? 'SỨC KHỎE';
    final publishedAt = post?.publishedAt ?? DateTime(2026, 5, 20);
    final readTime = post?.readTimeMinutes ?? 5;

    return BlogArticleContent(
      id: postId,
      title: title,
      categoryLabel: categoryLabel,
      authorName: post?.authorName ?? 'PawSitive Care',
      publishedLabel:
          '${BlogUiMapper.formatPublishedDate(publishedAt)}, ${publishedAt.year}',
      readTimeLabel: BlogUiMapper.formatReadTime(readTime),
      heroImageUrl: _postHeroImage(post, category, postId),
      summary: post?.shortDescription ??
          'Thú cưng cũng giống như con người, đôi khi chúng cần được nghỉ ngơi để phục hồi năng lượng và giữ sức khỏe tốt nhất.',
      outline: post?.sections.isNotEmpty == true
          ? post!.sections.map((section) => section.heading).toList(growable: false)
          : const [
              'Thú cưng ngủ nhiều hơn bình thường',
              'Mất hứng thú với hoạt động yêu thích',
              'Thay đổi thói quen ăn uống',
              'Dễ cáu gắt hoặc tránh xa bạn',
              'Cơ thể uể oải, ít vận động',
            ],
      intro: post?.intro ??
          'Việc nhận biết sớm những dấu hiệu mệt mỏi ở thú cưng sẽ giúp bạn có biện pháp chăm sóc và điều chỉnh kịp thời, giúp bé luôn khỏe mạnh và hạnh phúc.',
      sections: post?.sections.isNotEmpty == true
          ? _sectionsFromPost(post!)
          : _fallbackSections,
      conclusion: post?.conclusion ??
          'Hiểu và quan sát thú cưng mỗi ngày là cách tốt nhất để chăm sóc sức khỏe và tinh thần cho bé. Đừng quên cho bé thời gian nghỉ ngơi để luôn vui vẻ và khỏe mạnh nhé!',
      relatedPosts: const [
        RelatedBlogPost(
          title: 'Dấu hiệu thú cưng bị căng thẳng và cách khắc phục',
          categoryLabel: 'SỨC KHỎE',
          meta: '15 Thg 5, 2024 • 4 phút đọc',
          imageUrl:
              'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=500&q=80',
        ),
        RelatedBlogPost(
          title: 'Chế độ ăn cân bằng cho chó con trong 6 tháng đầu',
          categoryLabel: 'DINH DƯỠNG',
          meta: '10 Thg 5, 2024 • 6 phút đọc',
          imageUrl:
              'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?auto=format&fit=crop&w=500&q=80',
        ),
        RelatedBlogPost(
          title: 'Cách tắm cho mèo đúng cách tại nhà',
          categoryLabel: 'CHĂM SÓC',
          meta: '05 Thg 5, 2024 • 5 phút đọc',
          imageUrl:
              'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?auto=format&fit=crop&w=500&q=80',
        ),
        RelatedBlogPost(
          title: 'Khi nào nên đưa thú cưng đi khám sức khỏe định kỳ?',
          categoryLabel: 'SỨC KHỎE',
          meta: '01 Thg 5, 2024 • 5 phút đọc',
          imageUrl:
              'https://images.unsplash.com/photo-1628009368231-7bb7cfcb0def?auto=format&fit=crop&w=500&q=80',
        ),
      ],
    );
  }

  final String id;
  final String title;
  final String categoryLabel;
  final String authorName;
  final String publishedLabel;
  final String readTimeLabel;
  final String heroImageUrl;
  final String summary;
  final List<String> outline;
  final String intro;
  final List<BlogArticleSection> sections;
  final String conclusion;
  final List<RelatedBlogPost> relatedPosts;

  static String _heroImageFor(BlogCategoryFilter category, String postId) {
    if (postId.contains('nutrition') || category == BlogCategoryFilter.nutrition) {
      return 'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=1000&q=80';
    }
    if (postId.contains('training') || category == BlogCategoryFilter.training) {
      return 'https://images.unsplash.com/photo-1551730459-92db2a308d6a?auto=format&fit=crop&w=1000&q=80';
    }
    return 'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=1000&q=80';
  }

  static String _postHeroImage(
    BlogPost? post,
    BlogCategoryFilter category,
    String postId,
  ) {
    final imageUrl = post?.imageUrl ?? '';
    if (_isRemoteImage(imageUrl)) {
      return imageUrl;
    }
    return _heroImageFor(category, postId);
  }

  static List<BlogArticleSection> _sectionsFromPost(BlogPost post) {
    return post.sections.asMap().entries.map((entry) {
      final imageUrl = entry.value.imageUrl;
      return BlogArticleSection(
        title: entry.value.heading,
        body: entry.value.body,
        imageUrl: _isRemoteImage(imageUrl)
            ? imageUrl
            : _sectionImageFor(post.category, entry.key),
        tip: entry.key == 0 ? post.tip : null,
      );
    }).toList(growable: false);
  }

  static bool _isRemoteImage(String imageUrl) {
    return imageUrl.startsWith('http') && !imageUrl.contains('example.com');
  }

  static String _sectionImageFor(BlogCategoryFilter category, int index) {
    final nutritionImages = [
      'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1558944351-c0f4dfd6b30e?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1568572933382-74d440642117?auto=format&fit=crop&w=900&q=80',
    ];
    final trainingImages = [
      'https://images.unsplash.com/photo-1551730459-92db2a308d6a?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1601758174114-e711c0cbaa69?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1586671267731-da2cf3ceeb80?auto=format&fit=crop&w=900&q=80',
    ];
    final healthImages = [
      'https://images.unsplash.com/photo-1601758064130-5b1e7a8a31a6?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1517423568366-8b83523034fd?auto=format&fit=crop&w=900&q=80',
    ];

    final images = switch (category) {
      BlogCategoryFilter.nutrition => nutritionImages,
      BlogCategoryFilter.training => trainingImages,
      _ => healthImages,
    };
    return images[index % images.length];
  }
}

const _fallbackSections = [
  BlogArticleSection(
    title: '1. Thú cưng ngủ nhiều hơn bình thường',
    body:
        'Nếu bạn thấy bé cưng của mình ngủ nhiều hơn so với thường ngày, đây có thể là dấu hiệu cơ thể đang cần thời gian để phục hồi.',
    imageUrl:
        'https://images.unsplash.com/photo-1601758064130-5b1e7a8a31a6?auto=format&fit=crop&w=900&q=80',
    tip:
        'Mẹo nhỏ: Hãy đảm bảo không gian nghỉ ngơi yên tĩnh, thoáng mát và thoải mái cho thú cưng.',
  ),
  BlogArticleSection(
    title: '2. Mất hứng thú với hoạt động yêu thích',
    body:
        'Khi thú cưng không còn hứng thú với các hoạt động thường ngày như chơi đùa, đi dạo hay tương tác với bạn, có thể bé đang cảm thấy mệt mỏi.',
    imageUrl:
        'https://images.unsplash.com/photo-1551730459-92db2a308d6a?auto=format&fit=crop&w=900&q=80',
  ),
  BlogArticleSection(
    title: '3. Thay đổi thói quen ăn uống',
    body:
        'Ăn ít hơn hoặc bỏ ăn có thể là dấu hiệu thú cưng đang không cảm thấy khỏe hoặc cần thời gian nghỉ ngơi.',
    imageUrl:
        'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=900&q=80',
  ),
];

class BlogArticleSection {
  const BlogArticleSection({
    required this.title,
    required this.body,
    required this.imageUrl,
    this.tip,
  });

  final String title;
  final String body;
  final String imageUrl;
  final String? tip;
}

class RelatedBlogPost {
  const RelatedBlogPost({
    required this.title,
    required this.categoryLabel,
    required this.meta,
    required this.imageUrl,
  });

  final String title;
  final String categoryLabel;
  final String meta;
  final String imageUrl;
}


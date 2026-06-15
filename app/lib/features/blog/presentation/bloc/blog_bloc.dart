import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/blog/domain/entities/blog_category_filter.dart';
import 'package:app/features/blog/domain/entities/blog_page_content.dart';
import 'package:app/features/blog/domain/entities/blog_post.dart';
import 'package:app/features/blog/domain/usecases/get_blog_page_content_usecase.dart';
import 'package:app/features/blog/presentation/bloc/blog_event.dart';
import 'package:app/features/blog/presentation/bloc/blog_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class BlogBloc extends Bloc<BlogEvent, BlogState> {
  BlogBloc(this._getBlogPageContentUseCase) : super(const BlogState()) {
    on<BlogStarted>(_onStarted);
    on<BlogRefreshRequested>(_onRefreshRequested);
    on<BlogCategoryFilterChanged>(_onCategoryFilterChanged);
    on<BlogSearchQueryChanged>(_onSearchQueryChanged);
    on<BlogNotificationsPressed>(_onNotificationsPressed);
    on<BlogFeaturedPostPressed>(_onFeaturedPostPressed);
    on<BlogPostPressed>(_onPostPressed);
    on<BlogSeeAllPostsPressed>(_onSeeAllPostsPressed);
    on<BlogWeeklyTipActionPressed>(_onWeeklyTipActionPressed);
  }

  final GetBlogPageContentUseCase _getBlogPageContentUseCase;

  Future<void> _onStarted(BlogStarted event, Emitter<BlogState> emit) =>
      _loadContent(emit);

  Future<void> _onRefreshRequested(
    BlogRefreshRequested event,
    Emitter<BlogState> emit,
  ) =>
      _loadContent(emit);

  Future<void> _loadContent(Emitter<BlogState> emit) async {
    emit(
      state.copyWith(
        status: BlogStatus.loading,
        clearMessage: true,
        interaction: BlogInteraction.none,
        clearSelection: true,
        clearFeatured: true,
      ),
    );

    final result = await _getBlogPageContentUseCase(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: BlogStatus.failure,
          message: failure.message,
          visibleLatestPosts: const [],
          clearFeatured: true,
          clearSelection: true,
        ),
      ),
      (content) {
        final filtered = _applyFilters(
          content: content,
          category: state.selectedCategory,
          query: state.searchQuery,
        );
        emit(
          state.copyWith(
            status: BlogStatus.success,
            content: content,
            visibleFeatured: filtered.featured,
            visibleLatestPosts: filtered.latest,
            clearMessage: true,
            clearSelection: true,
          ),
        );
      },
    );
  }

  void _onCategoryFilterChanged(
    BlogCategoryFilterChanged event,
    Emitter<BlogState> emit,
  ) {
    _emitFiltered(
      emit,
      category: event.category,
      query: state.searchQuery,
    );
  }

  void _onSearchQueryChanged(
    BlogSearchQueryChanged event,
    Emitter<BlogState> emit,
  ) {
    _emitFiltered(
      emit,
      category: state.selectedCategory,
      query: event.query,
    );
  }

  void _emitFiltered(
    Emitter<BlogState> emit, {
    required BlogCategoryFilter category,
    required String query,
  }) {
    final content = state.content;
    if (content == null) {
      emit(
        state.copyWith(
          selectedCategory: category,
          searchQuery: query,
        ),
      );
      return;
    }

    final filtered = _applyFilters(
      content: content,
      category: category,
      query: query,
    );

    emit(
      state.copyWith(
        selectedCategory: category,
        searchQuery: query,
        visibleFeatured: filtered.featured,
        visibleLatestPosts: filtered.latest,
        interaction: BlogInteraction.none,
        clearSelection: true,
      ),
    );
  }

  void _onNotificationsPressed(
    BlogNotificationsPressed event,
    Emitter<BlogState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BlogInteraction.notifications,
        clearSelection: true,
      ),
    );
  }

  void _onFeaturedPostPressed(
    BlogFeaturedPostPressed event,
    Emitter<BlogState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BlogInteraction.featuredPost,
        selectedPostId: event.postId,
      ),
    );
  }

  void _onPostPressed(
    BlogPostPressed event,
    Emitter<BlogState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BlogInteraction.post,
        selectedPostId: event.postId,
      ),
    );
  }

  void _onSeeAllPostsPressed(
    BlogSeeAllPostsPressed event,
    Emitter<BlogState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BlogInteraction.seeAllPosts,
        clearSelection: true,
      ),
    );
  }

  void _onWeeklyTipActionPressed(
    BlogWeeklyTipActionPressed event,
    Emitter<BlogState> emit,
  ) {
    emit(
      state.copyWith(
        interaction: BlogInteraction.weeklyTip,
        clearSelection: true,
      ),
    );
  }

  ({BlogPost? featured, List<BlogPost> latest}) _applyFilters({
    required BlogPageContent content,
    required BlogCategoryFilter category,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    BlogPost? featured;
    if (_matchesPost(
      content.featuredPost,
      category: category,
      query: normalizedQuery,
    )) {
      featured = content.featuredPost;
    }

    final visibleLatestLimit = featured == null ? 5 : 4;
    final latest = content.latestPosts
        .where(
          (post) => _matchesPost(
            post,
            category: category,
            query: normalizedQuery,
          ),
        )
        .take(visibleLatestLimit)
        .toList(growable: false);

    return (featured: featured, latest: latest);
  }

  bool _matchesPost(
    BlogPost post, {
    required BlogCategoryFilter category,
    required String query,
  }) {
    if (category != BlogCategoryFilter.all && post.category != category) {
      return false;
    }
    if (query.isNotEmpty && !post.title.toLowerCase().contains(query)) {
      return false;
    }
    return true;
  }
}

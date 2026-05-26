import 'package:app/core/app_localizations.dart';
import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/locale_cubit.dart';
import 'package:app/features/sample_posts/presentation/bloc/sample_posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SamplePostsPage extends StatelessWidget {
  const SamplePostsPage({super.key});

  static const routeName = 'sample-posts';
  static const routePath = '/home';

  @override
  Widget build(BuildContext context) {
    final appConfig = getIt<AppConfig>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pageTitle),
        actions: [
          PopupMenuButton<Locale>(
            tooltip: l10n.changeLanguage,
            onSelected: (locale) {
              context.read<LocaleCubit>().changeLocale(locale);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: const Locale('vi'),
                child: Text(l10n.vietnamese),
              ),
              PopupMenuItem(
                value: const Locale('en'),
                child: Text(l10n.english),
              ),
            ],
            icon: const Icon(Icons.language_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<SamplePostsBloc, SamplePostsState>(
          builder: (context, state) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<SamplePostsBloc>().add(const SamplePostsRequested());
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.headline,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                label: Text(
                                  l10n.flavorLabel(
                                    appConfig.flavor.name.toUpperCase(),
                                  ),
                                ),
                              ),
                              Chip(
                                label: Text(
                                  l10n.baseUrlLabel(appConfig.baseUrl),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  switch (state.status) {
                    SamplePostsStatus.initial ||
                    SamplePostsStatus.loading =>
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    SamplePostsStatus.failure => SliverFillRemaining(
                        hasScrollBody: false,
                        child: _FailureView(
                          message: state.message ?? l10n.unknownError,
                        ),
                      ),
                    SamplePostsStatus.success => SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        sliver: SliverList.separated(
                          itemBuilder: (context, index) {
                            final post = state.posts[index];
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(post.title),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(post.body),
                                ),
                                trailing: CircleAvatar(
                                  child: Text(post.id.toString()),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(height: 12),
                          itemCount: state.posts.length,
                        ),
                      ),
                  },
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off_rounded,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.couldNotLoadPosts,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              context.read<SamplePostsBloc>().add(const SamplePostsRequested());
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}

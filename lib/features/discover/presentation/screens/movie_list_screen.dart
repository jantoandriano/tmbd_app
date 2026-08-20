import 'dart:async';

import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Arguments passed via `extra` when navigating to [MovieListScreen].
class MovieListArgs {
  const MovieListArgs({
    required this.title,
    required this.type,
    required this.showReleaseDate,
  });

  final String title;
  final MovieListType type;
  final bool showReleaseDate;
}

/// Full, infinitely-scrolling "See all" grid, reused for both Now Playing
/// and Coming Soon.
class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({required this.args, super.key});

  final MovieListArgs args;

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      unawaited(
        ref.read(movieListProvider(widget.args.type).notifier).loadMore(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(movieListProvider(widget.args.type));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(
                  movieListProvider(widget.args.type),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (listState) => CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(12),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.6,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final movie = listState.movies[index];
                    return MovieGridItem(
                      movie: movie,
                      showReleaseDate: widget.args.showReleaseDate,
                      width: double.infinity,
                      onTap: () => context.push('/movie/${movie.id}'),
                    );
                  },
                  childCount: listState.movies.length,
                ),
              ),
            ),
            if (listState.isLoadingMore)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

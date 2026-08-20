import 'dart:async';

import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/providers/genre_provider.dart';
import 'package:cinetrack/features/discover/presentation/providers/movie_list_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_list_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

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

enum _ViewMode { grid, list }

/// Full, infinitely-scrolling "See all" grid/list, reused for both Now
/// Playing and Coming Soon.
class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({required this.args, super.key});

  final MovieListArgs args;

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final _scrollController = ScrollController();
  _ViewMode _viewMode = _ViewMode.grid;
  int? _selectedGenreId;

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
    final genreMap = ref.watch(genreMapProvider).value ?? const {};

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
        data: (listState) {
          final genreIds =
              {
                  for (final movie in listState.movies) ...movie.genreIds,
                }.where(genreMap.containsKey).toList()
                ..sort((a, b) => genreMap[a]!.compareTo(genreMap[b]!));

          final filteredMovies = _selectedGenreId == null
              ? listState.movies
              : listState.movies
                    .where((m) => m.genreIds.contains(_selectedGenreId))
                    .toList();

          return Column(
            children: [
              _FilterRow(
                genreIds: genreIds,
                genreMap: genreMap,
                selectedGenreId: _selectedGenreId,
                onGenreSelected: (id) => setState(() => _selectedGenreId = id),
                viewMode: _viewMode,
                onViewModeChanged: (mode) => setState(() => _viewMode = mode),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        if (_viewMode == _ViewMode.grid)
                          _buildGridSliver(constraints, filteredMovies)
                        else
                          _buildListSliver(filteredMovies, genreMap),
                        if (listState.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGridSliver(BoxConstraints constraints, List<Movie> movies) {
    const crossAxisCount = 2;
    const gap = 14.0;
    const outerPadding = 12.0;
    final itemWidth =
        (constraints.maxWidth - outerPadding * 2 - gap * (crossAxisCount - 1)) /
        crossAxisCount;
    // Poster (2:3) + spacing + 1-line title + tag row.
    final mainAxisExtent = itemWidth * 1.5 + 54;

    return SliverPadding(
      padding: const EdgeInsets.all(outerPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: gap,
          crossAxisSpacing: gap,
          mainAxisExtent: mainAxisExtent,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = movies[index];
            return MovieGridItem(
              movie: movie,
              showReleaseDate: widget.args.showReleaseDate,
              width: double.infinity,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
          childCount: movies.length,
        ),
      ),
    );
  }

  Widget _buildListSliver(List<Movie> movies, Map<int, String> genreMap) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final movie = movies[index];
            final genreName = movie.genreIds.isEmpty
                ? null
                : genreMap[movie.genreIds.first];
            return MovieListRowItem(
              movie: movie,
              showReleaseDate: widget.args.showReleaseDate,
              genreName: genreName,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
          childCount: movies.length,
        ),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.genreIds,
    required this.genreMap,
    required this.selectedGenreId,
    required this.onGenreSelected,
    required this.viewMode,
    required this.onViewModeChanged,
  });

  final List<int> genreIds;
  final Map<int, String> genreMap;
  final int? selectedGenreId;
  final ValueChanged<int?> onGenreSelected;
  final _ViewMode viewMode;
  final ValueChanged<_ViewMode> onViewModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _GenreChip(
                    label: 'All',
                    selected: selectedGenreId == null,
                    onTap: () => onGenreSelected(null),
                  ),
                  for (final id in genreIds) ...[
                    const SizedBox(width: 8),
                    _GenreChip(
                      label: genreMap[id]!,
                      selected: selectedGenreId == id,
                      onTap: () => onGenreSelected(id),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          _ViewModeToggle(mode: viewMode, onChanged: onViewModeChanged),
        ],
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  const _GenreChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.accent : Colors.transparent,
          border: Border.all(color: AppTheme.accent),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: GoogleFonts.archivo(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.accent,
          ),
        ),
      ),
    );
  }
}

class _ViewModeToggle extends StatelessWidget {
  const _ViewModeToggle({required this.mode, required this.onChanged});

  final _ViewMode mode;
  final ValueChanged<_ViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            selected: mode == _ViewMode.grid,
            onTap: () => onChanged(_ViewMode.grid),
          ),
          Container(width: 2, height: 30, color: AppTheme.divider),
          _ToggleButton(
            icon: Icons.list,
            selected: mode == _ViewMode.list,
            onTap: () => onChanged(_ViewMode.list),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        color: selected ? AppTheme.accent : Colors.transparent,
        child: Icon(
          icon,
          size: 16,
          color: selected ? Colors.white : AppTheme.textPrimary,
        ),
      ),
    );
  }
}

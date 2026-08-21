import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/core/widgets/app_bottom_nav_bar.dart';
import 'package:cinetrack/features/watchlist/presentation/providers/watchlist_provider.dart';
import 'package:cinetrack/features/watchlist/presentation/widgets/watchlist_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class WatchlistScreen extends ConsumerWidget {
  const WatchlistScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This feature isn't available yet.")),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(watchlistProvider).movies;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Watchlist'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${movies.length} ${movies.length == 1 ? 'title' : 'titles'}',
                style: GoogleFonts.archivo(
                  fontSize: 12,
                  color: AppTheme.textPrimary.withValues(alpha: 0.55),
                ),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: movies.isEmpty
          ? Center(
              child: Text(
                'Your watchlist is empty.',
                style: GoogleFonts.archivo(
                  fontSize: 13,
                  color: AppTheme.textPrimary.withValues(alpha: 0.55),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                const crossAxisCount = 2;
                const gap = 14.0;
                const outerPadding = 12.0;
                final itemWidth =
                    (constraints.maxWidth -
                        outerPadding * 2 -
                        gap * (crossAxisCount - 1)) /
                    crossAxisCount;
                // Poster (2:3) + spacing + 1-line title + tag row.
                final mainAxisExtent = itemWidth * 1.5 + 54;

                return GridView.builder(
                  padding: const EdgeInsets.all(outerPadding),
                  gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: gap,
                        crossAxisSpacing: gap,
                        mainAxisExtent: mainAxisExtent,
                      ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return WatchlistGridItem(
                      movie: movie,
                      onTap: () => context.push('/movie/${movie.id}'),
                      onRemove: () => ref
                          .read(watchlistProvider.notifier)
                          .remove(movie.id),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: AppBottomNavBar(
        active: BottomNavTab.watchlist,
        onDiscoverTap: () => context.push('/'),
        onScanTap: () => _showComingSoon(context),
        onWatchlistTap: () {},
      ),
    );
  }
}

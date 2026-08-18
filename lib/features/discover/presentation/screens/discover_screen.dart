import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  int _navIndex = 0;

  void _showSearchStub() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Search coming soon')));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () => context.push('/profile'),
            child: const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xffe3e1e0),
              child: Icon(
                Icons.person,
                size: 18,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        title: const Text('CineTrack'),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined),
            tooltip: 'Ask AI',
            onPressed: () => context.push('/assistant'),
          ),
          IconButton(
            icon: const _NotificationsIcon(),
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: _showSearchStub,
          ),
        ],
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
                onPressed: () => ref.invalidate(discoverProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (discoverState) => _DiscoverBody(
          nowPlaying: discoverState.nowPlaying,
          comingSoon: discoverState.comingSoon,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: (index) {
          if (index == 1) {
            _showSearchStub();
            return;
          }
          setState(() => _navIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Search',
          ),
        ],
      ),
    );
  }
}

class _NotificationsIcon extends StatelessWidget {
  const _NotificationsIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_outlined),
        Positioned(
          top: -1,
          right: -1,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.accent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscoverBody extends StatelessWidget {
  const _DiscoverBody({required this.nowPlaying, required this.comingSoon});

  final List<Movie> nowPlaying;
  final List<Movie> comingSoon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (nowPlaying.isNotEmpty) ...[
            _HeroBanner(movie: nowPlaying.first),
            const Divider(height: 2),
          ],
          if (nowPlaying.isNotEmpty)
            _MovieSection(
              title: 'Now Playing',
              movies: nowPlaying,
              showReleaseDate: false,
            ),
          if (comingSoon.isNotEmpty) ...[
            const Divider(height: 2),
            _MovieSection(
              title: 'Coming Soon',
              movies: comingSoon,
              showReleaseDate: true,
            ),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.movie});

  final Movie movie;

  String get _tagline {
    final overview = movie.overview.trim();
    if (overview.isEmpty) return '';
    final period = overview.indexOf('. ');
    return period == -1 ? overview : overview.substring(0, period + 1);
  }

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: posterPath == null
              ? const ColoredBox(color: Colors.black12)
              : CachedNetworkImage(
                  imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                  fit: BoxFit.cover,
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'IN THEATERS',
                style: GoogleFonts.archivo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.12 * 11,
                  color: const Color(0xffae1800),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                movie.title,
                style: GoogleFonts.archivo(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (_tagline.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  _tagline,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.archivo(
                    fontSize: 12,
                    color: AppTheme.textPrimary.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Row(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index == 2 ? 0 : 6),
                    child: Container(
                      width: 18,
                      height: 3,
                      color: index == 0
                          ? AppTheme.accent
                          : const Color(0xffdcdad9),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MovieSection extends StatelessWidget {
  const _MovieSection({
    required this.title,
    required this.movies,
    required this.showReleaseDate,
  });

  final String title;
  final List<Movie> movies;
  final bool showReleaseDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.archivo(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ),
              Text(
                'See all',
                style: GoogleFonts.archivo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xffae1800),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 112 * 1.5 + 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieGridItem(
                movie: movie,
                showReleaseDate: showReleaseDate,
                onTap: () => context.push('/movie/${movie.id}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

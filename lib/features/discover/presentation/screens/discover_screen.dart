import 'dart:async';

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
  void _showSearchStub() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Search coming soon')));
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("This feature isn't available yet.")),
    );
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
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xffeae9e9),
            border: Border(top: BorderSide(color: AppTheme.divider, width: 2)),
          ),
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                Expanded(
                  child: _BottomNavItem(
                    icon: Icons.explore_outlined,
                    label: 'Discover',
                    active: true,
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Transform.translate(
                      offset: const Offset(0, -14),
                      child: _ScanButton(onTap: _showComingSoon),
                    ),
                  ),
                ),
                Expanded(
                  child: _BottomNavItem(
                    icon: Icons.confirmation_number_outlined,
                    label: 'Tickets',
                    active: false,
                    onTap: _showComingSoon,
                  ),
                ),
              ],
            ),
          ),
        ),
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
            _HeroCarousel(movies: nowPlaying.take(3).toList()),
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

class _HeroCarousel extends StatefulWidget {
  const _HeroCarousel({required this.movies});

  final List<Movie> movies;

  @override
  State<_HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<_HeroCarousel> {
  static const _autoPlayInterval = Duration(seconds: 5);

  late final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (widget.movies.length <= 1) return;
    _timer = Timer.periodic(_autoPlayInterval, (_) {
      final nextPage = (_currentPage + 1) % widget.movies.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.movies.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _startTimer();
            },
            itemBuilder: (context, index) {
              final posterPath = widget.movies[index].posterPath;
              return posterPath == null
                  ? const ColoredBox(color: Colors.black12)
                  : CachedNetworkImage(
                      imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                      fit: BoxFit.cover,
                    );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: _HeroCaption(
            movie: widget.movies[_currentPage],
            slideCount: widget.movies.length,
            currentSlide: _currentPage,
          ),
        ),
      ],
    );
  }
}

class _HeroCaption extends StatelessWidget {
  const _HeroCaption({
    required this.movie,
    required this.slideCount,
    required this.currentSlide,
  });

  final Movie movie;
  final int slideCount;
  final int currentSlide;

  String get _tagline {
    final overview = movie.overview.trim();
    if (overview.isEmpty) return '';
    final period = overview.indexOf('. ');
    return period == -1 ? overview : overview.substring(0, period + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
          children: List.generate(slideCount, (index) {
            return Padding(
              padding: EdgeInsets.only(right: index == slideCount - 1 ? 0 : 6),
              child: Container(
                width: 18,
                height: 3,
                color: index == currentSlide
                    ? AppTheme.accent
                    : const Color(0xffdcdad9),
              ),
            );
          }),
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

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xffae1800) : const Color(0xff7d7979);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.archivo(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.accent,
          boxShadow: kElevationToShadow[4],
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}

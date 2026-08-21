import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_provider.dart';
import 'package:cinetrack/features/details/presentation/widgets/ai_overview_panel.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/watchlist/presentation/providers/watchlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieDetailsProvider(movieId: movieId));

    return Scaffold(
      appBar: AppBar(
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
                onPressed: () =>
                    ref.invalidate(movieDetailsProvider(movieId: movieId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (details) => _DetailsBody(details: details),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Backdrop(path: details.backdropPath),
          _PosterMetaRow(details: details),
          _ActionRow(details: details),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.all(16),
            child: AiOverviewPanel(movie: details),
          ),
          if (details.cast.isNotEmpty) _CastStrip(cast: details.cast),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: path == null
          ? const ColoredBox(color: Colors.black12)
          : CachedNetworkImage(
              imageUrl: '${ApiConstants.tmdbImageBaseUrl}$path',
              fit: BoxFit.cover,
            ),
    );
  }
}

class _PosterMetaRow extends StatelessWidget {
  const _PosterMetaRow({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    final posterPath = details.posterPath;
    final metaParts = [
      _year(details.releaseDate),
      _formatRuntime(details.runtimeMinutes),
    ].where((part) => part.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            height: 138,
            child: posterPath == null
                ? const ColoredBox(color: Colors.black12)
                : CachedNetworkImage(
                    imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.title,
                  style: GoogleFonts.archivo(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: const Color(0xfffff2ef),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Color(0xff7c1405),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            details.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.archivo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff7c1405),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        metaParts,
                        style: GoogleFonts.archivo(
                          fontSize: 12,
                          color: AppTheme.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
                if (details.genres.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: details.genres
                        .map(
                          (genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            color: const Color(0xffeae7e7),
                            child: Text(
                              genre,
                              style: GoogleFonts.archivo(
                                fontSize: 11,
                                color: const Color(0xff2d2b2b),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CastStrip extends StatelessWidget {
  const _CastStrip({required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Cast',
            style: GoogleFonts.archivo(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 56 + 8 + 14 + 2 + 12,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = cast[index];
              return SizedBox(
                width: 72,
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: member.profilePath == null
                            ? const ColoredBox(
                                color: Colors.black12,
                                child: Icon(Icons.person),
                              )
                            : CachedNetworkImage(
                                imageUrl:
                                    '${ApiConstants.tmdbImageBaseUrl}'
                                    '${member.profilePath}',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      member.character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 10,
                        color: AppTheme.textPrimary.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String _year(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? '' : date.year.toString();
}

String _formatRuntime(int? minutes) {
  if (minutes == null || minutes <= 0) return '';
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (hours == 0) return '${remainder}m';
  return '${hours}h ${remainder}m';
}

class _ActionRow extends ConsumerStatefulWidget {
  const _ActionRow({required this.details});

  final MovieDetails details;

  @override
  ConsumerState<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends ConsumerState<_ActionRow> {
  Future<void> _openTrailer() async {
    final key = widget.details.youtubeTrailerKey;
    if (key == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trailer available')),
      );
      return;
    }
    await launchUrl(
      Uri.parse('https://www.youtube.com/watch?v=$key'),
      mode: LaunchMode.externalApplication,
    );
  }

  void _toggleWatchlist(bool inWatchlist) {
    final notifier = ref.read(watchlistProvider.notifier);
    if (inWatchlist) {
      notifier.remove(widget.details.id);
    } else {
      final details = widget.details;
      notifier.add(
        Movie(
          id: details.id,
          title: details.title,
          voteAverage: details.voteAverage,
          overview: details.overview,
          posterPath: details.posterPath,
          releaseDate: details.releaseDate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inWatchlist = ref.watch(
      watchlistProvider.select(
        (state) => state.movies.any((m) => m.id == widget.details.id),
      ),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => _toggleWatchlist(inWatchlist),
            style: ElevatedButton.styleFrom(
              backgroundColor: inWatchlist
                  ? const Color(0xffeae7e7)
                  : AppTheme.accent,
              foregroundColor: inWatchlist
                  ? AppTheme.textPrimary
                  : Colors.white,
            ),
            icon: Icon(inWatchlist ? Icons.check : Icons.add),
            label: Text(inWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _openTrailer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Trailer'),
          ),
        ],
      ),
    );
  }
}

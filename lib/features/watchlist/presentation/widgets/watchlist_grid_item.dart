import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Grid card for the Watchlist screen: full-color poster, an overlaid
/// "remove from watchlist" button, title, and a starred rating tag + year.
class WatchlistGridItem extends StatelessWidget {
  const WatchlistGridItem({
    required this.movie,
    required this.onTap,
    required this.onRemove,
    super.key,
  });

  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2 / 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (posterPath == null)
                  const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.movie_outlined),
                  )
                else
                  CachedNetworkImage(
                    imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const ColoredBox(color: Colors.black12),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onRemove,
                    child: Container(
                      width: 26,
                      height: 26,
                      alignment: Alignment.center,
                      color: AppTheme.accent,
                      child: const Icon(
                        Icons.bookmark,
                        size: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            movie.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.archivo(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          _WatchlistRatingTag(movie: movie),
        ],
      ),
    );
  }
}

class _WatchlistRatingTag extends StatelessWidget {
  const _WatchlistRatingTag({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          color: const Color(0xfffff2ef),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.star, size: 11, color: Color(0xff7c1405)),
              const SizedBox(width: 3),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: GoogleFonts.archivo(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff7c1405),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          _year(movie.releaseDate),
          style: GoogleFonts.archivo(
            fontSize: 11,
            color: AppTheme.textPrimary.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

String _year(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? '—' : date.year.toString();
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Horizontal-list movie card used by the Now Playing / Coming Soon rails.
///
/// [showReleaseDate] toggles the trailing tag: a filled rating tag for
/// already-released movies, or an outlined release-date tag for movies
/// that have no vote average yet.
class MovieGridItem extends StatelessWidget {
  const MovieGridItem({
    required this.movie,
    required this.onTap,
    required this.showReleaseDate,
    super.key,
  });

  final Movie movie;
  final VoidCallback onTap;
  final bool showReleaseDate;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 112,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: posterPath == null
                  ? const ColoredBox(
                      color: Colors.black12,
                      child: Icon(Icons.movie_outlined),
                    )
                  : CachedNetworkImage(
                      imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ColoredBox(color: Colors.black12),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image_outlined),
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
            if (showReleaseDate)
              _DateTag(movie: movie)
            else
              _RatingTag(movie: movie),
          ],
        ),
      ),
    );
  }
}

class _RatingTag extends StatelessWidget {
  const _RatingTag({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          color: const Color(0xfffff2ef),
          child: Text(
            movie.voteAverage.toStringAsFixed(1),
            style: GoogleFonts.archivo(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xff7c1405),
            ),
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

class _DateTag extends StatelessWidget {
  const _DateTag({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accent),
      ),
      child: Text(
        _shortDate(movie.releaseDate),
        style: GoogleFonts.archivo(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppTheme.accent,
        ),
      ),
    );
  }
}

String _year(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? '—' : date.year.toString();
}

const _monthAbbr = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _shortDate(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? 'TBA' : '${_monthAbbr[date.month - 1]} ${date.day}';
}

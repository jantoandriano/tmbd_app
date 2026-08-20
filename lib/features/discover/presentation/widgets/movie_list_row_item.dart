import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Single-column row used by the "See all" list view mode: a
/// thumbnail, title, and a meta line (rating tag for Now Playing, or a
/// release-date tag for Coming Soon) plus the movie's primary genre.
class MovieListRowItem extends StatelessWidget {
  const MovieListRowItem({
    required this.movie,
    required this.onTap,
    required this.showReleaseDate,
    required this.genreName,
    super.key,
  });

  final Movie movie;
  final VoidCallback onTap;
  final bool showReleaseDate;
  final String? genreName;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.divider)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              height: 84,
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
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.archivo(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (showReleaseDate)
                        DateTag(movie: movie)
                      else
                        RatingTag(movie: movie),
                      if (genreName != null) ...[
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            genreName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.archivo(
                              fontSize: 11,
                              color: AppTheme.textPrimary.withValues(
                                alpha: 0.55,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

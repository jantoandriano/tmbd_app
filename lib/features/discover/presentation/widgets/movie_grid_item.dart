import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:flutter/material.dart';

class MovieGridItem extends StatelessWidget {
  const MovieGridItem({required this.movie, required this.onTap, super.key});

  final Movie movie;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final posterPath = movie.posterPath;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
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
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image_outlined),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 24, 10, 8),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black87],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

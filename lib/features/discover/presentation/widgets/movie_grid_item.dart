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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: posterPath == null
                ? const ColoredBox(
                    color: Colors.black12,
                    child: Icon(Icons.movie_outlined),
                  )
                : CachedNetworkImage(
                    imageUrl: '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image_outlined),
                  ),
          ),
          Text(movie.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

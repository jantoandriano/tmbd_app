import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie.freezed.dart';

@freezed
sealed class Movie with _$Movie {
  const factory Movie({
    required int id,
    required String title,
    required double voteAverage,
    required String overview,
    String? posterPath,
    String? releaseDate,
  }) = _Movie;
}

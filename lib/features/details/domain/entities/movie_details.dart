import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details.freezed.dart';

@freezed
sealed class MovieDetails with _$MovieDetails {
  const factory MovieDetails({
    required int id,
    required String title,
    required String overview,
    required double voteAverage,
    String? posterPath,
    String? backdropPath,
    String? releaseDate,
    int? runtimeMinutes,
    @Default(<String>[]) List<String> genres,
    @Default(<CastMember>[]) List<CastMember> cast,
    String? youtubeTrailerKey,
  }) = _MovieDetails;
}

@freezed
sealed class CastMember with _$CastMember {
  const factory CastMember({
    required int id,
    required String name,
    required String character,
    String? profilePath,
  }) = _CastMember;
}

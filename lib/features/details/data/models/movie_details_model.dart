import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_details_model.freezed.dart';
part 'movie_details_model.g.dart';

@freezed
sealed class GenreModel with _$GenreModel {
  const factory GenreModel({required int id, required String name}) =
      _GenreModel;

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);
}

@freezed
sealed class CastMemberModel with _$CastMemberModel {
  const factory CastMemberModel({
    required int id,
    required String name,
    required String character,
    required int order,
    @JsonKey(name: 'profile_path') String? profilePath,
  }) = _CastMemberModel;

  factory CastMemberModel.fromJson(Map<String, dynamic> json) =>
      _$CastMemberModelFromJson(json);
}

@freezed
sealed class CreditsModel with _$CreditsModel {
  const factory CreditsModel({
    @Default(<CastMemberModel>[]) List<CastMemberModel> cast,
  }) = _CreditsModel;

  factory CreditsModel.fromJson(Map<String, dynamic> json) =>
      _$CreditsModelFromJson(json);
}

@freezed
sealed class VideoModel with _$VideoModel {
  const factory VideoModel({
    required String key,
    required String site,
    required String type,
    @Default(false) bool official,
  }) = _VideoModel;

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);
}

@freezed
sealed class VideosResponseModel with _$VideosResponseModel {
  const factory VideosResponseModel({
    @Default(<VideoModel>[]) List<VideoModel> results,
  }) = _VideosResponseModel;

  factory VideosResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VideosResponseModelFromJson(json);
}

@freezed
sealed class MovieDetailsModel with _$MovieDetailsModel {
  const factory MovieDetailsModel({
    required int id,
    required String title,
    required String overview,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'backdrop_path') String? backdropPath,
    @JsonKey(name: 'release_date') String? releaseDate,
    int? runtime,
    @Default(<GenreModel>[]) List<GenreModel> genres,
    CreditsModel? credits,
    VideosResponseModel? videos,
  }) = _MovieDetailsModel;

  const MovieDetailsModel._();

  factory MovieDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailsModelFromJson(json);

  MovieDetails toEntity() {
    final sortedCast = [...?credits?.cast]
      ..sort((a, b) => a.order.compareTo(b.order));

    return MovieDetails(
      id: id,
      title: title,
      overview: overview,
      voteAverage: voteAverage,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate,
      runtimeMinutes: runtime,
      genres: genres.map((g) => g.name).toList(),
      cast: sortedCast
          .take(10)
          .map(
            (c) => CastMember(
              id: c.id,
              name: c.name,
              character: c.character,
              profilePath: c.profilePath,
            ),
          )
          .toList(),
      youtubeTrailerKey: _selectTrailerKey(videos?.results ?? const []),
    );
  }
}

String? _selectTrailerKey(List<VideoModel> videos) {
  final trailers = videos
      .where((v) => v.site == 'YouTube' && v.type == 'Trailer')
      .toList();
  if (trailers.isEmpty) return null;

  final official = trailers.where((v) => v.official).toList();
  return (official.isNotEmpty ? official.first : trailers.first).key;
}

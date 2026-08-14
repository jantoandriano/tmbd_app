import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_model.freezed.dart';
part 'movie_model.g.dart';

@freezed
sealed class MovieModel with _$MovieModel {
  const factory MovieModel({
    required int id,
    required String title,
    @JsonKey(name: 'vote_average') required double voteAverage,
    required String overview,
    @JsonKey(name: 'poster_path') String? posterPath,
    @JsonKey(name: 'release_date') String? releaseDate,
  }) = _MovieModel;

  const MovieModel._();

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Movie toEntity() => Movie(
    id: id,
    title: title,
    posterPath: posterPath,
    voteAverage: voteAverage,
    releaseDate: releaseDate,
    overview: overview,
  );
}

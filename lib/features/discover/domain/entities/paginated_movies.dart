import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_movies.freezed.dart';

@freezed
sealed class PaginatedMovies with _$PaginatedMovies {
  const factory PaginatedMovies({
    required List<Movie> movies,
    required int page,
    required int totalPages,
  }) = _PaginatedMovies;
}

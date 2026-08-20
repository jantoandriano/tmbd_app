import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_list_state.freezed.dart';

@freezed
sealed class MovieListState with _$MovieListState {
  const factory MovieListState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(1) int page,
    @Default(1) int totalPages,
    @Default(false) bool isLoadingMore,
  }) = _MovieListState;
}

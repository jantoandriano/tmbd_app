import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'watchlist_state.freezed.dart';

@freezed
sealed class WatchlistState with _$WatchlistState {
  const factory WatchlistState({
    @Default(<Movie>[]) List<Movie> movies,
  }) = _WatchlistState;
}

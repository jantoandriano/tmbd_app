import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_state.freezed.dart';

@freezed
sealed class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default(<Movie>[]) List<Movie> nowPlaying,
    @Default(<Movie>[]) List<Movie> comingSoon,
  }) = _DiscoverState;
}

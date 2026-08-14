import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'discover_state.freezed.dart';

@freezed
sealed class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(1) int page,
    @Default(false) bool hasReachedMax,
    @Default(false) bool isLoadingMore,
  }) = _DiscoverState;
}

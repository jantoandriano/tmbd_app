import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/watchlist/presentation/providers/watchlist_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'watchlist_provider.g.dart';

@Riverpod(keepAlive: true)
class WatchlistNotifier extends _$WatchlistNotifier {
  @override
  WatchlistState build() => const WatchlistState();

  void add(Movie movie) {
    if (state.movies.any((existing) => existing.id == movie.id)) return;
    state = state.copyWith(movies: [movie, ...state.movies]);
  }

  void remove(int movieId) {
    state = state.copyWith(
      movies: state.movies.where((movie) => movie.id != movieId).toList(),
    );
  }
}

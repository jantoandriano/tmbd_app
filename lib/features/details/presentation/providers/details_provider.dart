import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/details_di.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'details_provider.g.dart';

@riverpod
Future<MovieDetails> movieDetails(Ref ref, {required int movieId}) async {
  final repository = ref.watch(detailsRepositoryProvider);
  final result = await repository.getMovieDetails(movieId: movieId);

  return result.match((failure) => throw failure, (details) => details);
}

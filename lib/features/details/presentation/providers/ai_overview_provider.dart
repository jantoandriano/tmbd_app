import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ai_overview_provider.g.dart';

@riverpod
Future<String> aiOverviewSummary(
  Ref ref, {
  required MovieDetails movie,
}) async {
  final service = ref.watch(aiOverviewServiceProvider);
  return service.summarize(movie: movie);
}

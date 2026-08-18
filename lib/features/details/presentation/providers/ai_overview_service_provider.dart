import 'package:cinetrack/features/details/presentation/services/ai_overview_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiOverviewServiceProvider = Provider<AiOverviewService>(
  (ref) => AiOverviewService(),
);

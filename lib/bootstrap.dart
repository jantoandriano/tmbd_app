import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/config/flavors.dart';
import 'package:cinetrack/core/di/injection.dart';
import 'package:cinetrack/core/router/app_router.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shared startup sequence for every flavor entrypoint.
///
/// Validates required env config, wires DI, and runs the app. Throws (and
/// crashes intentionally) if TMDB_API_KEY was not supplied — a broken build
/// should fail loudly at startup, not silently hit TMDB with no key.
Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  FlavorConfig.init(flavor: flavor, appName: 'CineTrack');

  // Fails fast if --dart-define=TMDB_API_KEY=... was not provided.
  EnvConfig.tmdbApiKey;

  await configureDependencies();

  runApp(
    const ProviderScope(
      child: CineTrackApp(),
    ),
  );
}

class CineTrackApp extends StatelessWidget {
  const CineTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CineTrack',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}

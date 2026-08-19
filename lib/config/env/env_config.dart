/// Reads build-time config injected via `--dart-define`.
///
/// TMDB key must be supplied at build/run time, e.g.:
/// `flutter run --dart-define=TMDB_API_KEY=your_key_here`
class EnvConfig {
  const EnvConfig._();

  static const String _tmdbApiKey = String.fromEnvironment('TMDB_API_KEY');
  static const String _geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
  );

  static String get tmdbApiKey {
    if (_tmdbApiKey.isEmpty) {
      throw StateError(
        'TMDB_API_KEY is missing. Run with '
        '--dart-define=TMDB_API_KEY=your_key_here',
      );
    }
    return _tmdbApiKey;
  }

  static String get geminiApiKey {
    if (_geminiApiKey.isEmpty) {
      throw StateError(
        'GEMINI_API_KEY is missing. Run with '
        '--dart-define=GEMINI_API_KEY=your_key_here',
      );
    }
    return _geminiApiKey;
  }
}

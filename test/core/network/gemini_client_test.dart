import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/network/gemini_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create sets the Gemini key as a default query parameter', () {
    final dio = GeminiClient.create();

    expect(dio.options.queryParameters['key'], EnvConfig.geminiApiKey);
  });
}

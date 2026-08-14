import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/network/dio_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('create sets the TMDB api_key as a default query parameter', () {
    final dio = DioClient.create(baseUrl: 'https://api.themoviedb.org/3');

    expect(dio.options.queryParameters['api_key'], EnvConfig.tmdbApiKey);
  });
}

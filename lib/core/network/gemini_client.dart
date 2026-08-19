import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';

/// Builds the [Dio] instance used to call the Gemini generateContent API.
class GeminiClient {
  const GeminiClient._();

  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.geminiBaseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {'key': EnvConfig.geminiApiKey},
      ),
    );

    dio.interceptors.add(LoggingInterceptor());

    return dio;
  }
}

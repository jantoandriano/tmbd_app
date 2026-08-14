import 'package:cinetrack/config/env/env_config.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/network/auth_interceptor.dart';
import 'package:cinetrack/core/network/logging_interceptor.dart';
import 'package:dio/dio.dart';

/// Builds the [Dio] instance shared by all repositories.
class DioClient {
  const DioClient._();

  static Dio create({required String baseUrl}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        queryParameters: {'api_key': EnvConfig.tmdbApiKey},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}

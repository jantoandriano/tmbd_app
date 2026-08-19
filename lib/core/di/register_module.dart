import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/network/dio_client.dart';
import 'package:cinetrack/core/network/gemini_client.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Registers third-party/manually-constructed instances that injectable
/// can't build via its own `@injectable` annotations.
@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio => DioClient.create(baseUrl: ApiConstants.tmdbBaseUrl);

  @lazySingleton
  @Named('gemini')
  Dio get geminiDio => GeminiClient.create();
}

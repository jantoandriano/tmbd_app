import 'package:cinetrack/core/di/injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final geminiDioProvider = Provider<Dio>(
  (ref) => getIt<Dio>(instanceName: 'gemini'),
);

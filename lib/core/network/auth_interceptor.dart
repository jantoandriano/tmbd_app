import 'package:dio/dio.dart';

/// Placeholder for future auth-token injection (TMDB session id / account
/// auth). No-ops until the auth feature is implemented.
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }
}

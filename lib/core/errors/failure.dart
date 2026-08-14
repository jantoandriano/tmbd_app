import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.server(String message, {int? statusCode}) =
      ServerFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}

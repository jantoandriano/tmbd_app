import 'package:cinetrack/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

/// Standard return type for repository methods: `Left(Failure)` on error,
/// `Right(T)` on success.
typedef Result<T> = Either<Failure, T>;

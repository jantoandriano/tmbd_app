import 'package:cinetrack/core/providers/dio_provider.dart';
import 'package:cinetrack/features/details/data/datasources/details_remote_data_source.dart';
import 'package:cinetrack/features/details/data/repositories/details_repository_impl.dart';
import 'package:cinetrack/features/details/domain/repositories/details_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailsRemoteDataSourceProvider = Provider<DetailsRemoteDataSource>(
  (ref) => DetailsRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final detailsRepositoryProvider = Provider<DetailsRepository>(
  (ref) => DetailsRepositoryImpl(ref.watch(detailsRemoteDataSourceProvider)),
);

import 'package:cinetrack/core/di/injection.dart';
import 'package:cinetrack/features/discover/data/datasources/discover_remote_data_source.dart';
import 'package:cinetrack/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:cinetrack/features/discover/domain/repositories/discover_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => getIt<Dio>());

final discoverRemoteDataSourceProvider = Provider<DiscoverRemoteDataSource>(
  (ref) => DiscoverRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final discoverRepositoryProvider = Provider<DiscoverRepository>(
  (ref) =>
      DiscoverRepositoryImpl(ref.watch(discoverRemoteDataSourceProvider)),
);

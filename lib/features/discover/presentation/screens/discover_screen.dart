import 'dart:async';

import 'package:cinetrack/core/errors/failure.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      unawaited(_loadNextPage());
    }
  }

  Future<void> _loadNextPage() async {
    final failure = await ref
        .read(discoverProvider.notifier)
        .loadNextPage();
    if (failure != null && mounted) {
      final message = switch (failure) {
        NetworkFailure(:final message) => message,
        ServerFailure(:final message) => message,
        CacheFailure(:final message) => message,
        UnexpectedFailure(:final message) => message,
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(discoverProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(discoverProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (discoverState) => GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount:
              discoverState.movies.length +
              (discoverState.isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index >= discoverState.movies.length) {
              return const Center(child: CircularProgressIndicator());
            }
            final movie = discoverState.movies[index];
            return MovieGridItem(
              movie: movie,
              onTap: () => context.push('/movie/${movie.id}'),
            );
          },
        ),
      ),
    );
  }
}

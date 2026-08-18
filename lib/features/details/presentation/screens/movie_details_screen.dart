import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_service_provider.dart';
import 'package:cinetrack/features/details/presentation/providers/details_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _grayscale = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
]);

class MovieDetailsScreen extends ConsumerWidget {
  const MovieDetailsScreen({required this.movieId, super.key});

  final int movieId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(movieDetailsProvider(movieId: movieId));

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Something went wrong.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(movieDetailsProvider(movieId: movieId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (details) => _DetailsBody(details: details),
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Backdrop(path: details.backdropPath),
          _PosterMetaRow(details: details),
          _ActionRow(details: details),
          const Divider(height: 2),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _AiOverviewPanel(movie: details),
          ),
          if (details.cast.isNotEmpty) _CastStrip(cast: details.cast),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Backdrop extends StatelessWidget {
  const _Backdrop({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColorFiltered(
        colorFilter: _grayscale,
        child: path == null
            ? const ColoredBox(color: Colors.black12)
            : CachedNetworkImage(
                imageUrl: '${ApiConstants.tmdbImageBaseUrl}$path',
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _PosterMetaRow extends StatelessWidget {
  const _PosterMetaRow({required this.details});

  final MovieDetails details;

  @override
  Widget build(BuildContext context) {
    final posterPath = details.posterPath;
    final metaParts = [
      _year(details.releaseDate),
      _formatRuntime(details.runtimeMinutes),
    ].where((part) => part.isNotEmpty).join(' · ');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            height: 138,
            child: ColorFiltered(
              colorFilter: _grayscale,
              child: posterPath == null
                  ? const ColoredBox(color: Colors.black12)
                  : CachedNetworkImage(
                      imageUrl:
                          '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.title,
                  style: GoogleFonts.archivo(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      color: const Color(0xfffff2ef),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Color(0xff7c1405),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            details.voteAverage.toStringAsFixed(1),
                            style: GoogleFonts.archivo(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff7c1405),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (metaParts.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        metaParts,
                        style: GoogleFonts.archivo(
                          fontSize: 12,
                          color: AppTheme.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ],
                ),
                if (details.genres.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: details.genres
                        .map(
                          (genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            color: const Color(0xffeae7e7),
                            child: Text(
                              genre,
                              style: GoogleFonts.archivo(
                                fontSize: 11,
                                color: const Color(0xff2d2b2b),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CastStrip extends StatelessWidget {
  const _CastStrip({required this.cast});

  final List<CastMember> cast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Text(
            'Cast',
            style: GoogleFonts.archivo(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 56 + 8 + 14 + 2 + 12,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: cast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final member = cast[index];
              return SizedBox(
                width: 72,
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 56,
                        height: 56,
                        child: ColorFiltered(
                          colorFilter: _grayscale,
                          child: member.profilePath == null
                              ? const ColoredBox(
                                  color: Colors.black12,
                                  child: Icon(Icons.person),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${ApiConstants.tmdbImageBaseUrl}'
                                      '${member.profilePath}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      member.character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.archivo(
                        fontSize: 10,
                        color: AppTheme.textPrimary.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String _year(String? releaseDate) {
  final date = releaseDate == null ? null : DateTime.tryParse(releaseDate);
  return date == null ? '' : date.year.toString();
}

String _formatRuntime(int? minutes) {
  if (minutes == null || minutes <= 0) return '';
  final hours = minutes ~/ 60;
  final remainder = minutes % 60;
  if (hours == 0) return '${remainder}m';
  return '${hours}h ${remainder}m';
}

class _ActionRow extends StatefulWidget {
  const _ActionRow({required this.details});

  final MovieDetails details;

  @override
  State<_ActionRow> createState() => _ActionRowState();
}

class _ActionRowState extends State<_ActionRow> {
  bool _inWatchlist = false;

  Future<void> _openTrailer() async {
    final key = widget.details.youtubeTrailerKey;
    if (key == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No trailer available')),
      );
      return;
    }
    await launchUrl(
      Uri.parse('https://www.youtube.com/watch?v=$key'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () => setState(() => _inWatchlist = !_inWatchlist),
            style: ElevatedButton.styleFrom(
              backgroundColor: _inWatchlist
                  ? const Color(0xffeae7e7)
                  : AppTheme.accent,
              foregroundColor: _inWatchlist
                  ? AppTheme.textPrimary
                  : Colors.white,
            ),
            icon: Icon(_inWatchlist ? Icons.check : Icons.add),
            label: Text(_inWatchlist ? 'In Watchlist' : 'Add to Watchlist'),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _openTrailer,
            icon: const Icon(Icons.play_arrow),
            label: const Text('Trailer'),
          ),
        ],
      ),
    );
  }
}

class _QaTurn {
  _QaTurn(this.question);

  final String question;
  String? answer;
}

const _suggestedQuestions = [
  'Who directed this?',
  'Similar movies',
  'Content warnings?',
];

class _AiOverviewPanel extends ConsumerStatefulWidget {
  const _AiOverviewPanel({required this.movie});

  final MovieDetails movie;

  @override
  ConsumerState<_AiOverviewPanel> createState() => _AiOverviewPanelState();
}

class _AiOverviewPanelState extends ConsumerState<_AiOverviewPanel> {
  final _controller = TextEditingController();
  final _turns = <_QaTurn>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;

    _controller.clear();
    final turn = _QaTurn(trimmed);
    setState(() => _turns.add(turn));

    final answer = await ref
        .read(aiOverviewServiceProvider)
        .answer(movie: widget.movie, question: trimmed);

    if (!mounted) return;
    setState(() => turn.answer = answer);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.divider, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: Color(0xffae1800),
              ),
              const SizedBox(width: 6),
              Text(
                'AI OVERVIEW',
                style: GoogleFonts.archivo(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.12 * 11,
                  color: const Color(0xffae1800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.movie.overview,
            style: GoogleFonts.archivo(
              fontSize: 13,
              height: 1.6,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedQuestions
                .map(
                  (question) => OutlinedButton(
                    onPressed: () => _submit(question),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppTheme.accent),
                      foregroundColor: AppTheme.accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      question,
                      style: GoogleFonts.archivo(fontSize: 12),
                    ),
                  ),
                )
                .toList(),
          ),
          for (final turn in _turns) ...[
            const SizedBox(height: 12),
            Text(
              turn.question,
              style: GoogleFonts.archivo(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              turn.answer ?? '…',
              style: GoogleFonts.archivo(
                fontSize: 13,
                height: 1.6,
                color: AppTheme.textPrimary.withValues(alpha: 0.85),
              ),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 2),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask anything about this movie…',
                    border: InputBorder.none,
                  ),
                  onSubmitted: _submit,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _submit(_controller.text),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.send, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

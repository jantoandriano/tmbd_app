import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinetrack/core/constants/api_constants.dart';
import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/ai_assistant/presentation/providers/ai_chat_service_provider.dart';
import 'package:cinetrack/features/discover/domain/entities/movie.dart';
import 'package:cinetrack/features/discover/presentation/providers/discover_provider.dart';
import 'package:cinetrack/features/discover/presentation/widgets/movie_grid_item.dart';
import 'package:cinetrack/features/watchlist/presentation/providers/watchlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

const _greeting =
    "Hi! I'm your CineTrack assistant. Ask me about any movie, or I can "
    'recommend titles from CineTrack you can add straight to your '
    'watchlist.';

const _suggestedPrompts = [
  'Recommend a good sci-fi movie',
  "What's a good movie for a rainy night?",
  'Something like Inception',
];

class _ChatMessage {
  _ChatMessage.user(this.content)
    : isUser = true,
      recommendations = const [];

  _ChatMessage.aiPending()
    : isUser = false,
      content = null,
      recommendations = const [];

  final bool isUser;
  String? content;
  List<Movie> recommendations;
}

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messages = <_ChatMessage>[];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  List<Movie> _catalog() {
    final discover = ref.read(discoverProvider).value;
    if (discover == null) return const [];
    return [...discover.nowPlaying, ...discover.comingSoon];
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _submit(String question) async {
    final trimmed = question.trim();
    if (trimmed.isEmpty) return;
    _controller.clear();

    final history = [
      for (final message in _messages)
        if (message.content != null)
          (
            role: message.isUser ? 'user' : 'model',
            content: message.content!,
          ),
    ];

    final pending = _ChatMessage.aiPending();
    setState(() {
      _messages
        ..add(_ChatMessage.user(trimmed))
        ..add(pending);
    });
    _scrollToBottom();

    final reply = await ref
        .read(aiChatServiceProvider)
        .respond(question: trimmed, history: history, catalog: _catalog());

    if (!mounted) return;
    setState(() {
      pending
        ..content = reply.text
        ..recommendations = reply.recommendations;
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome,
              size: 18,
              color: AppTheme.accentDark,
            ),
            const SizedBox(width: 8),
            Text(
              'Ask AI',
              style: GoogleFonts.archivo(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: Container(height: 2, color: AppTheme.divider),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                _GreetingTurn(onSuggestionTap: _submit),
                for (final message in _messages) ...[
                  const SizedBox(height: 16),
                  if (message.isUser)
                    _UserBubble(text: message.content!)
                  else
                    _AiTurn(message: message),
                ],
              ],
            ),
          ),
          _InputBar(controller: _controller, onSubmit: _submit),
        ],
      ),
    );
  }
}

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.accentDark, width: 2),
      ),
      child: const Icon(
        Icons.auto_awesome,
        size: 14,
        color: AppTheme.accentDark,
      ),
    );
  }
}

class _GreetingTurn extends StatelessWidget {
  const _GreetingTurn({required this.onSuggestionTap});

  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: GoogleFonts.archivo(
                  fontSize: 13,
                  height: 1.6,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggestedPrompts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final prompt = _suggestedPrompts[index];
                    return OutlinedButton(
                      onPressed: () => onSuggestionTap(prompt),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accent),
                        foregroundColor: AppTheme.accent,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: Text(
                        prompt,
                        style: GoogleFonts.archivo(fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: const Color(0xffe3e1e0),
            child: Text(
              text,
              style: GoogleFonts.archivo(
                fontSize: 13,
                height: 1.6,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiTurn extends StatelessWidget {
  const _AiTurn({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _AiAvatar(),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.content == null)
                const _ThinkingIndicator()
              else
                Text(
                  message.content!,
                  style: GoogleFonts.archivo(
                    fontSize: 13,
                    height: 1.6,
                    color: AppTheme.textPrimary,
                  ),
                ),
              for (final movie in message.recommendations) ...[
                const SizedBox(height: 10),
                _RecommendationCard(movie: movie),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _RecommendationCard extends ConsumerWidget {
  const _RecommendationCard({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inWatchlist = ref.watch(
      watchlistProvider.select(
        (state) => state.movies.any((m) => m.id == movie.id),
      ),
    );
    final posterPath = movie.posterPath;

    return GestureDetector(
      onTap: () => context.push('/movie/${movie.id}'),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.divider, width: 2),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              height: 78,
              child: ColorFiltered(
                colorFilter: const ColorFilter.matrix(<double>[
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0.2126, 0.7152, 0.0722, 0, 0, //
                  0, 0, 0, 1, 0, //
                ]),
                child: posterPath == null
                    ? const ColoredBox(
                        color: Colors.black12,
                        child: Icon(Icons.movie_outlined),
                      )
                    : CachedNetworkImage(
                        imageUrl:
                            '${ApiConstants.tmdbImageBaseUrl}$posterPath',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.archivo(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RatingTag(movie: movie),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      final notifier = ref.read(watchlistProvider.notifier);
                      if (inWatchlist) {
                        notifier.remove(movie.id);
                      } else {
                        notifier.add(movie);
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: inWatchlist
                            ? AppTheme.textPrimary.withValues(alpha: 0.4)
                            : AppTheme.accent,
                      ),
                      foregroundColor: inWatchlist
                          ? AppTheme.textPrimary.withValues(alpha: 0.6)
                          : AppTheme.accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      inWatchlist ? 'Added' : '+ Add to Watchlist',
                      style: GoogleFonts.archivo(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final ValueChanged<String> onSubmit;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.divider, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Ask about a movie or mood…',
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: onSubmit,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => onSubmit(controller.text),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppTheme.accent,
                  child: Icon(Icons.send, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThinkingIndicator extends StatefulWidget {
  const _ThinkingIndicator();

  @override
  State<_ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<_ThinkingIndicator>
    with SingleTickerProviderStateMixin {
  late final _controller =
      AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 900),
        )
        ..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = (_controller.value - i * 0.2) % 1.0;
              final opacity = (0.3 + 0.7 * (1 - (t - 0.5).abs() * 2)).clamp(
                0.3,
                1.0,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppTheme.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

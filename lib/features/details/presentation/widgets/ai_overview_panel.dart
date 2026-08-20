import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_provider.dart';
import 'package:cinetrack/features/details/presentation/providers/ai_overview_service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class _QaTurn {
  _QaTurn(this.question);

  final String question;
  String? answer;
}

const _suggestedQuestions = [
  'Who stars in this?',
  'What genre is this?',
  'Content warnings?',
];

class AiOverviewPanel extends ConsumerStatefulWidget {
  const AiOverviewPanel({required this.movie, super.key});

  final MovieDetails movie;

  @override
  ConsumerState<AiOverviewPanel> createState() => _AiOverviewPanelState();
}

class _AiOverviewPanelState extends ConsumerState<AiOverviewPanel> {
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
    final history = [
      for (final turn in _turns)
        if (turn.answer != null)
          (question: turn.question, answer: turn.answer!),
    ];
    final turn = _QaTurn(trimmed);
    setState(() => _turns.add(turn));

    final answer = await ref
        .read(aiOverviewServiceProvider)
        .answer(movie: widget.movie, question: trimmed, history: history);

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
          _SummaryText(movie: widget.movie),
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
            if (turn.answer == null)
              const _ThinkingIndicator()
            else
              Text(
                turn.answer!,
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

class _SummaryText extends ConsumerWidget {
  const _SummaryText({required this.movie});

  final MovieDetails movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(aiOverviewSummaryProvider(movie: movie));
    final style = GoogleFonts.archivo(
      fontSize: 13,
      height: 1.6,
      color: AppTheme.textPrimary,
    );

    return summary.when(
      loading: () => const _ThinkingIndicator(),
      error: (_, _) => Text(movie.overview, style: style),
      data: (text) => Text(text, style: style),
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
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
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

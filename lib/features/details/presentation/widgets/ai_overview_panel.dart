import 'package:cinetrack/core/theme/app_theme.dart';
import 'package:cinetrack/features/details/domain/entities/movie_details.dart';
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
  'Who directed this?',
  'Similar movies',
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

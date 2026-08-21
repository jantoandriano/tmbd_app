import 'package:cinetrack/core/providers/gemini_dio_provider.dart';
import 'package:cinetrack/features/ai_assistant/presentation/services/ai_chat_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiChatServiceProvider = Provider<AiChatService>(
  (ref) => GeminiChatService(ref.watch(geminiDioProvider)),
);

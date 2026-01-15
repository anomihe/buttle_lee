import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../services/gemini_service.dart';

/// Endpoint for AI-powered command processing
class AiEndpoint extends Endpoint {
  /// Process a natural language command using Gemini API
  Future<String> processCommand(Session session, String command) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    // Get user ID directly from session (works for email auth)
    final userId = authInfo.userId;

    try {
      final geminiService = GeminiService(session);
      final response = await geminiService.processCommand(
        command,
        userId,
      );

      return response;
    } catch (e) {
      session.log('Error processing command: $e');
      return 'Sorry, I encountered an error processing your request.';
    }
  }
}

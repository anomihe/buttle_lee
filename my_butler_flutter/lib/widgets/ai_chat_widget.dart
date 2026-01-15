import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/auth_provider.dart';
import '../providers/reminder_provider.dart';

class AiChatWidget extends StatefulWidget {
  final VoidCallback? onReminderCreated;

  const AiChatWidget({
    super.key,
    this.onReminderCreated,
  });

  @override
  State<AiChatWidget> createState() => _AiChatWidgetState();
}

class _AiChatWidgetState extends State<AiChatWidget> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isProcessing = false;
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _listeningText = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    // Add welcome message
    _messages.add(
      ChatMessage(
        text:
            'Hello! I\'m your AI butler. How can I help you today? You can ask me to create reminders, answer questions, or help with tasks.',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    // Add user message
    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isProcessing = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final authProvider = context.read<AuthProvider>();
      final reminderProvider = context.read<ReminderProvider>();

      final response = await authProvider.client.ai.processCommand(message);

      setState(() {
        _messages.add(
          ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
        _isProcessing = false;
      });

      _scrollToBottom();

      // Check if a reminder was created by looking at the response
      // This is a simple heuristic - you might want to improve this
      if (response.toLowerCase().contains('reminder') &&
          (response.toLowerCase().contains('created') ||
              response.toLowerCase().contains('set'))) {
        // Reload reminders to get the latest
        await reminderProvider.loadReminders();

        // Notify parent to close the bottom sheet
        if (widget.onReminderCreated != null) {
          // Small delay to let user see the success message
          await Future.delayed(const Duration(milliseconds: 800));
          widget.onReminderCreated!();
        }
      }
    } catch (e) {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Sorry, I encountered an error: $e',
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
        _isProcessing = false;
      });
      _scrollToBottom();
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onError: (error) => debugPrint('Speech recognition error: $error'),
      onStatus: (status) => debugPrint('Speech recognition status: $status'),
    );

    if (available) {
      setState(() {
        _isListening = true;
        _listeningText = '';
      });

      _speech.listen(
        onResult: (result) {
          setState(() {
            _listeningText = result.recognizedWords;
            if (result.finalResult) {
              _controller.text = _listeningText;
              _isListening = false;
            }
          });
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
      );
    } else {
      setState(() {
        _messages.add(
          ChatMessage(
            text: 'Speech recognition is not available on this device.',
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ),
        );
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Butler Chat',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(message: message);
              },
            ),
          ),

          // Processing indicator
          if (_isProcessing)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AI is thinking...',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

          const Divider(height: 1),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      enabled: !_isProcessing,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Microphone button
                  if (!_isListening)
                    IconButton(
                      icon: const Icon(Icons.mic),
                      onPressed: _isProcessing ? null : _startListening,
                      color: Theme.of(context).colorScheme.primary,
                      tooltip: 'Voice Input',
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.mic_off),
                      onPressed: _stopListening,
                      color: Colors.red,
                      tooltip: 'Stop Listening',
                    ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _isProcessing ? null : _sendMessage,
                    mini: true,
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
          // Listening indicator
          if (_isListening)
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Row(
                children: [
                  Icon(
                    Icons.mic,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _listeningText.isEmpty ? 'Listening...' : _listeningText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: message.isError
                  ? Colors.red[100]
                  : Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                message.isError ? Icons.error_outline : Icons.psychology,
                size: 18,
                color: message.isError
                    ? Colors.red[700]
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Theme.of(context).colorScheme.primary
                    : message.isError
                        ? Colors.red[50]
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : message.isError
                              ? Colors.red[900]
                              : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 10,
                      color: message.isUser ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
              child: Icon(
                Icons.person,
                size: 18,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}

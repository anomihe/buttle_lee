import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/book_provider.dart';

class ReadingTrackerSheet extends StatefulWidget {
  const ReadingTrackerSheet({super.key});

  @override
  State<ReadingTrackerSheet> createState() => _ReadingTrackerSheetState();
}

class _ReadingTrackerSheetState extends State<ReadingTrackerSheet> {
  late ConfettiController _confettiController;
  bool _isAdding = false;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().loadBooks();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _handleAddBook() async {
    if (_formKey.currentState!.validate()) {
      await context
          .read<BookProvider>()
          .addBook(_titleController.text, _authorController.text);

      if (mounted) {
        setState(() {
          _isAdding = false;
          _titleController.clear();
          _authorController.clear();
        });
      }
    }
  }

  void _handleFinishBook(int id) async {
    _confettiController.play();
    await context.read<BookProvider>().finishBook(id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(
                bottom: 20), // Add bottom padding for better scroll
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use min size
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.book, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Reading Tracker',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(_isAdding ? Icons.close : Icons.add),
                        onPressed: () {
                          setState(() {
                            _isAdding = !_isAdding;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Add Book Form
                if (_isAdding)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Book Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _authorController,
                            decoration: const InputDecoration(
                              labelText: 'Author',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) =>
                                value?.isEmpty ?? true ? 'Required' : null,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _handleAddBook,
                              child: const Text('Start Reading'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Books List
                Consumer<BookProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (provider.readingBooks.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.menu_book,
                                  size: 48, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              const Text(
                                  'No active books.\nStart reading one!'),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.readingBooks.length,
                      itemBuilder: (context, index) {
                        final book = provider.readingBooks[index];
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 60,
                            color: Colors.blueGrey[100],
                            child: const Icon(Icons.book, color: Colors.white),
                          ),
                          title: Text(book.title),
                          subtitle: Text(book.author),
                          trailing: IconButton(
                            icon: const Icon(Icons.check_circle_outline),
                            color: Colors.green,
                            onPressed: () => _handleFinishBook(book.id!),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }
}

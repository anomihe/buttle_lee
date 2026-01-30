import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import 'dart:ui';
import '../providers/book_provider.dart';

class ReadingTrackerSheet extends StatefulWidget {
  const ReadingTrackerSheet({super.key});

  @override
  State<ReadingTrackerSheet> createState() => _ReadingTrackerSheetState();
}

class _ReadingTrackerSheetState extends State<ReadingTrackerSheet> {
  late ConfettiController _confettiController;

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
    super.dispose();
  }

  void _showAddBookSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddBookBottomSheet(),
    );
  }

  void _handleFinishBook(int id) async {
    _confettiController.play();
    await context.read<BookProvider>().finishBook(id);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          Column(
            children: [
              // Modern Top Bar with Solid Color & Glassmorphism
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: SafeArea(
                  bottom: false,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: Row(
                          children: [
                            // Title
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reading Tracker',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Track your literary journey',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Add Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: _showAddBookSheet,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Content Area
              Expanded(
                child: Consumer<BookProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      );
                    }

                    if (provider.readingBooks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.menu_book_rounded,
                                size: 64,
                                color: primaryColor.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'No active books',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap the + button to start reading',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark ? Colors.white38 : Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.readingBooks.length,
                      itemBuilder: (context, index) {
                        final book = provider.readingBooks[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color:
                                isDark ? const Color(0xFF1B2838) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 48,
                              height: 64,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.book_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            title: Text(
                              book.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                book.author,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isDark ? Colors.white60 : Colors.black54,
                                ),
                              ),
                            ),
                            trailing: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => _handleFinishBook(book.id!),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                primaryColor,
                Theme.of(context).colorScheme.secondary,
                Colors.green,
                Colors.blue,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Add Book Bottom Sheet Widget
class _AddBookBottomSheet extends StatefulWidget {
  @override
  State<_AddBookBottomSheet> createState() => _AddBookBottomSheetState();
}

class _AddBookBottomSheetState extends State<_AddBookBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void dispose() {
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
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2838) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Add New Book',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Book Title Section
                Text(
                  'Book Title',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'The Lord of the Rings',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter a book title'
                      : null,
                ),
                const SizedBox(height: 20),

                // Author Section
                Text(
                  'Author',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _authorController,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'J.R.R. Tolkien',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.grey.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter the author name'
                      : null,
                ),
                const SizedBox(height: 24),

                // Start Reading Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _handleAddBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'Start Reading',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

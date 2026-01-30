import 'package:flutter/material.dart';
import 'package:my_butler_client/my_butler_client.dart';

class BookProvider with ChangeNotifier {
  final Client client;

  BookProvider({required this.client});

  List<Book> _books = [];
  Map<int, List<Chapter>> _chapters = {}; // bookId -> chapters
  bool _isLoading = false;

  List<Book> get books => _books;
  List<Book> get readingBooks => _books.where((b) => b.status == 0).toList();
  List<Book> get finishedBooks => _books.where((b) => b.status == 1).toList();
  bool get isLoading => _isLoading;

  List<Chapter> getChaptersForBook(int bookId) {
    return _chapters[bookId] ?? [];
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _books = await client.book.getBooks();
    } catch (e) {
      debugPrint('Error loading books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadChapters(int bookId) async {
    try {
      final chapters = await client.book.getChapters(bookId);
      _chapters[bookId] = chapters;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading chapters: $e');
    }
  }

  Future<void> addBook(String title, String author) async {
    final book = Book(
      userId: 0, // Server handles this
      title: title,
      author: author,
      status: 0, // Reading
      startedDate: DateTime.now(),
      isCompleted: false,
    );
    try {
      await client.book.addBook(book);
      await loadBooks();
    } catch (e) {
      debugPrint('Error adding book: $e');
    }
  }

  Future<void> addBookWithChapters(
    String title,
    String author,
    List<String> chapterTitles,
  ) async {
    try {
      debugPrint('📚 Adding book with chapters: $title by $author');
      debugPrint('📖 Chapters: ${chapterTitles.length} - $chapterTitles');

      final book = await client.book.addBookWithChapters(
        title,
        author,
        chapterTitles,
      );

      debugPrint('✅ Book created: ${book?.id} - ${book?.title}');

      if (book != null) {
        debugPrint('🔄 Reloading books...');
        await loadBooks();
        debugPrint('✅ Books reloaded. Total books: ${_books.length}');

        // Load chapters for the new book
        debugPrint('📖 Loading chapters for book ${book.id}...');
        await loadChapters(book.id!);
        debugPrint('✅ Chapters loaded: ${_chapters[book.id!]?.length ?? 0}');
      } else {
        debugPrint('❌ Book creation returned null');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Error adding book with chapters: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  Future<void> completeChapter(int chapterId, int bookId) async {
    try {
      await client.book.completeChapter(chapterId);
      await loadChapters(bookId);
    } catch (e) {
      debugPrint('Error completing chapter: $e');
    }
  }

  Future<void> uncompleteChapter(int chapterId, int bookId) async {
    try {
      await client.book.uncompleteChapter(chapterId);
      await loadChapters(bookId);
    } catch (e) {
      debugPrint('Error uncompleting chapter: $e');
    }
  }

  Future<void> completeBook(int bookId, String? lessonsLearned) async {
    try {
      await client.book.completeBook(bookId, lessonsLearned);
      await loadBooks();
    } catch (e) {
      debugPrint('Error completing book: $e');
    }
  }

  Future<void> updateLessons(int bookId, String lessonsLearned) async {
    try {
      await client.book.updateLessons(bookId, lessonsLearned);
      await loadBooks();
    } catch (e) {
      debugPrint('Error updating lessons: $e');
    }
  }

  Future<void> finishBook(int id) async {
    try {
      await client.book.finishBook(id);
      await loadBooks();
    } catch (e) {
      debugPrint('Error finishing book: $e');
    }
  }
}

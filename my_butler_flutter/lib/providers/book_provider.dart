import 'package:flutter/material.dart';
import 'package:my_butler_client/my_butler_client.dart';

class BookProvider with ChangeNotifier {
  final Client client;

  BookProvider({required this.client});

  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  List<Book> get readingBooks => _books.where((b) => b.status == 0).toList();
  List<Book> get finishedBooks => _books.where((b) => b.status == 1).toList();
  bool get isLoading => _isLoading;

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

  Future<void> addBook(String title, String author) async {
    final book = Book(
      userId: 0, // Server handles this
      title: title,
      author: author,
      status: 0, // Reading
      startedDate: DateTime.now(),
    );
    try {
      await client.book.addBook(book);
      await loadBooks();
    } catch (e) {
      debugPrint('Error adding book: $e');
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

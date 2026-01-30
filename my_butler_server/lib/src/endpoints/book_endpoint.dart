import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

class BookEndpoint extends Endpoint {
  Future<void> addBook(Session session, Book book) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    book.userId = userId;
    await Book.db.insertRow(session, book);
  }

  /// Add a book with chapters
  Future<Book?> addBookWithChapters(
    Session session,
    String title,
    String author,
    List<String> chapterTitles,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return null;
    final userId = authInfo.userId;

    // Create the book
    final book = Book(
      userId: userId,
      title: title,
      author: author,
      status: 0, // Reading
      startedDate: DateTime.now(),
      isCompleted: false,
    );

    final insertedBook = await Book.db.insertRow(session, book);

    // Create chapters if provided
    if (chapterTitles.isNotEmpty) {
      for (var i = 0; i < chapterTitles.length; i++) {
        final chapter = Chapter(
          bookId: insertedBook.id!,
          title: chapterTitles[i],
          chapterOrder: i,
          isCompleted: false,
        );
        await Chapter.db.insertRow(session, chapter);
      }
    }

    return insertedBook;
  }

  Future<List<Book>> getBooks(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return [];
    final userId = authInfo.userId;

    return await Book.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.startedDate,
      orderDescending: true,
    );
  }

  /// Get chapters for a specific book
  Future<List<Chapter>> getChapters(Session session, int bookId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return [];

    return await Chapter.db.find(
      session,
      where: (t) => t.bookId.equals(bookId),
      orderBy: (t) => t.chapterOrder,
    );
  }

  Future<void> finishBook(Session session, int id) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    final book = await Book.db.findById(session, id);
    if (book != null && book.userId == userId) {
      book.status = 1; // Finished
      book.finishedDate = DateTime.now();
      await Book.db.updateRow(session, book);
    }
  }

  /// Mark a book as completed with optional lessons learned
  Future<void> completeBook(
    Session session,
    int bookId,
    String? lessonsLearned,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    final book = await Book.db.findById(session, bookId);
    if (book != null && book.userId == userId) {
      book.status = 1; // Finished
      book.isCompleted = true;
      book.finishedDate = DateTime.now();
      if (lessonsLearned != null) {
        book.lessonsLearned = lessonsLearned;
      }
      await Book.db.updateRow(session, book);
    }
  }

  /// Update lessons learned for a book
  Future<void> updateLessons(
    Session session,
    int bookId,
    String lessonsLearned,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    final book = await Book.db.findById(session, bookId);
    if (book != null && book.userId == userId) {
      book.lessonsLearned = lessonsLearned;
      await Book.db.updateRow(session, book);
    }
  }

  /// Mark a chapter as completed
  Future<void> completeChapter(Session session, int chapterId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;

    final chapter = await Chapter.db.findById(session, chapterId);
    if (chapter != null) {
      chapter.isCompleted = true;
      chapter.completedAt = DateTime.now();
      await Chapter.db.updateRow(session, chapter);
    }
  }

  /// Uncomplete a chapter (for undo functionality)
  Future<void> uncompleteChapter(Session session, int chapterId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;

    final chapter = await Chapter.db.findById(session, chapterId);
    if (chapter != null) {
      chapter.isCompleted = false;
      chapter.completedAt = null;
      await Chapter.db.updateRow(session, chapter);
    }
  }
}

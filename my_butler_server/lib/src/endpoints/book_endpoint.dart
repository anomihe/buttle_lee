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
}

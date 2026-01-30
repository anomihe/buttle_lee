/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Book implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Book._({
    this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.status,
    required this.startedDate,
    this.finishedDate,
    this.lessonsLearned,
    bool? isCompleted,
  }) : isCompleted = isCompleted ?? false;

  factory Book({
    int? id,
    required int userId,
    required String title,
    required String author,
    required int status,
    required DateTime startedDate,
    DateTime? finishedDate,
    String? lessonsLearned,
    bool? isCompleted,
  }) = _BookImpl;

  factory Book.fromJson(Map<String, dynamic> jsonSerialization) {
    return Book(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      title: jsonSerialization['title'] as String,
      author: jsonSerialization['author'] as String,
      status: jsonSerialization['status'] as int,
      startedDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedDate'],
      ),
      finishedDate: jsonSerialization['finishedDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['finishedDate'],
            ),
      lessonsLearned: jsonSerialization['lessonsLearned'] as String?,
      isCompleted: jsonSerialization['isCompleted'] as bool?,
    );
  }

  static final t = BookTable();

  static const db = BookRepository._();

  @override
  int? id;

  int userId;

  String title;

  String author;

  int status;

  DateTime startedDate;

  DateTime? finishedDate;

  String? lessonsLearned;

  bool isCompleted;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Book copyWith({
    int? id,
    int? userId,
    String? title,
    String? author,
    int? status,
    DateTime? startedDate,
    DateTime? finishedDate,
    String? lessonsLearned,
    bool? isCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Book',
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'author': author,
      'status': status,
      'startedDate': startedDate.toJson(),
      if (finishedDate != null) 'finishedDate': finishedDate?.toJson(),
      if (lessonsLearned != null) 'lessonsLearned': lessonsLearned,
      'isCompleted': isCompleted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Book',
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'author': author,
      'status': status,
      'startedDate': startedDate.toJson(),
      if (finishedDate != null) 'finishedDate': finishedDate?.toJson(),
      if (lessonsLearned != null) 'lessonsLearned': lessonsLearned,
      'isCompleted': isCompleted,
    };
  }

  static BookInclude include() {
    return BookInclude._();
  }

  static BookIncludeList includeList({
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    BookInclude? include,
  }) {
    return BookIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Book.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookImpl extends Book {
  _BookImpl({
    int? id,
    required int userId,
    required String title,
    required String author,
    required int status,
    required DateTime startedDate,
    DateTime? finishedDate,
    String? lessonsLearned,
    bool? isCompleted,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         author: author,
         status: status,
         startedDate: startedDate,
         finishedDate: finishedDate,
         lessonsLearned: lessonsLearned,
         isCompleted: isCompleted,
       );

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Book copyWith({
    Object? id = _Undefined,
    int? userId,
    String? title,
    String? author,
    int? status,
    DateTime? startedDate,
    Object? finishedDate = _Undefined,
    Object? lessonsLearned = _Undefined,
    bool? isCompleted,
  }) {
    return Book(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      author: author ?? this.author,
      status: status ?? this.status,
      startedDate: startedDate ?? this.startedDate,
      finishedDate: finishedDate is DateTime?
          ? finishedDate
          : this.finishedDate,
      lessonsLearned: lessonsLearned is String?
          ? lessonsLearned
          : this.lessonsLearned,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class BookUpdateTable extends _i1.UpdateTable<BookTable> {
  BookUpdateTable(super.table);

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> author(String value) => _i1.ColumnValue(
    table.author,
    value,
  );

  _i1.ColumnValue<int, int> status(int value) => _i1.ColumnValue(
    table.status,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> startedDate(DateTime value) =>
      _i1.ColumnValue(
        table.startedDate,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> finishedDate(DateTime? value) =>
      _i1.ColumnValue(
        table.finishedDate,
        value,
      );

  _i1.ColumnValue<String, String> lessonsLearned(String? value) =>
      _i1.ColumnValue(
        table.lessonsLearned,
        value,
      );

  _i1.ColumnValue<bool, bool> isCompleted(bool value) => _i1.ColumnValue(
    table.isCompleted,
    value,
  );
}

class BookTable extends _i1.Table<int?> {
  BookTable({super.tableRelation}) : super(tableName: 'book') {
    updateTable = BookUpdateTable(this);
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    author = _i1.ColumnString(
      'author',
      this,
    );
    status = _i1.ColumnInt(
      'status',
      this,
    );
    startedDate = _i1.ColumnDateTime(
      'startedDate',
      this,
    );
    finishedDate = _i1.ColumnDateTime(
      'finishedDate',
      this,
    );
    lessonsLearned = _i1.ColumnString(
      'lessonsLearned',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
      hasDefault: true,
    );
  }

  late final BookUpdateTable updateTable;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString title;

  late final _i1.ColumnString author;

  late final _i1.ColumnInt status;

  late final _i1.ColumnDateTime startedDate;

  late final _i1.ColumnDateTime finishedDate;

  late final _i1.ColumnString lessonsLearned;

  late final _i1.ColumnBool isCompleted;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    title,
    author,
    status,
    startedDate,
    finishedDate,
    lessonsLearned,
    isCompleted,
  ];
}

class BookInclude extends _i1.IncludeObject {
  BookInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Book.t;
}

class BookIncludeList extends _i1.IncludeList {
  BookIncludeList._({
    _i1.WhereExpressionBuilder<BookTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Book.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Book.t;
}

class BookRepository {
  const BookRepository._();

  /// Returns a list of [Book]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Book>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Book] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Book?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Book>(
      where: where?.call(Book.t),
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Book] by its [id] or null if no such row exists.
  Future<Book?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Book>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Book]s in the list and returns the inserted rows.
  ///
  /// The returned [Book]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Book>> insert(
    _i1.Session session,
    List<Book> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Book>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Book] and returns the inserted row.
  ///
  /// The returned [Book] will have its `id` field set.
  Future<Book> insertRow(
    _i1.Session session,
    Book row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Book>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Book]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Book>> update(
    _i1.Session session,
    List<Book> rows, {
    _i1.ColumnSelections<BookTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Book>(
      rows,
      columns: columns?.call(Book.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Book]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Book> updateRow(
    _i1.Session session,
    Book row, {
    _i1.ColumnSelections<BookTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Book>(
      row,
      columns: columns?.call(Book.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Book] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Book?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<BookUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Book>(
      id,
      columnValues: columnValues(Book.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Book]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Book>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<BookUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<BookTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BookTable>? orderBy,
    _i1.OrderByListBuilder<BookTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Book>(
      columnValues: columnValues(Book.t.updateTable),
      where: where(Book.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Book.t),
      orderByList: orderByList?.call(Book.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Book]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Book>> delete(
    _i1.Session session,
    List<Book> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Book>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Book].
  Future<Book> deleteRow(
    _i1.Session session,
    Book row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Book>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Book>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BookTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Book>(
      where: where(Book.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BookTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Book>(
      where: where?.call(Book.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

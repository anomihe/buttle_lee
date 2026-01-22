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
import 'package:my_butler_server/src/generated/protocol.dart' as _i2;

abstract class SharedRoutine
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SharedRoutine._({
    this.id,
    required this.householdId,
    required this.createdBy,
    required this.name,
    required this.tasks,
    required this.sharedAt,
  });

  factory SharedRoutine({
    int? id,
    required int householdId,
    required int createdBy,
    required String name,
    required List<String> tasks,
    required DateTime sharedAt,
  }) = _SharedRoutineImpl;

  factory SharedRoutine.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedRoutine(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as int,
      createdBy: jsonSerialization['createdBy'] as int,
      name: jsonSerialization['name'] as String,
      tasks: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['tasks'],
      ),
      sharedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['sharedAt'],
      ),
    );
  }

  static final t = SharedRoutineTable();

  static const db = SharedRoutineRepository._();

  @override
  int? id;

  int householdId;

  int createdBy;

  String name;

  List<String> tasks;

  DateTime sharedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedRoutine]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedRoutine copyWith({
    int? id,
    int? householdId,
    int? createdBy,
    String? name,
    List<String>? tasks,
    DateTime? sharedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedRoutine',
      if (id != null) 'id': id,
      'householdId': householdId,
      'createdBy': createdBy,
      'name': name,
      'tasks': tasks.toJson(),
      'sharedAt': sharedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedRoutine',
      if (id != null) 'id': id,
      'householdId': householdId,
      'createdBy': createdBy,
      'name': name,
      'tasks': tasks.toJson(),
      'sharedAt': sharedAt.toJson(),
    };
  }

  static SharedRoutineInclude include() {
    return SharedRoutineInclude._();
  }

  static SharedRoutineIncludeList includeList({
    _i1.WhereExpressionBuilder<SharedRoutineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedRoutineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedRoutineTable>? orderByList,
    SharedRoutineInclude? include,
  }) {
    return SharedRoutineIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedRoutine.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SharedRoutine.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedRoutineImpl extends SharedRoutine {
  _SharedRoutineImpl({
    int? id,
    required int householdId,
    required int createdBy,
    required String name,
    required List<String> tasks,
    required DateTime sharedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         createdBy: createdBy,
         name: name,
         tasks: tasks,
         sharedAt: sharedAt,
       );

  /// Returns a shallow copy of this [SharedRoutine]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedRoutine copyWith({
    Object? id = _Undefined,
    int? householdId,
    int? createdBy,
    String? name,
    List<String>? tasks,
    DateTime? sharedAt,
  }) {
    return SharedRoutine(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      createdBy: createdBy ?? this.createdBy,
      name: name ?? this.name,
      tasks: tasks ?? this.tasks.map((e0) => e0).toList(),
      sharedAt: sharedAt ?? this.sharedAt,
    );
  }
}

class SharedRoutineUpdateTable extends _i1.UpdateTable<SharedRoutineTable> {
  SharedRoutineUpdateTable(super.table);

  _i1.ColumnValue<int, int> householdId(int value) => _i1.ColumnValue(
    table.householdId,
    value,
  );

  _i1.ColumnValue<int, int> createdBy(int value) => _i1.ColumnValue(
    table.createdBy,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> tasks(List<String> value) =>
      _i1.ColumnValue(
        table.tasks,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> sharedAt(DateTime value) =>
      _i1.ColumnValue(
        table.sharedAt,
        value,
      );
}

class SharedRoutineTable extends _i1.Table<int?> {
  SharedRoutineTable({super.tableRelation})
    : super(tableName: 'shared_routine') {
    updateTable = SharedRoutineUpdateTable(this);
    householdId = _i1.ColumnInt(
      'householdId',
      this,
    );
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    tasks = _i1.ColumnSerializable<List<String>>(
      'tasks',
      this,
    );
    sharedAt = _i1.ColumnDateTime(
      'sharedAt',
      this,
    );
  }

  late final SharedRoutineUpdateTable updateTable;

  late final _i1.ColumnInt householdId;

  late final _i1.ColumnInt createdBy;

  late final _i1.ColumnString name;

  late final _i1.ColumnSerializable<List<String>> tasks;

  late final _i1.ColumnDateTime sharedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    householdId,
    createdBy,
    name,
    tasks,
    sharedAt,
  ];
}

class SharedRoutineInclude extends _i1.IncludeObject {
  SharedRoutineInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SharedRoutine.t;
}

class SharedRoutineIncludeList extends _i1.IncludeList {
  SharedRoutineIncludeList._({
    _i1.WhereExpressionBuilder<SharedRoutineTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedRoutine.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SharedRoutine.t;
}

class SharedRoutineRepository {
  const SharedRoutineRepository._();

  /// Returns a list of [SharedRoutine]s matching the given query parameters.
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
  Future<List<SharedRoutine>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedRoutineTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedRoutineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedRoutineTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<SharedRoutine>(
      where: where?.call(SharedRoutine.t),
      orderBy: orderBy?.call(SharedRoutine.t),
      orderByList: orderByList?.call(SharedRoutine.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [SharedRoutine] matching the given query parameters.
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
  Future<SharedRoutine?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedRoutineTable>? where,
    int? offset,
    _i1.OrderByBuilder<SharedRoutineTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedRoutineTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<SharedRoutine>(
      where: where?.call(SharedRoutine.t),
      orderBy: orderBy?.call(SharedRoutine.t),
      orderByList: orderByList?.call(SharedRoutine.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [SharedRoutine] by its [id] or null if no such row exists.
  Future<SharedRoutine?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<SharedRoutine>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [SharedRoutine]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedRoutine]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<SharedRoutine>> insert(
    _i1.Session session,
    List<SharedRoutine> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<SharedRoutine>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [SharedRoutine] and returns the inserted row.
  ///
  /// The returned [SharedRoutine] will have its `id` field set.
  Future<SharedRoutine> insertRow(
    _i1.Session session,
    SharedRoutine row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedRoutine>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SharedRoutine]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SharedRoutine>> update(
    _i1.Session session,
    List<SharedRoutine> rows, {
    _i1.ColumnSelections<SharedRoutineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SharedRoutine>(
      rows,
      columns: columns?.call(SharedRoutine.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedRoutine]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedRoutine> updateRow(
    _i1.Session session,
    SharedRoutine row, {
    _i1.ColumnSelections<SharedRoutineTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedRoutine>(
      row,
      columns: columns?.call(SharedRoutine.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedRoutine] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedRoutine?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SharedRoutineUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedRoutine>(
      id,
      columnValues: columnValues(SharedRoutine.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedRoutine]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SharedRoutine>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SharedRoutineUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<SharedRoutineTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedRoutineTable>? orderBy,
    _i1.OrderByListBuilder<SharedRoutineTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SharedRoutine>(
      columnValues: columnValues(SharedRoutine.t.updateTable),
      where: where(SharedRoutine.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedRoutine.t),
      orderByList: orderByList?.call(SharedRoutine.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SharedRoutine]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SharedRoutine>> delete(
    _i1.Session session,
    List<SharedRoutine> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SharedRoutine>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SharedRoutine].
  Future<SharedRoutine> deleteRow(
    _i1.Session session,
    SharedRoutine row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedRoutine>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SharedRoutine>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SharedRoutineTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SharedRoutine>(
      where: where(SharedRoutine.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedRoutineTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SharedRoutine>(
      where: where?.call(SharedRoutine.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

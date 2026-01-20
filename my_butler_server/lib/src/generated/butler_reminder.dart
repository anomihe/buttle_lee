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
import 'priority.dart' as _i2;
import 'reminder_type.dart' as _i3;

abstract class ButlerReminder
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  ButlerReminder._({
    this.id,
    required this.description,
    required this.triggerTime,
    required this.reminderType,
    _i2.Priority? priority,
    this.snoozedUntil,
    required this.userId,
    bool? isActive,
    this.assignedToUserId,
  }) : priority = priority ?? _i2.Priority.medium,
       isActive = isActive ?? true;

  factory ButlerReminder({
    int? id,
    required String description,
    required DateTime triggerTime,
    required _i3.ReminderType reminderType,
    _i2.Priority? priority,
    DateTime? snoozedUntil,
    required int userId,
    bool? isActive,
    int? assignedToUserId,
  }) = _ButlerReminderImpl;

  factory ButlerReminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ButlerReminder(
      id: jsonSerialization['id'] as int?,
      description: jsonSerialization['description'] as String,
      triggerTime: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['triggerTime'],
      ),
      reminderType: _i3.ReminderType.fromJson(
        (jsonSerialization['reminderType'] as String),
      ),
      priority: _i2.Priority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      snoozedUntil: jsonSerialization['snoozedUntil'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['snoozedUntil'],
            ),
      userId: jsonSerialization['userId'] as int,
      isActive: jsonSerialization['isActive'] as bool,
      assignedToUserId: jsonSerialization['assignedToUserId'] as int?,
    );
  }

  static final t = ButlerReminderTable();

  static const db = ButlerReminderRepository._();

  @override
  int? id;

  String description;

  DateTime triggerTime;

  _i3.ReminderType reminderType;

  _i2.Priority priority;

  DateTime? snoozedUntil;

  int userId;

  bool isActive;

  int? assignedToUserId;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [ButlerReminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ButlerReminder copyWith({
    int? id,
    String? description,
    DateTime? triggerTime,
    _i3.ReminderType? reminderType,
    _i2.Priority? priority,
    DateTime? snoozedUntil,
    int? userId,
    bool? isActive,
    int? assignedToUserId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ButlerReminder',
      if (id != null) 'id': id,
      'description': description,
      'triggerTime': triggerTime.toJson(),
      'reminderType': reminderType.toJson(),
      'priority': priority.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'userId': userId,
      'isActive': isActive,
      if (assignedToUserId != null) 'assignedToUserId': assignedToUserId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ButlerReminder',
      if (id != null) 'id': id,
      'description': description,
      'triggerTime': triggerTime.toJson(),
      'reminderType': reminderType.toJson(),
      'priority': priority.toJson(),
      if (snoozedUntil != null) 'snoozedUntil': snoozedUntil?.toJson(),
      'userId': userId,
      'isActive': isActive,
      if (assignedToUserId != null) 'assignedToUserId': assignedToUserId,
    };
  }

  static ButlerReminderInclude include() {
    return ButlerReminderInclude._();
  }

  static ButlerReminderIncludeList includeList({
    _i1.WhereExpressionBuilder<ButlerReminderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ButlerReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ButlerReminderTable>? orderByList,
    ButlerReminderInclude? include,
  }) {
    return ButlerReminderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ButlerReminder.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ButlerReminder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ButlerReminderImpl extends ButlerReminder {
  _ButlerReminderImpl({
    int? id,
    required String description,
    required DateTime triggerTime,
    required _i3.ReminderType reminderType,
    _i2.Priority? priority,
    DateTime? snoozedUntil,
    required int userId,
    bool? isActive,
    int? assignedToUserId,
  }) : super._(
         id: id,
         description: description,
         triggerTime: triggerTime,
         reminderType: reminderType,
         priority: priority,
         snoozedUntil: snoozedUntil,
         userId: userId,
         isActive: isActive,
         assignedToUserId: assignedToUserId,
       );

  /// Returns a shallow copy of this [ButlerReminder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ButlerReminder copyWith({
    Object? id = _Undefined,
    String? description,
    DateTime? triggerTime,
    _i3.ReminderType? reminderType,
    _i2.Priority? priority,
    Object? snoozedUntil = _Undefined,
    int? userId,
    bool? isActive,
    Object? assignedToUserId = _Undefined,
  }) {
    return ButlerReminder(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      triggerTime: triggerTime ?? this.triggerTime,
      reminderType: reminderType ?? this.reminderType,
      priority: priority ?? this.priority,
      snoozedUntil: snoozedUntil is DateTime?
          ? snoozedUntil
          : this.snoozedUntil,
      userId: userId ?? this.userId,
      isActive: isActive ?? this.isActive,
      assignedToUserId: assignedToUserId is int?
          ? assignedToUserId
          : this.assignedToUserId,
    );
  }
}

class ButlerReminderUpdateTable extends _i1.UpdateTable<ButlerReminderTable> {
  ButlerReminderUpdateTable(super.table);

  _i1.ColumnValue<String, String> description(String value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> triggerTime(DateTime value) =>
      _i1.ColumnValue(
        table.triggerTime,
        value,
      );

  _i1.ColumnValue<_i3.ReminderType, _i3.ReminderType> reminderType(
    _i3.ReminderType value,
  ) => _i1.ColumnValue(
    table.reminderType,
    value,
  );

  _i1.ColumnValue<_i2.Priority, _i2.Priority> priority(_i2.Priority value) =>
      _i1.ColumnValue(
        table.priority,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> snoozedUntil(DateTime? value) =>
      _i1.ColumnValue(
        table.snoozedUntil,
        value,
      );

  _i1.ColumnValue<int, int> userId(int value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<bool, bool> isActive(bool value) => _i1.ColumnValue(
    table.isActive,
    value,
  );

  _i1.ColumnValue<int, int> assignedToUserId(int? value) => _i1.ColumnValue(
    table.assignedToUserId,
    value,
  );
}

class ButlerReminderTable extends _i1.Table<int?> {
  ButlerReminderTable({super.tableRelation})
    : super(tableName: 'butler_reminder') {
    updateTable = ButlerReminderUpdateTable(this);
    description = _i1.ColumnString(
      'description',
      this,
    );
    triggerTime = _i1.ColumnDateTime(
      'triggerTime',
      this,
    );
    reminderType = _i1.ColumnEnum(
      'reminderType',
      this,
      _i1.EnumSerialization.byName,
    );
    priority = _i1.ColumnEnum(
      'priority',
      this,
      _i1.EnumSerialization.byName,
      hasDefault: true,
    );
    snoozedUntil = _i1.ColumnDateTime(
      'snoozedUntil',
      this,
    );
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
    assignedToUserId = _i1.ColumnInt(
      'assignedToUserId',
      this,
    );
  }

  late final ButlerReminderUpdateTable updateTable;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime triggerTime;

  late final _i1.ColumnEnum<_i3.ReminderType> reminderType;

  late final _i1.ColumnEnum<_i2.Priority> priority;

  late final _i1.ColumnDateTime snoozedUntil;

  late final _i1.ColumnInt userId;

  late final _i1.ColumnBool isActive;

  late final _i1.ColumnInt assignedToUserId;

  @override
  List<_i1.Column> get columns => [
    id,
    description,
    triggerTime,
    reminderType,
    priority,
    snoozedUntil,
    userId,
    isActive,
    assignedToUserId,
  ];
}

class ButlerReminderInclude extends _i1.IncludeObject {
  ButlerReminderInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ButlerReminder.t;
}

class ButlerReminderIncludeList extends _i1.IncludeList {
  ButlerReminderIncludeList._({
    _i1.WhereExpressionBuilder<ButlerReminderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ButlerReminder.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ButlerReminder.t;
}

class ButlerReminderRepository {
  const ButlerReminderRepository._();

  /// Returns a list of [ButlerReminder]s matching the given query parameters.
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
  Future<List<ButlerReminder>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ButlerReminderTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ButlerReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ButlerReminderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ButlerReminder>(
      where: where?.call(ButlerReminder.t),
      orderBy: orderBy?.call(ButlerReminder.t),
      orderByList: orderByList?.call(ButlerReminder.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ButlerReminder] matching the given query parameters.
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
  Future<ButlerReminder?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ButlerReminderTable>? where,
    int? offset,
    _i1.OrderByBuilder<ButlerReminderTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ButlerReminderTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ButlerReminder>(
      where: where?.call(ButlerReminder.t),
      orderBy: orderBy?.call(ButlerReminder.t),
      orderByList: orderByList?.call(ButlerReminder.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ButlerReminder] by its [id] or null if no such row exists.
  Future<ButlerReminder?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ButlerReminder>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ButlerReminder]s in the list and returns the inserted rows.
  ///
  /// The returned [ButlerReminder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ButlerReminder>> insert(
    _i1.Session session,
    List<ButlerReminder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ButlerReminder>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ButlerReminder] and returns the inserted row.
  ///
  /// The returned [ButlerReminder] will have its `id` field set.
  Future<ButlerReminder> insertRow(
    _i1.Session session,
    ButlerReminder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ButlerReminder>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ButlerReminder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ButlerReminder>> update(
    _i1.Session session,
    List<ButlerReminder> rows, {
    _i1.ColumnSelections<ButlerReminderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ButlerReminder>(
      rows,
      columns: columns?.call(ButlerReminder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ButlerReminder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ButlerReminder> updateRow(
    _i1.Session session,
    ButlerReminder row, {
    _i1.ColumnSelections<ButlerReminderTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ButlerReminder>(
      row,
      columns: columns?.call(ButlerReminder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ButlerReminder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ButlerReminder?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<ButlerReminderUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ButlerReminder>(
      id,
      columnValues: columnValues(ButlerReminder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ButlerReminder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ButlerReminder>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<ButlerReminderUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ButlerReminderTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ButlerReminderTable>? orderBy,
    _i1.OrderByListBuilder<ButlerReminderTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ButlerReminder>(
      columnValues: columnValues(ButlerReminder.t.updateTable),
      where: where(ButlerReminder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ButlerReminder.t),
      orderByList: orderByList?.call(ButlerReminder.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ButlerReminder]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ButlerReminder>> delete(
    _i1.Session session,
    List<ButlerReminder> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ButlerReminder>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ButlerReminder].
  Future<ButlerReminder> deleteRow(
    _i1.Session session,
    ButlerReminder row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ButlerReminder>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ButlerReminder>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ButlerReminderTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ButlerReminder>(
      where: where(ButlerReminder.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ButlerReminderTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ButlerReminder>(
      where: where?.call(ButlerReminder.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

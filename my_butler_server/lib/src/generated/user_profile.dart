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

abstract class UserProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
    required this.userInfoId,
    int? xp,
    int? level,
    int? hydrationGoal,
    int? hydrationCount,
    this.hydrationDate,
    bool? hydrationReminder,
    this.hydrationHistory,
    int? focusCompleted,
    int? focusGivenUp,
    int? hydrationInterval,
    bool? journalReminder,
    int? journalInterval,
    bool? bookReminder,
    int? bookInterval,
    int? focusModeDuration,
  }) : xp = xp ?? 0,
       level = level ?? 1,
       hydrationGoal = hydrationGoal ?? 8,
       hydrationCount = hydrationCount ?? 0,
       hydrationReminder = hydrationReminder ?? false,
       focusCompleted = focusCompleted ?? 0,
       focusGivenUp = focusGivenUp ?? 0,
       hydrationInterval = hydrationInterval ?? 60,
       journalReminder = journalReminder ?? false,
       journalInterval = journalInterval ?? 24,
       bookReminder = bookReminder ?? false,
       bookInterval = bookInterval ?? 24,
       focusModeDuration = focusModeDuration ?? 25;

  factory UserProfile({
    int? id,
    required String fullName,
    required String email,
    String? profileImageUrl,
    required int userInfoId,
    int? xp,
    int? level,
    int? hydrationGoal,
    int? hydrationCount,
    String? hydrationDate,
    bool? hydrationReminder,
    String? hydrationHistory,
    int? focusCompleted,
    int? focusGivenUp,
    int? hydrationInterval,
    bool? journalReminder,
    int? journalInterval,
    bool? bookReminder,
    int? bookInterval,
    int? focusModeDuration,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String,
      profileImageUrl: jsonSerialization['profileImageUrl'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      xp: jsonSerialization['xp'] as int?,
      level: jsonSerialization['level'] as int?,
      hydrationGoal: jsonSerialization['hydrationGoal'] as int?,
      hydrationCount: jsonSerialization['hydrationCount'] as int?,
      hydrationDate: jsonSerialization['hydrationDate'] as String?,
      hydrationReminder: jsonSerialization['hydrationReminder'] as bool?,
      hydrationHistory: jsonSerialization['hydrationHistory'] as String?,
      focusCompleted: jsonSerialization['focusCompleted'] as int?,
      focusGivenUp: jsonSerialization['focusGivenUp'] as int?,
      hydrationInterval: jsonSerialization['hydrationInterval'] as int?,
      journalReminder: jsonSerialization['journalReminder'] as bool?,
      journalInterval: jsonSerialization['journalInterval'] as int?,
      bookReminder: jsonSerialization['bookReminder'] as bool?,
      bookInterval: jsonSerialization['bookInterval'] as int?,
      focusModeDuration: jsonSerialization['focusModeDuration'] as int?,
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  int? id;

  String fullName;

  String email;

  String? profileImageUrl;

  int userInfoId;

  int xp;

  int level;

  int hydrationGoal;

  int hydrationCount;

  String? hydrationDate;

  bool hydrationReminder;

  String? hydrationHistory;

  int focusCompleted;

  int focusGivenUp;

  int hydrationInterval;

  bool journalReminder;

  int journalInterval;

  bool bookReminder;

  int bookInterval;

  int focusModeDuration;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    int? userInfoId,
    int? xp,
    int? level,
    int? hydrationGoal,
    int? hydrationCount,
    String? hydrationDate,
    bool? hydrationReminder,
    String? hydrationHistory,
    int? focusCompleted,
    int? focusGivenUp,
    int? hydrationInterval,
    bool? journalReminder,
    int? journalInterval,
    bool? bookReminder,
    int? bookInterval,
    int? focusModeDuration,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'fullName': fullName,
      'email': email,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'userInfoId': userInfoId,
      'xp': xp,
      'level': level,
      'hydrationGoal': hydrationGoal,
      'hydrationCount': hydrationCount,
      if (hydrationDate != null) 'hydrationDate': hydrationDate,
      'hydrationReminder': hydrationReminder,
      if (hydrationHistory != null) 'hydrationHistory': hydrationHistory,
      'focusCompleted': focusCompleted,
      'focusGivenUp': focusGivenUp,
      'hydrationInterval': hydrationInterval,
      'journalReminder': journalReminder,
      'journalInterval': journalInterval,
      'bookReminder': bookReminder,
      'bookInterval': bookInterval,
      'focusModeDuration': focusModeDuration,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'fullName': fullName,
      'email': email,
      if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      'userInfoId': userInfoId,
      'xp': xp,
      'level': level,
      'hydrationGoal': hydrationGoal,
      'hydrationCount': hydrationCount,
      if (hydrationDate != null) 'hydrationDate': hydrationDate,
      'hydrationReminder': hydrationReminder,
      if (hydrationHistory != null) 'hydrationHistory': hydrationHistory,
      'focusCompleted': focusCompleted,
      'focusGivenUp': focusGivenUp,
      'hydrationInterval': hydrationInterval,
      'journalReminder': journalReminder,
      'journalInterval': journalInterval,
      'bookReminder': bookReminder,
      'bookInterval': bookInterval,
      'focusModeDuration': focusModeDuration,
    };
  }

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required String fullName,
    required String email,
    String? profileImageUrl,
    required int userInfoId,
    int? xp,
    int? level,
    int? hydrationGoal,
    int? hydrationCount,
    String? hydrationDate,
    bool? hydrationReminder,
    String? hydrationHistory,
    int? focusCompleted,
    int? focusGivenUp,
    int? hydrationInterval,
    bool? journalReminder,
    int? journalInterval,
    bool? bookReminder,
    int? bookInterval,
    int? focusModeDuration,
  }) : super._(
         id: id,
         fullName: fullName,
         email: email,
         profileImageUrl: profileImageUrl,
         userInfoId: userInfoId,
         xp: xp,
         level: level,
         hydrationGoal: hydrationGoal,
         hydrationCount: hydrationCount,
         hydrationDate: hydrationDate,
         hydrationReminder: hydrationReminder,
         hydrationHistory: hydrationHistory,
         focusCompleted: focusCompleted,
         focusGivenUp: focusGivenUp,
         hydrationInterval: hydrationInterval,
         journalReminder: journalReminder,
         journalInterval: journalInterval,
         bookReminder: bookReminder,
         bookInterval: bookInterval,
         focusModeDuration: focusModeDuration,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? fullName,
    String? email,
    Object? profileImageUrl = _Undefined,
    int? userInfoId,
    int? xp,
    int? level,
    int? hydrationGoal,
    int? hydrationCount,
    Object? hydrationDate = _Undefined,
    bool? hydrationReminder,
    Object? hydrationHistory = _Undefined,
    int? focusCompleted,
    int? focusGivenUp,
    int? hydrationInterval,
    bool? journalReminder,
    int? journalInterval,
    bool? bookReminder,
    int? bookInterval,
    int? focusModeDuration,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl is String?
          ? profileImageUrl
          : this.profileImageUrl,
      userInfoId: userInfoId ?? this.userInfoId,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      hydrationGoal: hydrationGoal ?? this.hydrationGoal,
      hydrationCount: hydrationCount ?? this.hydrationCount,
      hydrationDate: hydrationDate is String?
          ? hydrationDate
          : this.hydrationDate,
      hydrationReminder: hydrationReminder ?? this.hydrationReminder,
      hydrationHistory: hydrationHistory is String?
          ? hydrationHistory
          : this.hydrationHistory,
      focusCompleted: focusCompleted ?? this.focusCompleted,
      focusGivenUp: focusGivenUp ?? this.focusGivenUp,
      hydrationInterval: hydrationInterval ?? this.hydrationInterval,
      journalReminder: journalReminder ?? this.journalReminder,
      journalInterval: journalInterval ?? this.journalInterval,
      bookReminder: bookReminder ?? this.bookReminder,
      bookInterval: bookInterval ?? this.bookInterval,
      focusModeDuration: focusModeDuration ?? this.focusModeDuration,
    );
  }
}

class UserProfileUpdateTable extends _i1.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _i1.ColumnValue<String, String> fullName(String value) => _i1.ColumnValue(
    table.fullName,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> profileImageUrl(String? value) =>
      _i1.ColumnValue(
        table.profileImageUrl,
        value,
      );

  _i1.ColumnValue<int, int> userInfoId(int value) => _i1.ColumnValue(
    table.userInfoId,
    value,
  );

  _i1.ColumnValue<int, int> xp(int value) => _i1.ColumnValue(
    table.xp,
    value,
  );

  _i1.ColumnValue<int, int> level(int value) => _i1.ColumnValue(
    table.level,
    value,
  );

  _i1.ColumnValue<int, int> hydrationGoal(int value) => _i1.ColumnValue(
    table.hydrationGoal,
    value,
  );

  _i1.ColumnValue<int, int> hydrationCount(int value) => _i1.ColumnValue(
    table.hydrationCount,
    value,
  );

  _i1.ColumnValue<String, String> hydrationDate(String? value) =>
      _i1.ColumnValue(
        table.hydrationDate,
        value,
      );

  _i1.ColumnValue<bool, bool> hydrationReminder(bool value) => _i1.ColumnValue(
    table.hydrationReminder,
    value,
  );

  _i1.ColumnValue<String, String> hydrationHistory(String? value) =>
      _i1.ColumnValue(
        table.hydrationHistory,
        value,
      );

  _i1.ColumnValue<int, int> focusCompleted(int value) => _i1.ColumnValue(
    table.focusCompleted,
    value,
  );

  _i1.ColumnValue<int, int> focusGivenUp(int value) => _i1.ColumnValue(
    table.focusGivenUp,
    value,
  );

  _i1.ColumnValue<int, int> hydrationInterval(int value) => _i1.ColumnValue(
    table.hydrationInterval,
    value,
  );

  _i1.ColumnValue<bool, bool> journalReminder(bool value) => _i1.ColumnValue(
    table.journalReminder,
    value,
  );

  _i1.ColumnValue<int, int> journalInterval(int value) => _i1.ColumnValue(
    table.journalInterval,
    value,
  );

  _i1.ColumnValue<bool, bool> bookReminder(bool value) => _i1.ColumnValue(
    table.bookReminder,
    value,
  );

  _i1.ColumnValue<int, int> bookInterval(int value) => _i1.ColumnValue(
    table.bookInterval,
    value,
  );

  _i1.ColumnValue<int, int> focusModeDuration(int value) => _i1.ColumnValue(
    table.focusModeDuration,
    value,
  );
}

class UserProfileTable extends _i1.Table<int?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profile') {
    updateTable = UserProfileUpdateTable(this);
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    profileImageUrl = _i1.ColumnString(
      'profileImageUrl',
      this,
    );
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    xp = _i1.ColumnInt(
      'xp',
      this,
      hasDefault: true,
    );
    level = _i1.ColumnInt(
      'level',
      this,
      hasDefault: true,
    );
    hydrationGoal = _i1.ColumnInt(
      'hydrationGoal',
      this,
      hasDefault: true,
    );
    hydrationCount = _i1.ColumnInt(
      'hydrationCount',
      this,
      hasDefault: true,
    );
    hydrationDate = _i1.ColumnString(
      'hydrationDate',
      this,
    );
    hydrationReminder = _i1.ColumnBool(
      'hydrationReminder',
      this,
      hasDefault: true,
    );
    hydrationHistory = _i1.ColumnString(
      'hydrationHistory',
      this,
    );
    focusCompleted = _i1.ColumnInt(
      'focusCompleted',
      this,
      hasDefault: true,
    );
    focusGivenUp = _i1.ColumnInt(
      'focusGivenUp',
      this,
      hasDefault: true,
    );
    hydrationInterval = _i1.ColumnInt(
      'hydrationInterval',
      this,
      hasDefault: true,
    );
    journalReminder = _i1.ColumnBool(
      'journalReminder',
      this,
      hasDefault: true,
    );
    journalInterval = _i1.ColumnInt(
      'journalInterval',
      this,
      hasDefault: true,
    );
    bookReminder = _i1.ColumnBool(
      'bookReminder',
      this,
      hasDefault: true,
    );
    bookInterval = _i1.ColumnInt(
      'bookInterval',
      this,
      hasDefault: true,
    );
    focusModeDuration = _i1.ColumnInt(
      'focusModeDuration',
      this,
      hasDefault: true,
    );
  }

  late final UserProfileUpdateTable updateTable;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString email;

  late final _i1.ColumnString profileImageUrl;

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnInt xp;

  late final _i1.ColumnInt level;

  late final _i1.ColumnInt hydrationGoal;

  late final _i1.ColumnInt hydrationCount;

  late final _i1.ColumnString hydrationDate;

  late final _i1.ColumnBool hydrationReminder;

  late final _i1.ColumnString hydrationHistory;

  late final _i1.ColumnInt focusCompleted;

  late final _i1.ColumnInt focusGivenUp;

  late final _i1.ColumnInt hydrationInterval;

  late final _i1.ColumnBool journalReminder;

  late final _i1.ColumnInt journalInterval;

  late final _i1.ColumnBool bookReminder;

  late final _i1.ColumnInt bookInterval;

  late final _i1.ColumnInt focusModeDuration;

  @override
  List<_i1.Column> get columns => [
    id,
    fullName,
    email,
    profileImageUrl,
    userInfoId,
    xp,
    level,
    hydrationGoal,
    hydrationCount,
    hydrationDate,
    hydrationReminder,
    hydrationHistory,
    focusCompleted,
    focusGivenUp,
    hydrationInterval,
    journalReminder,
    journalInterval,
    bookReminder,
    bookInterval,
    focusModeDuration,
  ];
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
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
  Future<List<UserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
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
  Future<UserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

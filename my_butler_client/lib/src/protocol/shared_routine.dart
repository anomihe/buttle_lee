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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:my_butler_client/src/protocol/protocol.dart' as _i2;

abstract class SharedRoutine implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int householdId;

  int createdBy;

  String name;

  List<String> tasks;

  DateTime sharedAt;

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

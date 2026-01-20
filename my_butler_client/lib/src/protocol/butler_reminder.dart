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
import 'priority.dart' as _i2;
import 'reminder_type.dart' as _i3;

abstract class ButlerReminder implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String description;

  DateTime triggerTime;

  _i3.ReminderType reminderType;

  _i2.Priority priority;

  DateTime? snoozedUntil;

  int userId;

  bool isActive;

  int? assignedToUserId;

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

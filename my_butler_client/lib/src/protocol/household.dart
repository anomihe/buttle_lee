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

abstract class Household implements _i1.SerializableModel {
  Household._({
    this.id,
    required this.name,
    required this.joinCode,
    required this.adminId,
    bool? isFocusActive,
    this.focusEndTime,
    this.focusMode,
    this.focusStartedBy,
  }) : isFocusActive = isFocusActive ?? false;

  factory Household({
    int? id,
    required String name,
    required String joinCode,
    required int adminId,
    bool? isFocusActive,
    DateTime? focusEndTime,
    String? focusMode,
    int? focusStartedBy,
  }) = _HouseholdImpl;

  factory Household.fromJson(Map<String, dynamic> jsonSerialization) {
    return Household(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      joinCode: jsonSerialization['joinCode'] as String,
      adminId: jsonSerialization['adminId'] as int,
      isFocusActive: jsonSerialization['isFocusActive'] as bool?,
      focusEndTime: jsonSerialization['focusEndTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['focusEndTime'],
            ),
      focusMode: jsonSerialization['focusMode'] as String?,
      focusStartedBy: jsonSerialization['focusStartedBy'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String joinCode;

  int adminId;

  bool isFocusActive;

  DateTime? focusEndTime;

  String? focusMode;

  int? focusStartedBy;

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Household copyWith({
    int? id,
    String? name,
    String? joinCode,
    int? adminId,
    bool? isFocusActive,
    DateTime? focusEndTime,
    String? focusMode,
    int? focusStartedBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'joinCode': joinCode,
      'adminId': adminId,
      'isFocusActive': isFocusActive,
      if (focusEndTime != null) 'focusEndTime': focusEndTime?.toJson(),
      if (focusMode != null) 'focusMode': focusMode,
      if (focusStartedBy != null) 'focusStartedBy': focusStartedBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HouseholdImpl extends Household {
  _HouseholdImpl({
    int? id,
    required String name,
    required String joinCode,
    required int adminId,
    bool? isFocusActive,
    DateTime? focusEndTime,
    String? focusMode,
    int? focusStartedBy,
  }) : super._(
         id: id,
         name: name,
         joinCode: joinCode,
         adminId: adminId,
         isFocusActive: isFocusActive,
         focusEndTime: focusEndTime,
         focusMode: focusMode,
         focusStartedBy: focusStartedBy,
       );

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Household copyWith({
    Object? id = _Undefined,
    String? name,
    String? joinCode,
    int? adminId,
    bool? isFocusActive,
    Object? focusEndTime = _Undefined,
    Object? focusMode = _Undefined,
    Object? focusStartedBy = _Undefined,
  }) {
    return Household(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      joinCode: joinCode ?? this.joinCode,
      adminId: adminId ?? this.adminId,
      isFocusActive: isFocusActive ?? this.isFocusActive,
      focusEndTime: focusEndTime is DateTime?
          ? focusEndTime
          : this.focusEndTime,
      focusMode: focusMode is String? ? focusMode : this.focusMode,
      focusStartedBy: focusStartedBy is int?
          ? focusStartedBy
          : this.focusStartedBy,
    );
  }
}

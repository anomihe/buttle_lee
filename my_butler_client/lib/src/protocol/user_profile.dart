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

abstract class UserProfile implements _i1.SerializableModel {
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
  }) : xp = xp ?? 0,
       level = level ?? 1,
       hydrationGoal = hydrationGoal ?? 8,
       hydrationCount = hydrationCount ?? 0,
       hydrationReminder = hydrationReminder ?? false,
       focusCompleted = focusCompleted ?? 0,
       focusGivenUp = focusGivenUp ?? 0;

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
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
    };
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
    );
  }
}

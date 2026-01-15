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
  });

  factory UserProfile({
    int? id,
    required String fullName,
    required String email,
    String? profileImageUrl,
    required int userInfoId,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String,
      profileImageUrl: jsonSerialization['profileImageUrl'] as String?,
      userInfoId: jsonSerialization['userInfoId'] as int,
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

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? fullName,
    String? email,
    String? profileImageUrl,
    int? userInfoId,
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
  }) : super._(
         id: id,
         fullName: fullName,
         email: email,
         profileImageUrl: profileImageUrl,
         userInfoId: userInfoId,
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
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl is String?
          ? profileImageUrl
          : this.profileImageUrl,
      userInfoId: userInfoId ?? this.userInfoId,
    );
  }
}

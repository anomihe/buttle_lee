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
import 'book.dart' as _i2;
import 'butler_reminder.dart' as _i3;
import 'chapter.dart' as _i4;
import 'greeting.dart' as _i5;
import 'household.dart' as _i6;
import 'household_member.dart' as _i7;
import 'priority.dart' as _i8;
import 'reminder_type.dart' as _i9;
import 'shared_routine.dart' as _i10;
import 'user_profile.dart' as _i11;
import 'package:my_butler_client/src/protocol/book.dart' as _i12;
import 'package:my_butler_client/src/protocol/chapter.dart' as _i13;
import 'package:my_butler_client/src/protocol/user_profile.dart' as _i14;
import 'package:my_butler_client/src/protocol/household.dart' as _i15;
import 'package:my_butler_client/src/protocol/shared_routine.dart' as _i16;
import 'package:my_butler_client/src/protocol/butler_reminder.dart' as _i17;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i18;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i19;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i20;
export 'book.dart';
export 'butler_reminder.dart';
export 'chapter.dart';
export 'greeting.dart';
export 'household.dart';
export 'household_member.dart';
export 'priority.dart';
export 'reminder_type.dart';
export 'shared_routine.dart';
export 'user_profile.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Book) {
      return _i2.Book.fromJson(data) as T;
    }
    if (t == _i3.ButlerReminder) {
      return _i3.ButlerReminder.fromJson(data) as T;
    }
    if (t == _i4.Chapter) {
      return _i4.Chapter.fromJson(data) as T;
    }
    if (t == _i5.Greeting) {
      return _i5.Greeting.fromJson(data) as T;
    }
    if (t == _i6.Household) {
      return _i6.Household.fromJson(data) as T;
    }
    if (t == _i7.HouseholdMember) {
      return _i7.HouseholdMember.fromJson(data) as T;
    }
    if (t == _i8.Priority) {
      return _i8.Priority.fromJson(data) as T;
    }
    if (t == _i9.ReminderType) {
      return _i9.ReminderType.fromJson(data) as T;
    }
    if (t == _i10.SharedRoutine) {
      return _i10.SharedRoutine.fromJson(data) as T;
    }
    if (t == _i11.UserProfile) {
      return _i11.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Book?>()) {
      return (data != null ? _i2.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ButlerReminder?>()) {
      return (data != null ? _i3.ButlerReminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Chapter?>()) {
      return (data != null ? _i4.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Greeting?>()) {
      return (data != null ? _i5.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Household?>()) {
      return (data != null ? _i6.Household.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.HouseholdMember?>()) {
      return (data != null ? _i7.HouseholdMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Priority?>()) {
      return (data != null ? _i8.Priority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.ReminderType?>()) {
      return (data != null ? _i9.ReminderType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.SharedRoutine?>()) {
      return (data != null ? _i10.SharedRoutine.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.UserProfile?>()) {
      return (data != null ? _i11.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i12.Book>) {
      return (data as List).map((e) => deserialize<_i12.Book>(e)).toList() as T;
    }
    if (t == List<_i13.Chapter>) {
      return (data as List).map((e) => deserialize<_i13.Chapter>(e)).toList()
          as T;
    }
    if (t == List<_i14.UserProfile>) {
      return (data as List)
              .map((e) => deserialize<_i14.UserProfile>(e))
              .toList()
          as T;
    }
    if (t == List<_i15.Household>) {
      return (data as List).map((e) => deserialize<_i15.Household>(e)).toList()
          as T;
    }
    if (t == List<_i16.SharedRoutine>) {
      return (data as List)
              .map((e) => deserialize<_i16.SharedRoutine>(e))
              .toList()
          as T;
    }
    if (t == List<_i17.ButlerReminder>) {
      return (data as List)
              .map((e) => deserialize<_i17.ButlerReminder>(e))
              .toList()
          as T;
    }
    try {
      return _i18.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i20.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Book => 'Book',
      _i3.ButlerReminder => 'ButlerReminder',
      _i4.Chapter => 'Chapter',
      _i5.Greeting => 'Greeting',
      _i6.Household => 'Household',
      _i7.HouseholdMember => 'HouseholdMember',
      _i8.Priority => 'Priority',
      _i9.ReminderType => 'ReminderType',
      _i10.SharedRoutine => 'SharedRoutine',
      _i11.UserProfile => 'UserProfile',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('my_butler.', '');
    }

    switch (data) {
      case _i2.Book():
        return 'Book';
      case _i3.ButlerReminder():
        return 'ButlerReminder';
      case _i4.Chapter():
        return 'Chapter';
      case _i5.Greeting():
        return 'Greeting';
      case _i6.Household():
        return 'Household';
      case _i7.HouseholdMember():
        return 'HouseholdMember';
      case _i8.Priority():
        return 'Priority';
      case _i9.ReminderType():
        return 'ReminderType';
      case _i10.SharedRoutine():
        return 'SharedRoutine';
      case _i11.UserProfile():
        return 'UserProfile';
    }
    className = _i18.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i19.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i20.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i2.Book>(data['data']);
    }
    if (dataClassName == 'ButlerReminder') {
      return deserialize<_i3.ButlerReminder>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i4.Chapter>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i5.Greeting>(data['data']);
    }
    if (dataClassName == 'Household') {
      return deserialize<_i6.Household>(data['data']);
    }
    if (dataClassName == 'HouseholdMember') {
      return deserialize<_i7.HouseholdMember>(data['data']);
    }
    if (dataClassName == 'Priority') {
      return deserialize<_i8.Priority>(data['data']);
    }
    if (dataClassName == 'ReminderType') {
      return deserialize<_i9.ReminderType>(data['data']);
    }
    if (dataClassName == 'SharedRoutine') {
      return deserialize<_i10.SharedRoutine>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i11.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i18.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i19.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i20.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i18.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i19.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i20.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}

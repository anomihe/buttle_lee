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
import 'butler_reminder.dart' as _i2;
import 'greeting.dart' as _i3;
import 'priority.dart' as _i4;
import 'reminder_type.dart' as _i5;
import 'user_profile.dart' as _i6;
import 'package:my_butler_client/src/protocol/butler_reminder.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i9;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i10;
export 'butler_reminder.dart';
export 'greeting.dart';
export 'priority.dart';
export 'reminder_type.dart';
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

    if (t == _i2.ButlerReminder) {
      return _i2.ButlerReminder.fromJson(data) as T;
    }
    if (t == _i3.Greeting) {
      return _i3.Greeting.fromJson(data) as T;
    }
    if (t == _i4.Priority) {
      return _i4.Priority.fromJson(data) as T;
    }
    if (t == _i5.ReminderType) {
      return _i5.ReminderType.fromJson(data) as T;
    }
    if (t == _i6.UserProfile) {
      return _i6.UserProfile.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ButlerReminder?>()) {
      return (data != null ? _i2.ButlerReminder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Greeting?>()) {
      return (data != null ? _i3.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Priority?>()) {
      return (data != null ? _i4.Priority.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ReminderType?>()) {
      return (data != null ? _i5.ReminderType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.UserProfile?>()) {
      return (data != null ? _i6.UserProfile.fromJson(data) : null) as T;
    }
    if (t == List<_i7.ButlerReminder>) {
      return (data as List)
              .map((e) => deserialize<_i7.ButlerReminder>(e))
              .toList()
          as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i9.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i10.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.ButlerReminder => 'ButlerReminder',
      _i3.Greeting => 'Greeting',
      _i4.Priority => 'Priority',
      _i5.ReminderType => 'ReminderType',
      _i6.UserProfile => 'UserProfile',
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
      case _i2.ButlerReminder():
        return 'ButlerReminder';
      case _i3.Greeting():
        return 'Greeting';
      case _i4.Priority():
        return 'Priority';
      case _i5.ReminderType():
        return 'ReminderType';
      case _i6.UserProfile():
        return 'UserProfile';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i9.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i10.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'ButlerReminder') {
      return deserialize<_i2.ButlerReminder>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i3.Greeting>(data['data']);
    }
    if (dataClassName == 'Priority') {
      return deserialize<_i4.Priority>(data['data']);
    }
    if (dataClassName == 'ReminderType') {
      return deserialize<_i5.ReminderType>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i6.UserProfile>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i9.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i10.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}

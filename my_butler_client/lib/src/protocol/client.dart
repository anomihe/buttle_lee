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
import 'dart:async' as _i2;
import 'package:my_butler_client/src/protocol/user_profile.dart' as _i3;
import 'package:my_butler_client/src/protocol/butler_reminder.dart' as _i4;
import 'package:my_butler_client/src/protocol/reminder_type.dart' as _i5;
import 'package:my_butler_client/src/protocol/priority.dart' as _i6;
import 'package:my_butler_client/src/protocol/greeting.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i9;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i10;
import 'protocol.dart' as _i11;

/// Endpoint for AI-powered command processing
/// {@category Endpoint}
class EndpointAi extends _i1.EndpointRef {
  EndpointAi(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ai';

  /// Process a natural language command using Gemini API
  _i2.Future<String> processCommand(String command) =>
      caller.callServerEndpoint<String>(
        'ai',
        'processCommand',
        {'command': command},
      );
}

/// Endpoint for authentication and user profile management
/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointRef {
  EndpointAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Register a new user with email, password, full name, and profile image
  _i2.Future<_i3.UserProfile?> registerWithProfile(
    String email,
    String password,
    String fullName,
    String? profileImageUrl,
  ) => caller.callServerEndpoint<_i3.UserProfile?>(
    'auth',
    'registerWithProfile',
    {
      'email': email,
      'password': password,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
    },
  );

  /// Create user profile for an authenticated user (called after Serverpod auth registration)
  _i2.Future<_i3.UserProfile?> createProfile(
    String fullName,
    String email,
    String? profileImageUrl,
  ) => caller.callServerEndpoint<_i3.UserProfile?>(
    'auth',
    'createProfile',
    {
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
    },
  );

  /// Get user profile for authenticated user
  _i2.Future<_i3.UserProfile?> getUserProfile() =>
      caller.callServerEndpoint<_i3.UserProfile?>(
        'auth',
        'getUserProfile',
        {},
      );

  /// Update user's profile image
  _i2.Future<_i3.UserProfile?> updateProfileImage(String profileImageUrl) =>
      caller.callServerEndpoint<_i3.UserProfile?>(
        'auth',
        'updateProfileImage',
        {'profileImageUrl': profileImageUrl},
      );
}

/// Endpoint for managing reminders
/// {@category Endpoint}
class EndpointReminder extends _i1.EndpointRef {
  EndpointReminder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reminder';

  /// Create a new reminder and schedule its execution
  _i2.Future<_i4.ButlerReminder?> createReminder(
    String description,
    DateTime triggerTime,
    _i5.ReminderType reminderType, {
    required _i6.Priority priority,
  }) => caller.callServerEndpoint<_i4.ButlerReminder?>(
    'reminder',
    'createReminder',
    {
      'description': description,
      'triggerTime': triggerTime,
      'reminderType': reminderType,
      'priority': priority,
    },
  );

  /// Get all reminders for the authenticated user
  _i2.Future<List<_i4.ButlerReminder>> getUserReminders() =>
      caller.callServerEndpoint<List<_i4.ButlerReminder>>(
        'reminder',
        'getUserReminders',
        {},
      );

  /// Get completed (inactive) reminders for the authenticated user
  _i2.Future<List<_i4.ButlerReminder>> getCompletedReminders() =>
      caller.callServerEndpoint<List<_i4.ButlerReminder>>(
        'reminder',
        'getCompletedReminders',
        {},
      );

  /// Get upcoming reminders within a time range
  _i2.Future<List<_i4.ButlerReminder>> getUpcomingReminders(
    DateTime startTime,
    DateTime endTime,
  ) => caller.callServerEndpoint<List<_i4.ButlerReminder>>(
    'reminder',
    'getUpcomingReminders',
    {
      'startTime': startTime,
      'endTime': endTime,
    },
  );

  /// Update a reminder
  _i2.Future<_i4.ButlerReminder?> updateReminder(
    int reminderId,
    String? description,
    DateTime? triggerTime,
    _i5.ReminderType? reminderType, {
    _i6.Priority? priority,
  }) => caller.callServerEndpoint<_i4.ButlerReminder?>(
    'reminder',
    'updateReminder',
    {
      'reminderId': reminderId,
      'description': description,
      'triggerTime': triggerTime,
      'reminderType': reminderType,
      'priority': priority,
    },
  );

  /// Delete (deactivate) a reminder
  _i2.Future<bool> deleteReminder(int reminderId) =>
      caller.callServerEndpoint<bool>(
        'reminder',
        'deleteReminder',
        {'reminderId': reminderId},
      );

  /// Snooze a reminder to a later time
  _i2.Future<_i4.ButlerReminder?> snoozeReminder(
    int reminderId,
    DateTime snoozeUntil,
  ) => caller.callServerEndpoint<_i4.ButlerReminder?>(
    'reminder',
    'snoozeReminder',
    {
      'reminderId': reminderId,
      'snoozeUntil': snoozeUntil,
    },
  );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i7.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i7.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i8.Caller(client);
    serverpod_auth_idp = _i9.Caller(client);
    serverpod_auth_core = _i10.Caller(client);
  }

  late final _i8.Caller auth;

  late final _i9.Caller serverpod_auth_idp;

  late final _i10.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i11.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    ai = EndpointAi(this);
    auth = EndpointAuth(this);
    reminder = EndpointReminder(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAi ai;

  late final EndpointAuth auth;

  late final EndpointReminder reminder;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'ai': ai,
    'auth': auth,
    'reminder': reminder,
    'greeting': greeting,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}

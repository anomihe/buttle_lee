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
import 'package:my_butler_client/src/protocol/book.dart' as _i4;
import 'package:my_butler_client/src/protocol/household.dart' as _i5;
import 'package:my_butler_client/src/protocol/butler_reminder.dart' as _i6;
import 'package:my_butler_client/src/protocol/reminder_type.dart' as _i7;
import 'package:my_butler_client/src/protocol/priority.dart' as _i8;
import 'package:my_butler_client/src/protocol/greeting.dart' as _i9;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i10;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i11;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i12;
import 'protocol.dart' as _i13;

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

/// {@category Endpoint}
class EndpointAnalytics extends _i1.EndpointRef {
  EndpointAnalytics(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'analytics';

  /// Returns a map of DayOfWeek -> Completion Count for the last 7 days
  _i2.Future<Map<String, int>> getWeeklyProductivity() =>
      caller.callServerEndpoint<Map<String, int>>(
        'analytics',
        'getWeeklyProductivity',
        {},
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

/// {@category Endpoint}
class EndpointBook extends _i1.EndpointRef {
  EndpointBook(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'book';

  _i2.Future<void> addBook(_i4.Book book) => caller.callServerEndpoint<void>(
    'book',
    'addBook',
    {'book': book},
  );

  _i2.Future<List<_i4.Book>> getBooks() =>
      caller.callServerEndpoint<List<_i4.Book>>(
        'book',
        'getBooks',
        {},
      );

  _i2.Future<void> finishBook(int id) => caller.callServerEndpoint<void>(
    'book',
    'finishBook',
    {'id': id},
  );
}

/// {@category Endpoint}
class EndpointHousehold extends _i1.EndpointRef {
  EndpointHousehold(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'household';

  /// Create a new household
  _i2.Future<_i5.Household?> createHousehold(String name) =>
      caller.callServerEndpoint<_i5.Household?>(
        'household',
        'createHousehold',
        {'name': name},
      );

  /// Join a household by code
  _i2.Future<bool> joinHousehold(String joinCode) =>
      caller.callServerEndpoint<bool>(
        'household',
        'joinHousehold',
        {'joinCode': joinCode},
      );

  /// Get members of a specific household (or user's first one)
  _i2.Future<List<_i3.UserProfile>> getHouseholdMembers({int? householdId}) =>
      caller.callServerEndpoint<List<_i3.UserProfile>>(
        'household',
        'getHouseholdMembers',
        {'householdId': householdId},
      );

  /// Get all households the user is a member of
  _i2.Future<List<_i5.Household>> getMyHouseholds() =>
      caller.callServerEndpoint<List<_i5.Household>>(
        'household',
        'getMyHouseholds',
        {},
      );

  /// Leave a specific household
  _i2.Future<bool> leaveHousehold(int householdId) =>
      caller.callServerEndpoint<bool>(
        'household',
        'leaveHousehold',
        {'householdId': householdId},
      );

  /// Delete the current household (if admin)
  _i2.Future<bool> deleteHousehold(int householdId) =>
      caller.callServerEndpoint<bool>(
        'household',
        'deleteHousehold',
        {'householdId': householdId},
      );
}

/// Endpoint for managing reminders
/// {@category Endpoint}
class EndpointReminder extends _i1.EndpointRef {
  EndpointReminder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'reminder';

  /// Create a new reminder and schedule its execution
  _i2.Future<_i6.ButlerReminder?> createReminder(
    String description,
    DateTime triggerTime,
    _i7.ReminderType reminderType, {
    required _i8.Priority priority,
  }) => caller.callServerEndpoint<_i6.ButlerReminder?>(
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
  _i2.Future<List<_i6.ButlerReminder>> getUserReminders() =>
      caller.callServerEndpoint<List<_i6.ButlerReminder>>(
        'reminder',
        'getUserReminders',
        {},
      );

  /// Get completed (inactive) reminders for the authenticated user
  _i2.Future<List<_i6.ButlerReminder>> getCompletedReminders() =>
      caller.callServerEndpoint<List<_i6.ButlerReminder>>(
        'reminder',
        'getCompletedReminders',
        {},
      );

  /// Get upcoming reminders within a time range
  _i2.Future<List<_i6.ButlerReminder>> getUpcomingReminders(
    DateTime startTime,
    DateTime endTime,
  ) => caller.callServerEndpoint<List<_i6.ButlerReminder>>(
    'reminder',
    'getUpcomingReminders',
    {
      'startTime': startTime,
      'endTime': endTime,
    },
  );

  /// Update a reminder
  _i2.Future<_i6.ButlerReminder?> updateReminder(
    int reminderId,
    String? description,
    DateTime? triggerTime,
    _i7.ReminderType? reminderType, {
    _i8.Priority? priority,
  }) => caller.callServerEndpoint<_i6.ButlerReminder?>(
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
  _i2.Future<_i6.ButlerReminder?> snoozeReminder(
    int reminderId,
    DateTime snoozeUntil,
  ) => caller.callServerEndpoint<_i6.ButlerReminder?>(
    'reminder',
    'snoozeReminder',
    {
      'reminderId': reminderId,
      'snoozeUntil': snoozeUntil,
    },
  );
}

/// {@category Endpoint}
class EndpointUserProfile extends _i1.EndpointRef {
  EndpointUserProfile(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'userProfile';

  _i2.Future<_i3.UserProfile?> getProfile() =>
      caller.callServerEndpoint<_i3.UserProfile?>(
        'userProfile',
        'getProfile',
        {},
      );

  _i2.Future<void> updateHydration(
    int goal,
    int count,
    String? date,
    bool reminder,
    String? history,
  ) => caller.callServerEndpoint<void>(
    'userProfile',
    'updateHydration',
    {
      'goal': goal,
      'count': count,
      'date': date,
      'reminder': reminder,
      'history': history,
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
  _i2.Future<_i9.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i9.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i10.Caller(client);
    serverpod_auth_idp = _i11.Caller(client);
    serverpod_auth_core = _i12.Caller(client);
  }

  late final _i10.Caller auth;

  late final _i11.Caller serverpod_auth_idp;

  late final _i12.Caller serverpod_auth_core;
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
         _i13.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    ai = EndpointAi(this);
    analytics = EndpointAnalytics(this);
    auth = EndpointAuth(this);
    book = EndpointBook(this);
    household = EndpointHousehold(this);
    reminder = EndpointReminder(this);
    userProfile = EndpointUserProfile(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointAi ai;

  late final EndpointAnalytics analytics;

  late final EndpointAuth auth;

  late final EndpointBook book;

  late final EndpointHousehold household;

  late final EndpointReminder reminder;

  late final EndpointUserProfile userProfile;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'ai': ai,
    'analytics': analytics,
    'auth': auth,
    'book': book,
    'household': household,
    'reminder': reminder,
    'userProfile': userProfile,
    'greeting': greeting,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}

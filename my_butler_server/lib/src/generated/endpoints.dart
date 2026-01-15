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
import '../endpoints/ai_endpoint.dart' as _i2;
import '../endpoints/auth_endpoint.dart' as _i3;
import '../endpoints/reminder_endpoint.dart' as _i4;
import '../greeting_endpoint.dart' as _i5;
import 'package:my_butler_server/src/generated/reminder_type.dart' as _i6;
import 'package:my_butler_server/src/generated/priority.dart' as _i7;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i8;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i9;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i10;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'ai': _i2.AiEndpoint()
        ..initialize(
          server,
          'ai',
          null,
        ),
      'auth': _i3.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'reminder': _i4.ReminderEndpoint()
        ..initialize(
          server,
          'reminder',
          null,
        ),
      'greeting': _i5.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['ai'] = _i1.EndpointConnector(
      name: 'ai',
      endpoint: endpoints['ai']!,
      methodConnectors: {
        'processCommand': _i1.MethodConnector(
          name: 'processCommand',
          params: {
            'command': _i1.ParameterDescription(
              name: 'command',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ai'] as _i2.AiEndpoint).processCommand(
                session,
                params['command'],
              ),
        ),
      },
    );
    connectors['auth'] = _i1.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'registerWithProfile': _i1.MethodConnector(
          name: 'registerWithProfile',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'profileImageUrl': _i1.ParameterDescription(
              name: 'profileImageUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i3.AuthEndpoint).registerWithProfile(
                    session,
                    params['email'],
                    params['password'],
                    params['fullName'],
                    params['profileImageUrl'],
                  ),
        ),
        'createProfile': _i1.MethodConnector(
          name: 'createProfile',
          params: {
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'profileImageUrl': _i1.ParameterDescription(
              name: 'profileImageUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).createProfile(
                session,
                params['fullName'],
                params['email'],
                params['profileImageUrl'],
              ),
        ),
        'getUserProfile': _i1.MethodConnector(
          name: 'getUserProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i3.AuthEndpoint).getUserProfile(
                session,
              ),
        ),
        'updateProfileImage': _i1.MethodConnector(
          name: 'updateProfileImage',
          params: {
            'profileImageUrl': _i1.ParameterDescription(
              name: 'profileImageUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i3.AuthEndpoint).updateProfileImage(
                    session,
                    params['profileImageUrl'],
                  ),
        ),
      },
    );
    connectors['reminder'] = _i1.EndpointConnector(
      name: 'reminder',
      endpoint: endpoints['reminder']!,
      methodConnectors: {
        'createReminder': _i1.MethodConnector(
          name: 'createReminder',
          params: {
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'triggerTime': _i1.ParameterDescription(
              name: 'triggerTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'reminderType': _i1.ParameterDescription(
              name: 'reminderType',
              type: _i1.getType<_i6.ReminderType>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i7.Priority>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .createReminder(
                    session,
                    params['description'],
                    params['triggerTime'],
                    params['reminderType'],
                    priority: params['priority'],
                  ),
        ),
        'getUserReminders': _i1.MethodConnector(
          name: 'getUserReminders',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .getUserReminders(session),
        ),
        'getCompletedReminders': _i1.MethodConnector(
          name: 'getCompletedReminders',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .getCompletedReminders(session),
        ),
        'getUpcomingReminders': _i1.MethodConnector(
          name: 'getUpcomingReminders',
          params: {
            'startTime': _i1.ParameterDescription(
              name: 'startTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'endTime': _i1.ParameterDescription(
              name: 'endTime',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .getUpcomingReminders(
                    session,
                    params['startTime'],
                    params['endTime'],
                  ),
        ),
        'updateReminder': _i1.MethodConnector(
          name: 'updateReminder',
          params: {
            'reminderId': _i1.ParameterDescription(
              name: 'reminderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'triggerTime': _i1.ParameterDescription(
              name: 'triggerTime',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'reminderType': _i1.ParameterDescription(
              name: 'reminderType',
              type: _i1.getType<_i6.ReminderType?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i7.Priority?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .updateReminder(
                    session,
                    params['reminderId'],
                    params['description'],
                    params['triggerTime'],
                    params['reminderType'],
                    priority: params['priority'],
                  ),
        ),
        'deleteReminder': _i1.MethodConnector(
          name: 'deleteReminder',
          params: {
            'reminderId': _i1.ParameterDescription(
              name: 'reminderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .deleteReminder(
                    session,
                    params['reminderId'],
                  ),
        ),
        'snoozeReminder': _i1.MethodConnector(
          name: 'snoozeReminder',
          params: {
            'reminderId': _i1.ParameterDescription(
              name: 'reminderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'snoozeUntil': _i1.ParameterDescription(
              name: 'snoozeUntil',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i4.ReminderEndpoint)
                  .snoozeReminder(
                    session,
                    params['reminderId'],
                    params['snoozeUntil'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i5.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i8.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i9.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i10.Endpoints()
      ..initializeEndpoints(server);
  }
}

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
import '../endpoints/analytics_endpoint.dart' as _i3;
import '../endpoints/auth_endpoint.dart' as _i4;
import '../endpoints/book_endpoint.dart' as _i5;
import '../endpoints/household_endpoint.dart' as _i6;
import '../endpoints/reminder_endpoint.dart' as _i7;
import '../endpoints/user_profile_endpoint.dart' as _i8;
import '../greeting_endpoint.dart' as _i9;
import 'package:my_butler_server/src/generated/book.dart' as _i10;
import 'package:my_butler_server/src/generated/reminder_type.dart' as _i11;
import 'package:my_butler_server/src/generated/priority.dart' as _i12;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i13;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i14;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i15;
import 'package:my_butler_server/src/generated/future_calls.dart' as _i16;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

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
      'analytics': _i3.AnalyticsEndpoint()
        ..initialize(
          server,
          'analytics',
          null,
        ),
      'auth': _i4.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'book': _i5.BookEndpoint()
        ..initialize(
          server,
          'book',
          null,
        ),
      'household': _i6.HouseholdEndpoint()
        ..initialize(
          server,
          'household',
          null,
        ),
      'reminder': _i7.ReminderEndpoint()
        ..initialize(
          server,
          'reminder',
          null,
        ),
      'userProfile': _i8.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
      'greeting': _i9.GreetingEndpoint()
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
    connectors['analytics'] = _i1.EndpointConnector(
      name: 'analytics',
      endpoint: endpoints['analytics']!,
      methodConnectors: {
        'getWeeklyProductivity': _i1.MethodConnector(
          name: 'getWeeklyProductivity',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['analytics'] as _i3.AnalyticsEndpoint)
                  .getWeeklyProductivity(session),
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
                  (endpoints['auth'] as _i4.AuthEndpoint).registerWithProfile(
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
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).createProfile(
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
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).getUserProfile(
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
                  (endpoints['auth'] as _i4.AuthEndpoint).updateProfileImage(
                    session,
                    params['profileImageUrl'],
                  ),
        ),
        'checkEmailExists': _i1.MethodConnector(
          name: 'checkEmailExists',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['auth'] as _i4.AuthEndpoint).checkEmailExists(
                    session,
                    params['email'],
                  ),
        ),
        'resetPassword': _i1.MethodConnector(
          name: 'resetPassword',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i4.AuthEndpoint).resetPassword(
                session,
                params['email'],
                params['newPassword'],
              ),
        ),
      },
    );
    connectors['book'] = _i1.EndpointConnector(
      name: 'book',
      endpoint: endpoints['book']!,
      methodConnectors: {
        'addBook': _i1.MethodConnector(
          name: 'addBook',
          params: {
            'book': _i1.ParameterDescription(
              name: 'book',
              type: _i1.getType<_i10.Book>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _i5.BookEndpoint).addBook(
                session,
                params['book'],
              ),
        ),
        'addBookWithChapters': _i1.MethodConnector(
          name: 'addBookWithChapters',
          params: {
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'author': _i1.ParameterDescription(
              name: 'author',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'chapterTitles': _i1.ParameterDescription(
              name: 'chapterTitles',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['book'] as _i5.BookEndpoint).addBookWithChapters(
                    session,
                    params['title'],
                    params['author'],
                    params['chapterTitles'],
                  ),
        ),
        'getBooks': _i1.MethodConnector(
          name: 'getBooks',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['book'] as _i5.BookEndpoint).getBooks(session),
        ),
        'getChapters': _i1.MethodConnector(
          name: 'getChapters',
          params: {
            'bookId': _i1.ParameterDescription(
              name: 'bookId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _i5.BookEndpoint).getChapters(
                session,
                params['bookId'],
              ),
        ),
        'finishBook': _i1.MethodConnector(
          name: 'finishBook',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _i5.BookEndpoint).finishBook(
                session,
                params['id'],
              ),
        ),
        'completeBook': _i1.MethodConnector(
          name: 'completeBook',
          params: {
            'bookId': _i1.ParameterDescription(
              name: 'bookId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lessonsLearned': _i1.ParameterDescription(
              name: 'lessonsLearned',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _i5.BookEndpoint).completeBook(
                session,
                params['bookId'],
                params['lessonsLearned'],
              ),
        ),
        'updateLessons': _i1.MethodConnector(
          name: 'updateLessons',
          params: {
            'bookId': _i1.ParameterDescription(
              name: 'bookId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lessonsLearned': _i1.ParameterDescription(
              name: 'lessonsLearned',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _i5.BookEndpoint).updateLessons(
                session,
                params['bookId'],
                params['lessonsLearned'],
              ),
        ),
        'completeChapter': _i1.MethodConnector(
          name: 'completeChapter',
          params: {
            'chapterId': _i1.ParameterDescription(
              name: 'chapterId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['book'] as _i5.BookEndpoint).completeChapter(
                    session,
                    params['chapterId'],
                  ),
        ),
        'uncompleteChapter': _i1.MethodConnector(
          name: 'uncompleteChapter',
          params: {
            'chapterId': _i1.ParameterDescription(
              name: 'chapterId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['book'] as _i5.BookEndpoint).uncompleteChapter(
                    session,
                    params['chapterId'],
                  ),
        ),
      },
    );
    connectors['household'] = _i1.EndpointConnector(
      name: 'household',
      endpoint: endpoints['household']!,
      methodConnectors: {
        'createHousehold': _i1.MethodConnector(
          name: 'createHousehold',
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
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .createHousehold(
                    session,
                    params['name'],
                  ),
        ),
        'joinHousehold': _i1.MethodConnector(
          name: 'joinHousehold',
          params: {
            'joinCode': _i1.ParameterDescription(
              name: 'joinCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .joinHousehold(
                    session,
                    params['joinCode'],
                  ),
        ),
        'getHouseholdMembers': _i1.MethodConnector(
          name: 'getHouseholdMembers',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .getHouseholdMembers(
                    session,
                    householdId: params['householdId'],
                  ),
        ),
        'getMyHouseholds': _i1.MethodConnector(
          name: 'getMyHouseholds',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .getMyHouseholds(session),
        ),
        'leaveHousehold': _i1.MethodConnector(
          name: 'leaveHousehold',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .leaveHousehold(
                    session,
                    params['householdId'],
                  ),
        ),
        'deleteHousehold': _i1.MethodConnector(
          name: 'deleteHousehold',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .deleteHousehold(
                    session,
                    params['householdId'],
                  ),
        ),
        'startFocusSession': _i1.MethodConnector(
          name: 'startFocusSession',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'durationMinutes': _i1.ParameterDescription(
              name: 'durationMinutes',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .startFocusSession(
                    session,
                    params['householdId'],
                    params['durationMinutes'],
                  ),
        ),
        'stopFocusSession': _i1.MethodConnector(
          name: 'stopFocusSession',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .stopFocusSession(
                    session,
                    params['householdId'],
                  ),
        ),
        'shareRoutine': _i1.MethodConnector(
          name: 'shareRoutine',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'tasks': _i1.ParameterDescription(
              name: 'tasks',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .shareRoutine(
                    session,
                    params['householdId'],
                    params['name'],
                    params['tasks'],
                  ),
        ),
        'getSharedRoutines': _i1.MethodConnector(
          name: 'getSharedRoutines',
          params: {
            'householdId': _i1.ParameterDescription(
              name: 'householdId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['household'] as _i6.HouseholdEndpoint)
                  .getSharedRoutines(
                    session,
                    params['householdId'],
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
              type: _i1.getType<_i11.ReminderType>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i12.Priority>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
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
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
                  .getUserReminders(session),
        ),
        'getCompletedReminders': _i1.MethodConnector(
          name: 'getCompletedReminders',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
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
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
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
              type: _i1.getType<_i11.ReminderType?>(),
              nullable: true,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<_i12.Priority?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
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
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
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
              ) async => (endpoints['reminder'] as _i7.ReminderEndpoint)
                  .snoozeReminder(
                    session,
                    params['reminderId'],
                    params['snoozeUntil'],
                  ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'getProfile': _i1.MethodConnector(
          name: 'getProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .getProfile(session),
        ),
        'updateHydration': _i1.MethodConnector(
          name: 'updateHydration',
          params: {
            'goal': _i1.ParameterDescription(
              name: 'goal',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'count': _i1.ParameterDescription(
              name: 'count',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'date': _i1.ParameterDescription(
              name: 'date',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'reminder': _i1.ParameterDescription(
              name: 'reminder',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'history': _i1.ParameterDescription(
              name: 'history',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'interval': _i1.ParameterDescription(
              name: 'interval',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .updateHydration(
                    session,
                    params['goal'],
                    params['count'],
                    params['date'],
                    params['reminder'],
                    params['history'],
                    params['interval'],
                  ),
        ),
        'updateRoutineSettings': _i1.MethodConnector(
          name: 'updateRoutineSettings',
          params: {
            'journalReminder': _i1.ParameterDescription(
              name: 'journalReminder',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'journalInterval': _i1.ParameterDescription(
              name: 'journalInterval',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'bookReminder': _i1.ParameterDescription(
              name: 'bookReminder',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'bookInterval': _i1.ParameterDescription(
              name: 'bookInterval',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'focusModeDuration': _i1.ParameterDescription(
              name: 'focusModeDuration',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .updateRoutineSettings(
                    session,
                    params['journalReminder'],
                    params['journalInterval'],
                    params['bookReminder'],
                    params['bookInterval'],
                    params['focusModeDuration'],
                  ),
        ),
        'updateFocusStats': _i1.MethodConnector(
          name: 'updateFocusStats',
          params: {
            'completed': _i1.ParameterDescription(
              name: 'completed',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'givenUp': _i1.ParameterDescription(
              name: 'givenUp',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .updateFocusStats(
                    session,
                    params['completed'],
                    params['givenUp'],
                  ),
        ),
        'incrementXp': _i1.MethodConnector(
          name: 'incrementXp',
          params: {
            'amount': _i1.ParameterDescription(
              name: 'amount',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i8.UserProfileEndpoint)
                  .incrementXp(
                    session,
                    params['amount'],
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
              ) async => (endpoints['greeting'] as _i9.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth'] = _i13.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i14.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i15.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _i1.FutureCallDispatch? get futureCalls {
    return _i16.FutureCalls();
  }
}

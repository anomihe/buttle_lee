import 'package:my_butler_server/src/birthday_reminder.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

import 'package:my_butler_server/src/web/routes/root.dart';

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';
import 'src/future_calls/reminder_execution_call.dart';

// This is the starting point of your Serverpod server. In most cases, you will
// only need to make additions to this file if you add future calls,  are
// configuring Relic (Serverpod's web-server), or need custom setup work.

void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  // Configure Serverpod Auth (IDP)
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      // For development, print the code to console
      session.log('Validation code for $email: $validationCode',
          level: LogLevel.info);
      return true;
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      session.log('Password reset code for ${userInfo.email}: $validationCode',
          level: LogLevel.info);
      return true;
    },
    onUserCreated: (session, userInfo) async {
      session.log('User created: ${userInfo.id}', level: LogLevel.info);
    },
  ));

  // Setup a default page at the web root.
  pod.webServer.addRoute(RouteRoot(), '/');
  pod.webServer.addRoute(RouteRoot(), '/index.html');
  // Serve all files in the /static directory.
  // Note: RouteStaticDirectory is abstract in Serverpod 3.x
  // TODO: Implement custom static file serving if needed
  // pod.webServer.addRoute(
  //   RouteStaticDirectory(serverDirectory: 'static', basePath: '/'),
  //   '/*',
  // );

  // Start the server.
  await pod.start();

  // After starting the server, you can register future calls. Future calls are
  // tasks that need to happen in the future, or independently of the request/
  // response cycle. For example, you can use future calls to send emails, or to
  // schedule tasks to be executed at a later time. Future calls are executed in
  // the background. Their schedule is persisted to the database, so you will
  // not lose them if the server is restarted.

  pod.registerFutureCall(
    BirthdayReminder(),
    FutureCallNames.birthdayReminder.name,
  );

  // Register reminder execution future call
  pod.registerFutureCall(
    ReminderExecutionCall(),
    FutureCallNames.reminderExecution.name,
  );

  // You can schedule future calls for a later time during startup. But you can
  // also schedule them in any endpoint or webroute through the session object.
  // there is also [futureCallAtTime] if you want to schedule a future call at a
  // specific time.
  await pod.futureCallWithDelay(
    FutureCallNames.birthdayReminder.name,
    Greeting(
      message: 'Hello!',
      author: 'Serverpod Server',
      timestamp: DateTime.now(),
    ),
    Duration(seconds: 5),
  );
}

/// Names of all future calls in the server.
///
/// This is better than using a string literal, as it will reduce the risk of
/// typos and make it easier to refactor the code.
enum FutureCallNames { birthdayReminder, reminderExecution }

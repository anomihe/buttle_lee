import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:serverpod/serverpod.dart';

class FcmService {
  final Session session;

  FcmService(this.session);

  /// Send a push notification to a specific device (token) or topic.
  ///
  /// [target] can be a device token or a topic name (e.g., 'all').
  Future<bool> sendNotification({
    required String target,
    required String title,
    required String body,
    Map<String, String>? data,
  }) async {
    try {
      final serviceAccountJson =
          session.serverpod.getPassword('firebaseServiceAccount');
      if (serviceAccountJson == null) {
        session.log('Firebase Service Account JSON not found in passwords.',
            level: LogLevel.warning);
        return false;
      }

      final serviceAccountMap =
          jsonDecode(serviceAccountJson) as Map<String, dynamic>;
      final credentials = ServiceAccountCredentials.fromJson(serviceAccountMap);
      final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      final client = await clientViaServiceAccount(credentials, scopes);
      final projectId = serviceAccountMap['project_id'];

      final url =
          'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';

      final message = {
        'message': {
          'token': target, // Or 'topic': target for topics
          'notification': {
            'title': title,
            'body': body,
          },
          'data': data ?? {},
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            }
          },
          'apns': {
            'payload': {
              'aps': {
                'sound': 'default',
                'content-available': 1,
              },
            },
          },
        }
      };

      // Handle topic vs token
      if (!target.contains(':') && target.length < 50) {
        // Naive check for topic vs token
        // It's likely a topic if it's short and simple, but FCM tokens are long strings.
        // Actually, let's assume 'target' is a token unless specified.
        // If we want to support topics, we might need a separate arg or heuristic.
        // For now, let's support TOKEN based sending as that's 1:1.
        // If target is 'all', we use topic.
        if (target == 'all') {
          (message['message'] as Map).remove('token');
          (message['message'] as Map)['topic'] = 'all';
        }
      }

      final response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(message),
      );

      client.close();

      if (response.statusCode == 200) {
        // session.log('FCM Notification sent successfully to $target');
        return true;
      } else {
        session.log('Failed to send FCM notification: ${response.body}',
            level: LogLevel.error);
        return false;
      }
    } catch (e, stackTrace) {
      session.log('Error sending FCM notification: $e',
          level: LogLevel.error, stackTrace: stackTrace);
      return false;
    }
  }
}

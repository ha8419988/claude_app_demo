import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl
        ?.createNotificationChannel(const AndroidNotificationChannel(
      'messages',
      'Tin nhắn',
      importance: Importance.high,
    ));

    await androidImpl?.requestNotificationsPermission();
  }

  Future<void> showMessage(String senderName, String text) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      senderName,
      text,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'messages',
          'Tin nhắn',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}

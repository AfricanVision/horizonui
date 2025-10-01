import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationDetails> _notificationDetails() async {


    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'Spiro Application',
      'Spiro',
      groupKey: 'nya.spiro.horizon',
      color: Color(0xFFB84841),
      channelDescription: 'The official spiro partner application notification local engine.',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon',
      playSound: true,
    );

    DarwinNotificationDetails iosNotificationDetails = const DarwinNotificationDetails(
        threadIdentifier: "spiroThreader02",
    );


    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);

    return platformChannelSpecifics;
  }



  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final platformChannelSpecifics = await _notificationDetails();
    await _localNotifications.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  void cancelAllNotifications() => _localNotifications.cancelAll();

}

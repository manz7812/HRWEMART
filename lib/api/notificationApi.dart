import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationApi{
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future notificationDetails() async{
    return  const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: "@mipmap/ic_launcher_foreground",
        color: Colors.deepPurpleAccent,
        // sound: RawResourceAndroidNotificationSound('')
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings("@mipmap/ic_launcher_foreground");
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android,iOS: iOS);

    final details = await _notification.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      onNotification.add(details.payload);
    }
    await _notification.initialize(
        settings,
        onSelectNotification: (payload) async {
          onNotification.add(payload);
    });

  }

  static Future showNotification({
    required int id,
    String?  title,
    String?  body,
    String?  playload,
  }) async => _notification.show(
      id,
      title,
      body,
      await notificationDetails(),
    payload: playload,
  );
}
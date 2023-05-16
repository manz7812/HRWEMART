import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //initilize

  Future initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher_foreground");

    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();

    final InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //Instant Notifications
  Future instantNofitication() async {
    var android = const AndroidNotificationDetails("id", "channel", channelDescription: "description");

    var ios = IOSNotificationDetails();

    var platform = new NotificationDetails(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo instant notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Image notification
  Future imageNotification() async {
    var bigPicture = const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher_foreground"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher_foreground"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel",
        channelDescription: "description",
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        icon: "@mipmap/ic_launcher_foreground",
        styleInformation: bigPicture);

    var platform =  NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Image notification", "Tap to do something", platform,
        payload: "Welcome to demo app");
  }

  //Stylish Notification
  Future stylishNotification() async {
    var android = const AndroidNotificationDetails("id", "channel", channelDescription: "description",
        color: Colors.deepOrange,
        enableLights: true,
        enableVibration: true,
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        styleInformation: MediaStyleInformation(
            htmlFormatContent: true, htmlFormatTitle: true));

    var platform = new NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.show(
        0, "Demo Stylish notification", "Tap to do something", platform);
  }

  //Sheduled Notification

  Future sheduledNotification() async {
    var interval = RepeatInterval.everyMinute;
    var bigPicture = const BigPictureStyleInformation(
        DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        largeIcon: DrawableResourceAndroidBitmap("@mipmap/ic_launcher"),
        contentTitle: "Demo image notification",
        summaryText: "This is some text",
        htmlFormatContent: true,
        htmlFormatContentTitle: true);

    var android = AndroidNotificationDetails("id", "channel", channelDescription: "description",
        styleInformation: bigPicture);

    var platform =  NotificationDetails(android: android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        "Demo Sheduled notification",
        "Tap to do something",
        interval,
        platform);
  }

  //Cancel notification

  Future cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin plugin;

  NotificationService() :
      plugin = FlutterLocalNotificationsPlugin() {
        plugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),));
  }

  Future<void> showNotification(
      {required String title, required String msg, bool vibration = false, int id = 0, String? sound}) async {
    // Define vibration pattern
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    AndroidNotificationDetails androidNotificationDetails;

    final channelName;
    final Importance importance;
    AndroidNotificationSound? notificationSound;
    // If sound == siren, the message represents an emergency.
    if (sound?.toLowerCase() == "siren") {
      channelName = 'PALAEMON Emergency Messages';
      notificationSound = RawResourceAndroidNotificationSound(sound!.toLowerCase());
    } else {
      channelName = 'PALAEMON Crew Messages';
    }

    androidNotificationDetails = AndroidNotificationDetails(
        channelName, channelName,
        importance: Importance.max,
        priority: Priority.high,
        vibrationPattern: vibration ? vibrationPattern : null,
        sound: notificationSound,
        playSound: notificationSound != null,
        enableVibration: vibration);

    var notificationDetails = NotificationDetails(
        android: androidNotificationDetails);

    try {
      await plugin.show(id, title, msg, notificationDetails);
    } catch (ex) {
      print(ex);
    }
  }
}
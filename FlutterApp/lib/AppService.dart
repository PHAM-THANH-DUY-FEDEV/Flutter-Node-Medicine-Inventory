// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medication_management_app/main.dart';

class AppService {
  static getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }

  static bool checkWeb() {
    if (kIsWeb) {
      return true; // proxy để vượt CORS
    }
    return false;
  }
}

class NotificationService {
  static Future<void> showNotification(
    int id,
    String title,
    String content,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'Thông báo',
          channelDescription: '',
          importance: Importance.max,
          priority: Priority.high,
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_noti');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      content,
      notificationDetails,
    );
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) {
      print(payload);
    });
  }

  static Future<String> _getImageFilePathFromAssets(String asset) async {
    final byteData = await rootBundle.load(asset);

    final file = File(
        '${(await getTemporaryDirectory()).path}/${asset.split('/').last}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }


  static Future<String?> _getImageFilePathFromNetwork(String url,) async {

    try {
      Response response = await Dio().get(
        url,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      final file = File(
          '${(await getTemporaryDirectory()).path}/abc.png');
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file.path;
    } catch (e) {
     return null;
    }
  }


  static void showNotificationOnForeground({RemoteMessage? message}) async {
    String filePath =
        await _getImageFilePathFromAssets("assets/image/logo_notification.png");

    var style = BigPictureStyleInformation(
        FilePathAndroidBitmap(filePath),
        largeIcon: FilePathAndroidBitmap(filePath),
    );

    var notificationDetail = NotificationDetails(
        android: AndroidNotificationDetails(
            "app.spayindia.com",
            "spay_notification",
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            styleInformation: style));

    _notificationsPlugin.show(
      DateTime.now().microsecond,
      message?.notification?.title,
      message?.notification?.body,
      notificationDetail,
      payload: "Welcome to Smart Bazaar",
    );
  }
}

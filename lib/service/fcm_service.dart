import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:spayindia/util/app_util.dart';

class FcmService {
  FcmService._();





  static void init() {
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

  }

  static onMessage(RemoteMessage message) {
    AppUtil.logger("onMessage : ${message.notification?.title}");
  }

  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    AppUtil.logger("onBackgroundHandler : ${message.notification?.title}");
  }

  static onMessageOpenedApp(RemoteMessage message) {

    AppUtil.logger("onMessageOpenedApp");
  }
}

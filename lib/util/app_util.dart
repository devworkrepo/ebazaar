import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'dart:developer';

class AppUtil {
  static logger(value) {
    if (!kReleaseMode) {
      log("AppLog : "+value.toString());
      //print("AppLog : ${}");
    }
  }

  static Future<String> getDeviceID() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId ;
    }
  }

  static Future<String> serialNumber() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.hardware;
    }
  }

  static Future<String> modelName() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.name;
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.brand;
    }
  }

  static Future<Map<String, dynamic>> parseJsonFromAssets(
      String fileName) async {
    await Future.delayed(const Duration(seconds: 2));
    return rootBundle
        .loadString("assets/json/" + fileName + ".json")
        .then((jsonStr) => jsonDecode(jsonStr));
  }

  static void captureAndShare(
      {required ScreenshotController screenshotController,
      required String amount,
      required String type}) async {
    var image = await screenshotController.capture();

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imageFile = File("${directory.path}/spayindia.png");

    final text = "$type for Rs. $amount";

    imageFile.writeAsBytesSync(image);
    await Share.shareFiles([imageFile.path], text: text);

  }
}

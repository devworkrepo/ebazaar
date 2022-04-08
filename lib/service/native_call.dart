import 'dart:async';

import 'package:flutter/services.dart';

class NativeCall {
  static const _methodChannelName = "app.spayindia.com";
  static const _methodChannel = MethodChannel(_methodChannelName);
  static const _aepsServiceMethodName = "launch_aeps_service";
  static const _matmServiceMethodName = "launch_matm_service";
  static const _rdServiceSerialNumber = "rd_service_serial_number";

  static Future<String> launchAepsService(Map<String, dynamic> data) async {
    final String result =
        await _methodChannel.invokeMethod(_aepsServiceMethodName, data);
    return result;
  }

  static Future<Map<dynamic,dynamic>> launchMatmService(Map<String, dynamic> data) async {
    return await _methodChannel.invokeMethod(_matmServiceMethodName, data);
  }

  static Future<String> getRdSerialNumber(String data) async {
    return await _methodChannel.invokeMethod(_rdServiceSerialNumber, {
      "pidData" : data
    });
  }
}

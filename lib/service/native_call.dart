import 'dart:async';

import 'package:flutter/services.dart';
import 'package:spayindia/util/app_util.dart';

class NativeCall {
  static const _methodChannelName = "app.spayindia.com";
  static const _methodChannel = MethodChannel(_methodChannelName);
  static const _aepsServiceMethodName = "launch_aeps_service";
  static const _matmServiceMethodName = "launch_matm_service";
  static const _rdServiceSerialNumber = "rd_service_serial_number";
  static const _rootCheckerService = "root_checker_service";
  static const _credoPayService = "credo_pay_service";

  static Future<String> launchAepsService(Map<String, dynamic> data) async {
    final String result = await _methodChannel.invokeMethod(_aepsServiceMethodName, data);
    return result;
  }

  static Future<Map<dynamic,dynamic>> launchMatmService(Map<String, dynamic> data) async {
    return await _methodChannel.invokeMethod(_matmServiceMethodName, data);
  }

  static Future<String> getRdSerialNumber(String data) async {
    var resultData = await _methodChannel.invokeMethod(_rdServiceSerialNumber, {
      "pidData" : data
    });
    return resultData;

  }


  static Future<Map<dynamic,dynamic>> credoPayService(Map<String,dynamic> data) async {
    var resultData = await _methodChannel.invokeMethod(_credoPayService, data);

    AppUtil.logger("credoPay Native call response : $resultData");
    return resultData;

  }

  static Future<bool> isDeviceRooted() async {
    var resultData = await _methodChannel.invokeMethod(_rootCheckerService);
    return resultData ?? false;
  }



}

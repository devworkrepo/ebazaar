import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';

class AppSettingController extends GetxController{
  AppPreference appPreference = Get.find();


  var isBiometricLoginEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    isBiometricLoginEnable.value = appPreference.isBiometricAuthentication;
  }

  setBiometricLogin(bool value){
    isBiometricLoginEnable.value = value;
    appPreference.setBiometricAuthentication(value);
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/auth_repo.dart';
import 'package:spayindia/data/repo_impl/auth_impl.dart';
import 'package:spayindia/model/user/login.dart';
import 'package:spayindia/page/auth/login/login_tac_dialog.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/security/app_config.dart';
import 'package:spayindia/util/security/encription.dart';

import '../../../service/native_call.dart';
import '../../../util/api/exception.dart';
import '../../../util/app_constant.dart';

class LoginController extends GetxController {
  AuthRepo authRepo = Get.find<AuthRepoImpl>();
  AppPreference appPreference = Get.find();

  var loginFormKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var passwordController = TextEditingController();

  var isLoginCheck = false.obs;

  @override
  void onInit() {
    super.onInit();
    appPreference.setIsTransactionApi(false);
    appPreference.setSessionKey("na");
    isLoginCheck.value = appPreference.isLoginCheck;

    if(appPreference.isLoginCheck){
      mobileController.text = appPreference.mobileNumber;
      passwordController.text = appPreference.password;
    }
   /* if(kDebugMode){
      mobileController.text = "7982607742";
      passwordController.text = "Akash@123";
    }*/


    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {


       if(!appPreference.isLoginBondAccepted){
         Get.dialog(LoginTermAndConditionDialog(onAccept: () async{
           await appPreference.setIsLoginBondAccepted(true);
         }, onReject: () async{
           await  appPreference.setIsLoginBondAccepted(false);
         }));

     }
    });
  }


  login() async {
    var isValidate = loginFormKey.currentState?.validate();
    if (!isValidate!) return;


    if(!appPreference.isLoginBondAccepted){
      Get.dialog(LoginTermAndConditionDialog(onAccept: () async{
        await appPreference.setIsLoginBondAccepted(true);
        login();
      }, onReject: () async{
        await  appPreference.setIsLoginBondAccepted(false);
      }));
      return;
    }


    StatusDialog.progress(title: "Login");

    final mobileNumber = mobileController.text.toString();
    final password = Encryption.aesEncrypt(passwordController.text.toString());

    try {
      final loginData = {
        "mobileno": mobileNumber,
        "password": password,
        "dvckey": await AppUtil.getDeviceID(),
        "appid": AppConfig.apiCode,
        "accesskey": AppConfig.apiKey
      };

      if (kReleaseMode && AppConstant.baseUrl == AppConstant.uatBaseUrl) {
        if (mobileController.text != "7982607742") {
          throw TestingServerError();
        }
      }


      AppUtil.logger(loginData.toString());

      LoginResponse login = await authRepo.agentLogin(loginData);
      Get.back();

      if (login.code == 1 ) {

       Get.toNamed(AppRoute.loginOtpPage, parameters: {
          "mobileNumber": mobileController.text.toString(),
          "isLoginChecked" : isLoginCheck.value.toString(),
          "password" : passwordController.text.toString(),
          "loginData": json.encode(login.toJson())
        });
      } else {
        StatusDialog.failure(title: login.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}

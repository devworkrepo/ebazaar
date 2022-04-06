import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/app_util.dart';

class AepsEKycController extends GetxController {
  var formOneKey = GlobalKey<FormState>();
  var deviceSerialController = TextEditingController();
  var otpController = TextEditingController();
  var actionTypeObs = EKycActionType.requestOtp.obs;

  AepsRepo repo  = Get.find<AepsRepoImpl>();

  @override
  void dispose() {
    deviceSerialController.dispose();
    super.dispose();
  }

  String getButtonText() {
    switch (actionTypeObs.value) {
      case EKycActionType.requestOtp:
        return "Request Otp";
      case EKycActionType.verifyOtp:
        return "Verify Otp";
      case EKycActionType.authKyc:
        return "Complete Kyc";
    }
  }

  void onSubmit() async {
    if (!formOneKey.currentState!.validate()) return;

    switch (actionTypeObs.value) {
      case EKycActionType.requestOtp:
        _requestKycOtp();
        break;
    }
  }

  _requestKycOtp() async{
    try{

      StatusDialog.progress(title: "Requesting Otp..");

      var response = await repo.eKycRequestOtp({
        "ipAddress" : await Ipify.ipv4(),
        "deviceSerialNumber" : deviceSerialController.text.toString()
      });

      Get.back();

      if(response.code == 1){
        actionTypeObs.value = EKycActionType.verifyOtp;
      }
      else{
        StatusDialog.failure(title: response.message);
      }




    }catch(e){
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}

enum EKycActionType { requestOtp, verifyOtp, authKyc }

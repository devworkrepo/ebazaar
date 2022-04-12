import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/otp_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/util/security/encription.dart';

import '../../exception_page.dart';

class ChangePinController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var newMPinController = TextEditingController();
  var confirmMPinController = TextEditingController();
  var otpController = TextEditingController();

  var changePinActionTypeObs = ChangePinActionType.requestOtp.obs;

  var formKey = GlobalKey<FormState>();

  requestOtp() async {

    try {
      StatusDialog.progress(title: "Generating Otp");
      var response = await repo.requestOtp({"otptype" : "mpin"});
      Get.back();
      if (response.code == 1) {
        changePinActionTypeObs.value = ChangePinActionType.changePin;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  verifyOtp() async {
    try {
      StatusDialog.progress(title: "Verifying");
      var response = await repo.changePin({
        "newpin": Encryption.aesEncrypt(newMPinController.text),
        "otp": otpController.text,
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}

enum ChangePinActionType{
  requestOtp, changePin
}
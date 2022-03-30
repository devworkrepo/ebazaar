import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/otp_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';

import '../../exception_page.dart';

class ChangePinController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var newMPinController = TextEditingController();
  var confirmMPinController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  requestOtp() async {
    //todo remove and implement change pin api
    showFailureSnackbar(title: "Coming soon", message: "work on progress");
    return;
    try {
      StatusDialog.progress(title: "Generating Otp");
      var response = await repo.requestOtpForGenerateMPin();
      Get.back();
      if (response.status == 1) {
        Get.dialog(OtpDialogWidget(
          onSubmit: (String otp) {
            verifyOtp(otp);
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  verifyOtp(String otp) async {
    try {
      StatusDialog.progress(title: "Verifying");
      var response = await repo.verifyGenerateMPin({
        "txn_pin": newMPinController.text.toString(),
        "confirm_txn_pin": confirmMPinController.text.toString(),
        "otp": otp,
      });
      Get.back();
      if (response.status == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back());
      } else {
        StatusDialog.failure(title: response.message).then((value){
          Get.dialog(OtpDialogWidget(
            onSubmit: (String otp) {
              verifyOtp(otp);
            },
          ));
        });
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}

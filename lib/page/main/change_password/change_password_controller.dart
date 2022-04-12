import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/security/encription.dart';

import '../../exception_page.dart';

class ChangePasswordController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var otpController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  var changePasswordActionTypeObs = ChangePasswordActionType.requestOtp.obs;
  AppPreference appPreference = Get.find();

  requestOtp() async {
    try {
      StatusDialog.progress(title: "Generating Otp");
      var response = await repo.requestOtp({"otptype": "password"});
      Get.back();
      if (response.code == 1) {
        showSuccessSnackbar(title: "Otp Sent", message: response.message);
        changePasswordActionTypeObs.value =
            ChangePasswordActionType.changePassword;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  changePassword() async {
    try {
      StatusDialog.progress(title: "Progressing");
      var response = await repo.changePassword({
        "currentpassword": Encryption.aesEncrypt(oldPasswordController.text),
        "newpassword": Encryption.aesEncrypt(newPasswordController.text),
        "otp": otpController.text.toString(),
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          appPreference.logout();
          Get.offAllNamed(RouteName.loginPage);
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}

enum ChangePasswordActionType { requestOtp, changePassword }

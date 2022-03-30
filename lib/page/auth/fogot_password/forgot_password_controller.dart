import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/auth_repo.dart';
import 'package:spayindia/data/repo_impl/auth_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/login.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';

class ForgotPasswordController extends GetxController with LocationHelperMixin {
  AuthRepo authRepo = Get.find<AuthRepoImpl>();
  AppPreference appPreference = Get.find();

  var forgotPasswordFormKey = GlobalKey<FormState>();

  var mobileController = TextEditingController();
  var otpController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var forgotPasswordRequestType = ForgotPasswordRequestType.requestPassword.obs;
  var message = "".obs;
  var forgotPasswordToken = "";

  var token = "";

  var resendButtonVisibilityObs = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobileController.text = Get.arguments as String;
    validateLocation(progress: false);
  }

  onSubmit() {

    var isValidate = forgotPasswordFormKey.currentState!.validate();
    if (!isValidate) return;

    if(forgotPasswordRequestType.value == ForgotPasswordRequestType.requestPassword){

      requestForgotPasswordOtp();
    }
    else {

      verifyForgotPasswordOtp();
    }

  }

  requestForgotPasswordOtp() async {

    StatusDialog.progress();

    ForgotPasswordResponse response = await authRepo
        .forgotPasswordRequestOtp({"mobile": mobileController.text.toString()});

    Get.back();

    if (response.status == 1) {
      if(response.token != null){
        forgotPasswordToken = response.token! ;
      }
      forgotPasswordRequestType.value = ForgotPasswordRequestType.verifyOtp;
      message.value = response.message;
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  verifyForgotPasswordOtp() async {

    if (!(await validateLocation())) return;
    StatusDialog.progress();

    CommonResponse response = await authRepo.forgotPasswordVerifyOtp({
      "mobile": mobileController.text.toString(),
      "password": newPasswordController.text.toString(),
      "password_confirmation": confirmPasswordController.text.toString(),
      "token": forgotPasswordToken,
      "latitude" : position!.latitude.toString(),
      "longitude" : position!.longitude.toString(),
      "otp": otpController.text.toString(),
    });

    Get.back();

    if (response.status == "1") {
      StatusDialog.success(title: response.message).then((value) => Get.back());
    } else {
      message.value = "";
      StatusDialog.failure(title: response.message);
    }
  }

  resendOtp() async {
    try{

      StatusDialog.progress();

      var response = await authRepo.forgotPasswordResendOtp({
        "token": forgotPasswordToken,
        "mobile" : mobileController.text.toString()
      });

      Get.back();

      if(response.status == 1){
        showSuccessSnackbar(title: "Resent Otp", message: response.message);
        resendButtonVisibilityObs.value = false;
      }
      else {
        showFailureSnackbar(title: "Resent Otp", message: response.message);
      }

    }catch (e){
      Get.back();
      Get.to(()=> ExceptionPage(error: e));
    }
  }


}

enum ForgotPasswordRequestType { requestPassword, verifyOtp }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../../widget/common.dart';
import '../../../model/dmt/sender_kyc.dart';

class SenderKycController extends GetxController with TransactionHelperMixin {
  DmtRepo repo = Get.find<DmtRepoImpl>();
  String mobileNumber = Get.arguments["mobile_number"];
  DmtType dmtType = Get.arguments["dmt_type"];

  var aadhaarController = TextEditingController();
  var captchaController = TextEditingController();
  var initialFormKey = GlobalKey<FormState>();


  var finalFormKey = GlobalKey<FormState>();
  var otpController = TextEditingController();

  var captchaResponseObs = Resource.onInit(data: SenderKycCaptcha()).obs;
  var captchaObs = SenderKycCaptcha().obs;

  var actionTypeObs = SenderKycActionType.initialStep.obs;

  var resendButtonVisibilityObs = false.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCaptcha();
  }

  onRequestOtp() async {
    if (!initialFormKey.currentState!.validate()) return;

    StatusDialog.progress();
    try {
      var response = await repo.senderKycSendOtp({
        "mobileno": mobileNumber,
        "uuid": captchaObs.value.uuid ?? "",
        "aadharno": aadhaarWithoutSymbol(aadhaarController),
        "captcha_txt": captchaController.text
      });
      Get.back();
      if (response.code == 1) {
        actionTypeObs.value = SenderKycActionType.finalStep;
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onRefreshCaptcha() async {
    StatusDialog.progress();

    try {
      var response = await repo.senderKycReCaptcha(
          {"mobileno": mobileNumber, "uuid": captchaObs.value.uuid ?? ""});
      Get.back();
      if (response.code == 1) {
        captchaObs.value = response;
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _fetchCaptcha() async {
    ObsResponseHandler<SenderKycCaptcha>(
        obs: captchaResponseObs,
        apiCall: repo.senderKycCaptcha({
          "mobileno": mobileNumber,
        }),
        result: (data) {
          captchaObs.value = data;
        });
  }

  verifyOtp() async {


    if(!finalFormKey.currentState!.validate())return;

    StatusDialog.progress();

    try {
      var response = await repo.senderKycVerifyOtp({
        "mobileno": mobileNumber,
        "uuid": captchaObs.value.uuid ?? "",
        "aadharno": aadhaarWithoutSymbol(aadhaarController),
        "captcha_txt": captchaController.text,
        "otp" : otpController.text
      });
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          Get.toNamed(AppRoute.senderKycInfoPage,arguments: {
            "mobile_number" : mobileNumber,
            "dmt_type" : dmtType,
            "from_kyc" : true,
          });
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  resendOtp() async {
    try {
      StatusDialog.progress();

      var response = await repo.senderKycReSendOtp({
        "mobileno": mobileNumber,
        "uuid": captchaObs.value.uuid ?? "",
        "aadharno": aadhaarWithoutSymbol(aadhaarController),
        "captcha_txt": captchaController.text
      });

      Get.back();

      if (response.code == 1) {
        showSuccessSnackbar(title: "Resent Otp", message: response.message);
        resendButtonVisibilityObs.value = false;
      } else {
        showFailureSnackbar(title: "Resent Otp", message: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onReset() {
    aadhaarController.text = "";
    captchaController.text = "";
    actionTypeObs.value = SenderKycActionType.initialStep;
    captchaObs.value = SenderKycCaptcha();
    _fetchCaptcha();
  }

  @override
  void dispose() {
    aadhaarController.dispose();
    captchaController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

enum SenderKycActionType { initialStep, finalStep }

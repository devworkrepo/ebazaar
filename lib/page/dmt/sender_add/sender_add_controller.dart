import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';

class SenderAddController extends GetxController {

  DmtRepo repo = Get.find<DmtRepoImpl>();

  GlobalKey<FormState> senderAddFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var otpController = TextEditingController();

  DmtType dmtType = Get.arguments["dmtType"];

  var resendButtonVisibilityObs = false.obs;
  var actionType = SenderAddActionType.requestOtp.obs;

  onButtonClick() {
    if (actionType.value == SenderAddActionType.requestOtp) {
      _senderRegistrationRequestOtp();
    } else {
      _senderRegistrationVerifyOtp();
    }
  }

  onResendOtp() {
    _senderRegistrationRequestOtp();
  }

  @override
  void onInit() {
    super.onInit();
    mobileNumberController.text = Get.arguments["mobile"];
  }

  _senderRegistrationRequestOtp() async {
    if (actionType.value != SenderAddActionType.addSender) {
      if (!senderAddFormKey.currentState!.validate()) {
        return;
      }
    }

    var name = firstNameController.text.toString() +
        " " +
        lastNameController.text.toString();

    try {
      StatusDialog.progress();

      var response = await repo.senderRegistration({
        "mobileno": mobileNumberController.text.toString(),
        "name": name,
      });

      Get.back();

      if (response.code == 1) {
        actionType.value = SenderAddActionType.addSender;
        resendButtonVisibilityObs.value = false;
        showSuccessSnackbar(
            title: "Remitter Add Otp", message: response.message);
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.off(ExceptionPage(error: e));
    }
  }

  _senderRegistrationVerifyOtp() async {
    final isValidate = senderAddFormKey.currentState!.validate();
    if (!isValidate) return;

    var name = firstNameController.text.toString() +
        " " +
        lastNameController.text.toString();

    try {
      StatusDialog.progress();

      var response = await repo.senderRegistrationOtp({
        "mobileno": mobileNumberController.text.toString(),
        "otp": otpController.text.toString(),
        "name": name,
      });

      Get.back();

      if (response.code == 1) {
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.off(ExceptionPage(error: e));
    }
  }

  String getButtonText() {
    return (actionType.value == SenderAddActionType.requestOtp)
        ? "Request Otp"
        : "Register Remitter";
  }

  bool isTextFieldEnable() {
    return actionType.value == SenderAddActionType.requestOtp;
  }

  @override
  void dispose() {
    mobileNumberController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    otpController.dispose();
    super.dispose();
  }
}

enum SenderAddActionType { requestOtp, addSender }
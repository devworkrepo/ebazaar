import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/otp_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class AadhaarKycController extends GetxController with TransactionHelperMixin {
  final AepsRepo repo = Get.find<AepsRepoImpl>();

  final aadhaarNumberController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String requestId = "";

  @override
  void dispose() {
    aadhaarNumberController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  void onProceed() async {
    try {
      StatusDialog.progress(title: "Requesting Otp");
      var param = {
        "aadhaar_number": aadhaarWithoutSymbol(aadhaarNumberController),
        "mobile": mobileNumberController.text.toString()
      };
      var response = await repo.aadhaarKycRequestOtp(param);
      Get.back();

      if (response.status == 1 || response.status == 3) {
        requestId = response.requestId ?? "";
        _showOtpDaialog();
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  void _showOtpDaialog() {
    Get.dialog(OtpDialogWidget(
      maxLength: 6,
        onSubmit: (value) {
      _verifyOtp(value);
    }));
  }

  void _verifyOtp(String otp) async {
    try {
      StatusDialog.progress(title: "Verifying Otp");
      var param = {"request_id": requestId, "otp": otp};
      var response = await repo.aadhaarKycVerifyOtp(param);
      Get.back();

      if (response.status == 1) {
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

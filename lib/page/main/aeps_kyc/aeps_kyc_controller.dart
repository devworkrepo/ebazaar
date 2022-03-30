import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/aeps_rd_service_dialog.dart';
import 'package:spayindia/component/dialog/otp_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/kyc_repo.dart';
import 'package:spayindia/data/repo_impl/kyc_impl.dart';
import 'package:spayindia/model/aeps/kyc/aeps_kyc_data.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/api/resource/resource.dart';

class AepsKycController extends GetxController {
  var nameController = TextEditingController();
  var mobileController = TextEditingController();
  var panController = TextEditingController();
  var merchantLoginIdController = TextEditingController();

  KycRepo repo = Get.find<KycRepoImpl>();
  var kycDataResponseObs = Resource.onInit(data: AepsKycDataResponse()).obs;
  late AepsKycData aepsKycData;
  var kycStatusObs = AepsKycStatus.requestOtp.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchKycData();
  }

  _fetchKycData() async {
    try {
      kycDataResponseObs.value = const Resource.onInit();
      var response = await repo.fetchKycData();
      if (response.status == 1) {
        aepsKycData = response.details!;
        nameController.text = aepsKycData.agentName ?? "";
        mobileController.text = aepsKycData.mobile ?? "";
        panController.text = aepsKycData.panNumber ?? "";
        merchantLoginIdController.text = aepsKycData.merchantLoginId ?? "";
      } else {
        StatusDialog.failure(title: response.message)
            .then((value) => Get.back());
      }
      kycDataResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      kycDataResponseObs.value = Resource.onFailure(e);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    merchantLoginIdController.dispose();
    panController.dispose();
    super.dispose();
  }

  onRequestOtpButtonClick() async {
    if (kycStatusObs.value == AepsKycStatus.requestOtp) {
      try {
        StatusDialog.progress();
        var response = await repo.requestOtpForAepsKyc();
        Get.back();
        if (response.status == 1) {
          StatusDialog.success(title: response.message)
              .then((value) => _showOtpDialog(response.message));
        } else {
          StatusDialog.failure(title: response.message);
        }
      } catch (e) {
        Get.back();
        Get.to(() => ExceptionPage(error: e));
      }
    } else if (kycStatusObs.value == AepsKycStatus.verifyFingerprint) {
      _showRDServiceDialog();
    }
  }

  _showOtpDialog(String? message) {
    Get.dialog(OtpDialogWidget(
      resendOtpUrl: "aeps/kyc/re-send-otp",
      onSubmit: (otp) {
        _verifyOtp(otp);
      },
      message: message,
    ));
  }

  _verifyOtp(String otp) async {
    try {
      StatusDialog.progress();
      var response = await repo.validateOtpForAepsKyc({"otp": otp});
      Get.back();
      if (response.status == 1) {
        StatusDialog.success(title: response.message).then((value) {
          kycStatusObs.value = AepsKycStatus.verifyFingerprint;
          _showRDServiceDialog();
        });
      } else {
        StatusDialog.failure(title: response.message).then((value) {
          _showOtpDialog(null);
        });
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _showRDServiceDialog() async {
    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchAepsService(
              {"packageUrl": rdServicePackageUrl});
          _verifyFingerprint(result);
        } on PlatformException catch (e) {
          var description =
              "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

          showFailureSnackbar(
              title: "Aeps Capture Failed", message: description);
        } catch (e) {
          Get.to(() => ExceptionPage(error: e));
        }
      },
    ));
  }

  _verifyFingerprint(String result) async {
    try{
      StatusDialog.progress(title: "Verifying...");
      var response = await repo.verifyFingerprint({"kycPidInformation": result});
      Get.back();
      if (response.status == 1) {
        StatusDialog.success(title: response.message).then((value) => Get.back());
      } else {
        StatusDialog.progress(title: response.message);
      }
    }catch(e){
      Get.back();
      Get.to(()=> ExceptionPage(error: e));
    }
  }

  String getButtonText() {
    switch (kycStatusObs.value) {
      case AepsKycStatus.requestOtp:
        return "Request Otp";
      case AepsKycStatus.verifyFingerprint:
        return "Verify Fingerprint";
      default:
        return "Proceed";
    }
  }
}

enum AepsKycStatus { requestOtp, verifyFingerprint }

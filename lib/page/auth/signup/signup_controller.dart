import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/singup_repo.dart';
import 'package:spayindia/data/repo_impl/singup_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/singup/captcha_response.dart';
import 'package:spayindia/model/singup/kyc_detail_response.dart';
import 'package:spayindia/model/singup/kyc_otp_response.dart';
import 'package:spayindia/model/singup/verify_pan_response.dart';
import 'package:spayindia/page/auth/signup/singup_success.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/service/network_sign_up_client.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:spayindia/util/picker_helper.dart';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart' as dio;

import '../../../data/app_pref.dart';
import '../../../widget/dialog/status_dialog.dart';

class SignupController extends GetxController with TransactionHelperMixin {
  AppPreference appPreference = Get.find();
  SignUpRepo repo = Get.find<SingUpRepoImpl>();

  var mobileInputController = TextEditingController();
  var emailInputController = TextEditingController();
  var panInputController = TextEditingController();
  var panInput2Controller = TextEditingController();
  var aadhaarInputController = TextEditingController();
  var mobileOtpController = TextEditingController();
  var emailOtpController = TextEditingController();
  var aadhaarOtpController = TextEditingController();
  var captchaController = TextEditingController();
  var docAadhaarController = TextEditingController();
  var docPanController = TextEditingController();
  var stepOneFormKey = GlobalKey<FormState>();

  var stepContactDetail = StepState.editing.obs;
  var stepMobileVerify = StepState.indexed.obs;
  var stepCaptchaVerify = StepState.indexed.obs;
  var stepAadhaarVerify = StepState.indexed.obs;
  var stepAadhaarDetail = StepState.indexed.obs;
  var stepPanVerification = StepState.indexed.obs;
  var stepUploadDoc = StepState.indexed.obs;

  var stepperCurrentIndex = 0.obs;

  var proceedButtonText = "Continue".obs;
  var captchaUrl = "".obs;
  var captchaUUID = "";
  var panName = "".obs;

  var detailFetched = false.obs;
  late SignUpKycDetailResponse aadhaarDetail;

  File? aadhaarFile;
  File? panFile;

  onContinue() {
    if (stepperCurrentIndex.value == 0) {
      bool result = stepOneFormKey.currentState!.validate();
      if (!result) {
        return;
      }

      stepContactDetail.value = StepState.complete;
      stepMobileVerify.value = StepState.editing;
      stepperCurrentIndex.value = 1;
      proceedButtonText.value = "Verify Mobile Number";
    } else if (stepperCurrentIndex.value == 1) {
      _verifyMobileNumber();
    } else if (stepperCurrentIndex.value == 2) {
      verifyCaptchaAndSendEKycOtp();
    } else if (stepperCurrentIndex.value == 3) {
      _verifyAadhaarOtp();
    } else if (stepperCurrentIndex.value == 4) {
      stepAadhaarDetail.value = StepState.complete;
      stepAadhaarDetail.value = StepState.editing;
      stepperCurrentIndex.value = 5;
      proceedButtonText.value = "";
    } else if (stepperCurrentIndex.value == 5) {
      stepPanVerification.value = StepState.complete;
      stepUploadDoc.value = StepState.editing;
      stepperCurrentIndex.value = 6;
      proceedButtonText.value = "   Submit   ";
    } else if (stepperCurrentIndex.value == 6) {
      if (aadhaarFile == null) {
        StatusDialog.alert(title: "Upload aadhaar file !");
        return;
      }
      if (panFile == null) {
        StatusDialog.alert(title: "Upload pan file !");
        return;
      }
      _finalSubmit();
    }
  }

  setCurrentStep() {}

  bool isStepperActive(int index) {
    return stepperCurrentIndex.value == index;
  }

  void _verifyMobileNumber() async {
    var mobileOtp = mobileOtpController.text.toString();
    if (mobileOtp.length != 6) {
      StatusDialog.alert(
          title: "Enter 6 digits valid Otp, sent to your mobile number");
      return;
    }

    var param = {
      "mobileno": mobileInputController.text.toString(),
      "otp": mobileOtpController.text.toString()
    };
    StatusDialog.progress(title: "Verifying...");
    try {
      CommonResponse response = await repo.verifyMobileOtp(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          stepMobileVerify.value = StepState.complete;
          stepCaptchaVerify.value = StepState.editing;
          stepperCurrentIndex.value = 2;
          proceedButtonText.value = "Verify Captcha";
          fetchCaptcha();
        });
      } else {
        StatusDialog.alert(title: response.message).then((value) {

          if(response.message.toLowerCase() == "mobile no already exists !"){
            stepContactDetail.value = StepState.editing;
            stepMobileVerify.value = StepState.disabled;
            stepperCurrentIndex.value = 0;
            proceedButtonText.value = "Continue";
          }

        });
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  fetchCaptcha({bool reCaptcha = false}) async {
    //proceed
    StatusDialog.progress(title: "Fetching Captcha...");
    try {
      var mobileNumber = mobileInputController.text.toString();
      SignUpCaptchaResponse response = (reCaptcha)
          ? await repo
              .getReCaptcha({"mobileno": mobileNumber, "uuid": captchaUUID})
          : await repo.getCaptcha({"mobileno": mobileNumber});

      Get.back();
      if (response.code == 1) {
        captchaUUID = response.uuid ?? "";
        captchaUrl.value = response.captcha_img ?? "";
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void sendMobileOtp() async {
    StatusDialog.progress(title: "Sending...");
    try {
      var mobileNumber = mobileInputController.text.toString();
      CommonResponse response =
          await repo.sendMobileOtp({"mobileno": mobileNumber});

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message);
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void verifyCaptchaAndSendEKycOtp({bool resendOtp = false}) async {
    var captcha = captchaController.text.toString();
    if (captcha.isEmpty) {
      StatusDialog.alert(title: "Please fill captcha");
      return;
    }

    var progressText =
        (resendOtp) ? "Resending Otp..." : "Verifying and Sending Otp";
    StatusDialog.progress(title: progressText);

    try {
      var param = {
        "mobileno": mobileInputController.text.toString(),
        "aadharno": aadhaarWithoutSymbol(aadhaarInputController),
        "captcha_txt": captchaController.text.toString(),
        "uuid": captchaUUID,
      };

      SignUpEKycResponse response = (resendOtp)
          ? await repo.resendEKycOtp(param)
          : await repo.sendEKycOtp(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          stepCaptchaVerify.value = StepState.complete;
          stepAadhaarVerify.value = StepState.editing;
          stepperCurrentIndex.value = 3;
          proceedButtonText.value = "Verify Aadhaar Otp";
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  void _verifyAadhaarOtp() async {
    var aadhaarOtp = aadhaarOtpController.text.toString();
    if (aadhaarOtp.length != 6) {
      StatusDialog.alert(
          title:
              "Enter 6 digits aadhaar verification otp, sent to your register mobile number");
      return;
    }

    StatusDialog.progress(title: "Verifying OTP...");
    try {
      SignUpEKycResponse response = await repo.verifyEKycOtp({
        "mobileno": mobileInputController.text.toString(),
        "aadharno": aadhaarWithoutSymbol(aadhaarInputController),
        "uuid": captchaUUID,
        "otp": aadhaarOtpController.text.toString(),
      });

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          captchaUUID = response.uuid ?? "";
          stepAadhaarVerify.value = StepState.complete;
          stepAadhaarDetail.value = StepState.editing;
          stepperCurrentIndex.value = 4;
          proceedButtonText.value = "";
          _fetchAadhaarDetail();
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  verifyPanNumber() async {
    var aadhaarOtp = panInput2Controller.text.toString();
    if (aadhaarOtp.length != 10) {
      StatusDialog.alert(title: "Enter 10 characters valid PAN Number!");
      return;
    }

    StatusDialog.progress(title: "Verifying Pan...");
    try {
      SignUpVerifyPanResponse response = await repo.verifyPan({
        "panno": panInput2Controller.text.toString(),
      });

      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message).then((value) {
          panName.value = response.pan_name ?? "";
          proceedButtonText.value = "Continue";
        });
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  _fetchAadhaarDetail() async {
    StatusDialog.progress(title: "Fetching User Details");
    try {
      var response = await repo.getKycDetail({
        "mobileno": mobileInputController.text.toString(),
        "uuid": captchaUUID
      });
      Get.back();
      if (response.code == 1) {
        aadhaarDetail = response;
        proceedButtonText.value = "Continue";
        detailFetched.value = true;
      } else {
        StatusDialog.alert(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  showImagePickerBottomSheetDialog(SignUpFileType type) async {
    ImagePickerHelper.pickImageWithCrop((File? image) {
      if (type == SignUpFileType.aadhaar) {
        aadhaarFile = image;
        if (image == null) {
          docAadhaarController.text = "";
        } else {
          var fileName = aadhaarFile!.path.split("/").last;
          var fileExtension = path.extension(fileName);
          docAadhaarController.text =
              "aadhaar_${DateTime.now().millisecondsSinceEpoch}" +
                  fileExtension;
        }
      } else {
        panFile = image;
        if (image == null) {
          docPanController.text = "";
        } else {
          var fileName = panFile!.path.split("/").last;
          var fileExtension = path.extension(fileName);
          docPanController.text =
              "pan_${DateTime.now().millisecondsSinceEpoch}" + fileExtension;
        }
      }
    }, () {
      if (type == SignUpFileType.aadhaar) {
        aadhaarFile = null;
        docAadhaarController.text = "Uploading please wait...";
      } else {
        panFile = null;
        docPanController.text = "Uploading please wait...";
      }
    });
  }

  _finalSubmit() async {
    StatusDialog.progress(title: "Submitting...");

    try {
      var formDataParam = await _finalRequestParam();
      CommonResponse response = await repo.signUpUser(formDataParam);
      Get.back();
      if (response.code == 1) {
        Get.dialog(const SingUpSuccessDialog()).then((value) {
          Get.offAllNamed(AppRoute.loginPage);
        });
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      StatusDialog.alert(
          title:
              "Something went wrong! please try again after sometime! thank you.");
    }
  }

  Future<dio.FormData> _finalRequestParam() async {
    dio.MultipartFile? aadhaarFilePart;
    dio.MultipartFile? panFileFilePart;

    aadhaarFilePart = await dio.MultipartFile.fromFile(aadhaarFile!.path,
        filename: aadhaarFile!.path.split("/").last.replaceAll("..", "."));
    panFileFilePart = await dio.MultipartFile.fromFile(panFile!.path,
        filename: panFile!.path.split("/").last.replaceAll("..", "."));

    var param = {
      "image1": aadhaarFilePart,
      "image2": panFileFilePart,
      "mobileno": mobileInputController.text.toString(),
      "fullname": aadhaarDetail.name,
      "address": aadhaarDetail.address,
      "emailid": emailInputController.text.toString(),
      "gender": aadhaarDetail.gender,
      "dob": AppUtil.changeDateToMMDDYYYY(aadhaarDetail.dob ?? ""),
      "pan_no": panInput2Controller.text.toString(),
      "aadhar_no": aadhaarWithoutSymbol(aadhaarInputController),
      "picname": aadhaarDetail.picname,
    };
    return dio.FormData.fromMap(param);
  }
}

enum SignUpFileType { aadhaar, pan }

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/auth/signup/singup_success.dart';

import '../../../data/app_pref.dart';
import '../../../widget/dialog/status_dialog.dart';

class SignupController extends GetxController {
  AppPreference appPreference = Get.find();

  var mobileInputController = TextEditingController();
  var emailInputController = TextEditingController();
  var panInputController = TextEditingController();
  var aadhaarInputController = TextEditingController();
  var mobileOtpController = TextEditingController();
  var emailOtpController = TextEditingController();
  var aadhaarOtpController = TextEditingController();
  var captchaController = TextEditingController();
  var docAadhaarController = TextEditingController();
  var docPanController = TextEditingController();
  var stepOneFormKey = GlobalKey<FormState>();

  var step1 = StepState.editing.obs;
  var step2 = StepState.indexed.obs;
  var step3 = StepState.indexed.obs;
  var step4 = StepState.indexed.obs;
  var step5 = StepState.indexed.obs;
  var step6 = StepState.indexed.obs;
  var step7 = StepState.indexed.obs;
  var step8 = StepState.indexed.obs;

  var stepperCurrentIndex = 0.obs;

  var proceedButtonText = "Continue".obs;


  onContinue() {


    if (stepperCurrentIndex.value == 0) {
      step1.value = StepState.disabled;
      step2.value = StepState.editing;
      stepperCurrentIndex.value = 1;
      proceedButtonText.value = "Verify Mobile Number";
    } else if (stepperCurrentIndex.value == 1) {
      step2.value = StepState.disabled;
      step3.value = StepState.editing;
      stepperCurrentIndex.value = 2;
      proceedButtonText.value = "Verify Email Id";

    } else if (stepperCurrentIndex.value == 2) {
      step3.value = StepState.disabled;
      step4.value = StepState.editing;
      stepperCurrentIndex.value = 3;
      proceedButtonText.value = "Verify Aadhaar Otp";

    } else if (stepperCurrentIndex.value == 3) {
      step4.value = StepState.disabled;
      step5.value = StepState.editing;
      stepperCurrentIndex.value = 4;
      proceedButtonText.value = "Verify Captcha";
    } else if (stepperCurrentIndex.value == 4) {
      step5.value = StepState.disabled;
      step6.value = StepState.editing;
      stepperCurrentIndex.value = 5;
      proceedButtonText.value = "Verify Details";

    }
    else if (stepperCurrentIndex.value == 5) {
      step6.value = StepState.disabled;
      step7.value = StepState.editing;
      stepperCurrentIndex.value = 6;
      proceedButtonText.value = "Continue";

    }
    else if (stepperCurrentIndex.value == 6) {
      step7.value = StepState.disabled;
      step8.value = StepState.editing;
      stepperCurrentIndex.value = 7;
      proceedButtonText.value = "Submit";

    }
    else if(stepperCurrentIndex.value == 7){
      Get.dialog(SingUpSuccessDialog());
    }
  }

  setCurrentStep(){

  }

  bool isStepperActive(int index) {
    return stepperCurrentIndex.value == index;
  }
}

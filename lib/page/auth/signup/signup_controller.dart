import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../data/app_pref.dart';
import '../../../widget/dialog/status_dialog.dart';


class SignupController extends GetxController  {

  AppPreference appPreference = Get.find();

  var outletNameController = TextEditingController();
  var outletAddressController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var personalInfoFormKey = GlobalKey<FormState>();

  var stepperStateMobile = StepState.editing.obs;
  var stepperStateEmail = StepState.indexed.obs;
  var stepperStatePan = StepState.indexed.obs;
  var stepperStateFinal = StepState.indexed.obs;
  var stepperStateFina2 = StepState.indexed.obs;

  var stepperCurrentIndex = 0.obs;



  onContinue() {
    if (stepperCurrentIndex.value == 0) {

    } else if (stepperCurrentIndex.value == 1) {

    } else if (stepperCurrentIndex.value == 2) {

    } else if (stepperCurrentIndex.value == 3) {

    }
  }

  bool isStepperActive(int index) {
    return stepperCurrentIndex.value == index;
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/auth/signup/signup_controller.dart';
import 'package:spayindia/page/auth/signup/step/personal_info_step.dart';

import '../../../widget/button.dart';


class SignupPage extends GetView<SignupController> {
  const SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignupController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:  const Text("Sign Up") ,
      ),
      body: Obx(() {
        return Stepper(
          elevation: 1,
          onStepTapped: (value) {},
          currentStep: controller.stepperCurrentIndex.value,
          onStepContinue: controller.onContinue,
          onStepCancel: () {},
          controlsBuilder: (BuildContext context,ControlsDetails details) {
            return Row(
              children: [
                Expanded(
                    child: AppButton(text: "Proceed", onClick: details.onStepContinue)),
              ],
            );
          },
          type: StepperType.horizontal,
          steps: [
            Step(
                state: controller.stepperStateMobile.value,
                isActive: controller.isStepperActive(0),
                title: const Text("Step 1"),
                content: const PersonalInfoStepWidget()),
            Step(
                state: controller.stepperStateEmail.value,
                isActive: controller.isStepperActive(1),
                title: const Text("Step 2"),
                content: const SizedBox()),
            Step(
                state: controller.stepperStatePan.value,
                isActive: controller.isStepperActive(2),
                title: const Text("Step 3"),
                content: const SizedBox()),
            Step(
                state: controller.stepperStateFinal.value,
                isActive: controller.isStepperActive(3),
                title: const Text("Step 4"),
                content: const SizedBox()),
          ],
        );
      }),
    );
  }
}




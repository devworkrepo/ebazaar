import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/auth/signup/signup_controller.dart';
import 'package:spayindia/page/auth/signup/step/step_eight.dart';
import 'package:spayindia/page/auth/signup/step/step_five.dart';
import 'package:spayindia/page/auth/signup/step/step_four.dart';
import 'package:spayindia/page/auth/signup/step/step_one.dart';
import 'package:spayindia/page/auth/signup/step/step_seven.dart';
import 'package:spayindia/page/auth/signup/step/step_six.dart';
import 'package:spayindia/page/auth/signup/step/step_three.dart';
import 'package:spayindia/page/auth/signup/step/step_two.dart';

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
          onStepTapped: (value) {
            print(value);
            controller.stepperCurrentIndex.value = value;
          },
          currentStep: controller.stepperCurrentIndex.value,
          onStepContinue: controller.onContinue,
          onStepCancel: () {},
          controlsBuilder: (BuildContext context,ControlsDetails details) {
            return Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green
                ),
                onPressed: (){
                  controller.onContinue();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                  Text(controller.proceedButtonText.value),
                  const Icon(Icons.chevron_right_outlined)
                ],),
              ),
            );
          },
          type: StepperType.horizontal,
          steps: [
            Step(
                state: controller.step1.value,
                isActive: controller.isStepperActive(0),
                title: const Text(""),
                content: const SingUpStepOneWidget()),
            Step(
                state: controller.step2.value,
                isActive: controller.isStepperActive(1),
                title: const Text(""),
                content: const SingUpStepTwoWidget()),
            Step(
                state: controller.step3.value,
                isActive: controller.isStepperActive(2),
                title: const Text(""),
                content: const SingUpStepThreeWidget()),
            Step(
                state: controller.step4.value,
                isActive: controller.isStepperActive(3),
                title: const Text(""),
                content: const SingUpStepFourWidget()),
            Step(
                state: controller.step5.value,
                isActive: controller.isStepperActive(4),
                title: const Text(""),
                content: const SingUpStepFiveWidget()),
            Step(
                state: controller.step6.value,
                isActive: controller.isStepperActive(5),
                title: const Text(""),
                content: const SingUpStepSixWidget()),
            Step(
                state: controller.step7.value,
                isActive: controller.isStepperActive(6),
                title: const Text(""),
                content: const SingUpStepSevenWidget()),
            Step(
                state: controller.step8.value,
                isActive: controller.isStepperActive(7),
                title: const Text(""),
                content: const SingUpStepEightWidget()),

          ],
        );
      }),
    );
  }
}




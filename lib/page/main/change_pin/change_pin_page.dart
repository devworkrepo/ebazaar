import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/text_field.dart';
import 'package:spayindia/util/validator.dart';

import 'change_pin_controller.dart';

class ChangePinPage extends GetView<ChangePinController> {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePinController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change M-Pin"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [_BuildFormWidget()],
                ),
              ),
            ),
          ),
         Obx(()=> AppButton(
             text: (controller.changePinActionTypeObs.value ==
                 ChangePinActionType.requestOtp)
                 ? "Request OTP"
                 : "Verify OTP",
             onClick: () {
               if (controller.formKey.currentState!.validate()) {
                 if (controller.changePinActionTypeObs.value ==
                     ChangePinActionType.requestOtp) {
                   controller.requestOtp();
                 } else {
                   controller.verifyOtp();
                 }
               }
             }))
        ],
      ),
    );
  }
}

class _BuildFormWidget extends GetView<ChangePinController> {
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "M-PIN",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  MPinTextField(
                    controller: controller.newMPinController,
                  ),
                  AppTextField(
                    controller: controller.confirmMPinController,
                    label: "Confirm M-Pin",
                    inputType: TextInputType.number,
                    hint: "Required*",
                    passwordMode: true,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null) {
                        return "Confirm M-PIN didn't matched!";
                      } else {
                        if (controller.newMPinController.text == value) {
                          return null;
                        } else {
                          return "Confirm M-PIN didn't matched!";
                        }
                      }
                    },
                  ),
                  Obx(() => (controller.changePinActionTypeObs.value ==
                          ChangePinActionType.changePin)
                      ? OtpTextField(
                          controller: controller.otpController,
                          maxLength: 6,
                        )
                      : const SizedBox())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

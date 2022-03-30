import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/dialog/otp_dialog.dart';
import 'package:spayindia/component/text_field.dart';
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
              child: Column(
                children: const [_BuildFormWidget()],
              ),
            ),
          ),
          AppButton(
              text: "Change Pin",
              onClick: () {

                if (controller.formKey.currentState!.validate()) {
                  controller.requestOtp();
                }
              })
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
                  AppTextField(
                    controller: controller.newMPinController,
                    label: "New M-Pin",
                    inputType: TextInputType.number,
                    hint: "Required*",
                    passwordMode: true,
                    maxLength: 4,
                    validator: (value) => FormValidatorHelper.mpin(value),
                  ),
                  AppTextField(
                    controller: controller.confirmMPinController,
                    label: "Confirm M-Pin",
                    inputType: TextInputType.number,
                    hint: "Required*",
                    passwordMode: true,
                    maxLength: 4,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

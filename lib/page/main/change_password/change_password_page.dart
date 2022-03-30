import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/util/validator.dart';

import 'change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
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
              text: "Proceed",
              onClick: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.changePassword();
                }
              })
        ],
      ),
    );
  }
}

class _BuildFormWidget extends GetView<ChangePasswordController> {
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
              "Change Password",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [

                  PasswordTextField(
                    controller: controller.oldPasswordController,
                    label: "Old Password",
                    hint: "Required*",
                  ),
                  PasswordTextField(
                    controller: controller.newPasswordController,
                    label: "New Password",
                    hint: "Required*",

                  ),
                  PasswordTextField(
                    controller: controller.confirmPasswordController,
                    label: "Confirm Password",
                    hint: "Required*",
                    validator: (value){
                      var messageOne = "Enter Confirm Password";
                      var messageTwo = "Password didn't matched";
                      if(value == null){
                        return messageOne;
                      }
                      if(value.isEmpty){
                        return messageOne;
                      }
                      if(controller.newPasswordController.text != value){
                        return messageTwo;
                      }
                      return null;
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

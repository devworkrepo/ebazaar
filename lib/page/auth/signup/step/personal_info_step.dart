import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class PersonalInfoStepWidget extends GetView<SignupController> {
  const PersonalInfoStepWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Form(
        key: controller.personalInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Personal Details",style: Get.textTheme.headline6,),
          AppTextField(
            controller: controller.outletNameController,
            label: "Outlet Name",
          ),
          AppTextField(
            controller: controller.outletAddressController,
            label: "Outlet Address",
          ),
          PasswordTextField(
            controller: controller.passwordController,
          ),
          PasswordTextField(
            controller: controller.confirmPasswordController,
            label: "Confirm Password",
            hint: "Required*",
            validator: (value) {
              var messageOne = "Enter Confirm Password";
              var messageTwo = "Password didn't matched";
              if (value == null) {
                return messageOne;
              }
              if (value.isEmpty) {
                return messageOne;
              }
              if (controller.passwordController.text != value) {
                return messageTwo;
              }
              return null;
            },
          ),

          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}


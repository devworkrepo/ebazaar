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
          Text("Contact Details",style: Get.textTheme.headline6,),
          MobileTextField(
            controller: controller.outletNameController,
          ),
          EmailTextField(
            controller: controller.outletAddressController,
          ),
          AppTextField(controller: controller.passwordController,
          label: "Pan Number",
          hint: "10 characters pan number",),

          AadhaarTextField(controller: controller.passwordController),

          const SizedBox(
            height: 32,
          ),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class SingUpStepEightWidget extends GetView<SignupController> {
  const SingUpStepEightWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Upload Docs", style: Get.textTheme.headline6,),

          AppTextField(
            label: "Aadhaar Front Photo",
            controller: controller.docAadhaarController,
          onFieldTab: (){

          },),
          AppTextField(
            label: "PAN Front Photo",
            controller: controller.docPanController,
            onFieldTab: (){

            },),

          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}


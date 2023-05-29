import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class SingUpStepFourWidget extends GetView<SignupController> {
  const SingUpStepFourWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Aadhaar Number", style: Get.textTheme.headline6,),
          
          OtpTextField(controller: controller.aadhaarOtpController),

          const SizedBox(height: 16,),
          Align(
            alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){}, child: Text("Send Otp"))),


          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}


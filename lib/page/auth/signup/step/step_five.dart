import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class SingUpStepFiveWidget extends GetView<SignupController> {
  const SingUpStepFiveWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Captcha", style: Get.textTheme.headline6,),

          AppTextField(controller: controller.captchaController,
          label: "Captcha",
          hint: "captcha from below image",),

          const SizedBox(height: 16,),

          Row(children: [
            Expanded(
              child: Container(
               decoration: BoxDecoration(
                 color: Colors.blue.withOpacity(0.2),
                 borderRadius: BorderRadius.circular(5)
               ),
                height: 60,
              ),
            ),
            SizedBox(width: 16,),
            TextButton(onPressed: (){}, child: Text("Refresh\nCaptcha"))
          ],),


          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}


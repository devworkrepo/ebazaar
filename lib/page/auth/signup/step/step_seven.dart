import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class SingUpStepSevenWidget extends GetView<SignupController> {
  const SingUpStepSevenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify Pan Number",
          style: Get.textTheme.headline6,
        ),
        AppTextField(
          controller: controller.panInputController,
          label: "Pan Number",
          hint: "10 characters pan number",
          maxLength: 10,
          validator: (value) => FormValidatorHelper.isValidPanCardNo(value),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name in PAN :-",
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  "Akash Kumar Das",
                  style: Get.textTheme.subtitle1,
                ),
              ],
            )),
            SizedBox(
              width: 16,
            ),
            TextButton(onPressed: () {}, child: Text("Verify Pan"))
          ],
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

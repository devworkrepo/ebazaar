import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/text_field.dart';
import 'package:spayindia/util/obx_widget.dart';

import '../../../widget/drop_down.dart';
import '../../../util/input_validator.dart';
import 'aeps_onbording_controller.dart';

class AepsOnboardingPage extends GetView<AepsOnboardingController> {
  const AepsOnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsOnboardingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Onboarding"),
      ),
      body: ObsResourceWidget(
        obs: controller.stateListResponseObs,
        childBuilder: (data) => _buildBody(),
      ),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: const [_BuildFormWidget()],
        ),
      ),
    );
  }
}

class _BuildFormWidget extends GetView<AepsOnboardingController> {
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
              "Form Data",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AppTextField(
                      inputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        AadhaarInputValidator()
                      ],
                      maxLength: 14,
                      hint: "Aadhaar number",
                      label: "Aadhaar Number",
                      validator: (value) {
                        if (value!.length == 14) {
                          return null;
                        } else {
                          return "Enter 12 digits aadhaar number";
                        }
                      },
                      controller: controller.aadhaarController),
                  AppDropDown(
                    maxHeight: Get.height * 0.75,
                    list:
                        List.from(controller.aepsStateList.map((e) => e.name)),
                    onChange: (value) {
                      try {
                        controller.selectedState = controller.aepsStateList
                            .firstWhere((element) => element.name == value);
                      } catch (e) {
                        controller.selectedState = null;
                        Get.snackbar("State is not selected",
                            "Exception raised while selecting state",
                            backgroundColor: Colors.red,
                            colorText: Colors.white);
                      }
                    },
                    validator: (value) {
                      if (controller.selectedState == null) {
                        return "Select State";
                      } else {
                        return null;
                      }
                    },
                    searchMode: true,
                    label: "Select State",
                    hint: "Select State",
                  ),

                  const SizedBox(height: 16,),
                  AppButton(text: "Proceed", onClick: controller.onProceed)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

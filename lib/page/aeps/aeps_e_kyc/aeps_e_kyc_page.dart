import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/aeps/aeps_e_kyc/aeps_e_kyc_controller.dart';
import 'package:spayindia/util/obx_widget.dart';
import 'package:spayindia/util/validator.dart';

class AepsEKycPage extends GetView<AepsEKycController> {
  const AepsEKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsEKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-KYC"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [_BuildStepOneForm()],
          ),
        ),
      ),
    );
  }
}

class _BuildStepOneForm extends GetView<AepsEKycController> {
  const _BuildStepOneForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formOneKey,
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Setup One",
                    style: Get.textTheme.headline6,
                  ),
                  AppTextField(
                    label: "Device Serial Number",
                    hint: "Required*",
                    validator: FormValidatorHelper.normalValidation,
                    controller: controller.deviceSerialController,
                  ),
                  ConditionalWidget(
                      condition: controller.actionTypeObs.value !=
                          EKycActionType.requestOtp,
                      child: OtpTextField(
                        controller: controller.otpController,
                        maxLength: 7,
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                      text: controller.getButtonText(),
                      onClick: controller.onSubmit)
                ],
              )),
        ),
      ),
    );
  }
}

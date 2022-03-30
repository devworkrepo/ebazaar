import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/aeps_kyc/aeps_kyc_controller.dart';

class AepsKycPage extends GetView<AepsKycController> {
  const AepsKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Kyc"),
      ),
      body: Obx(() => controller.kycDataResponseObs.value.when(
          onSuccess: (data) {
            if (data.status == 1) {
              return const _BuildBody();
            } else {
              return const SizedBox();
            }
          },
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => ApiProgress(data))),
    );
  }
}

class _BuildBody extends GetView<AepsKycController> {
  const _BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 16, right: 16, left: 16),
              child: Column(
                children: [AppTextField(
                  label: "Agent Name",
                    enable: false,
                    controller: controller.nameController),
                  AppTextField(
                    enable: false,
                      label: "Mobile Number",
                      controller: controller.mobileController),
                  AppTextField(
                    enable: false,
                      label: "Pan Number",
                      controller: controller.panController),
                  AppTextField(
                    enable: false,
                      label: "Merchant Login Id",
                      controller: controller.merchantLoginIdController),
                ],
              ),
            ),
          ),
        )),
        Obx((){
            return AppButton(text: controller.getButtonText(), onClick: () => controller.onRequestOtpButtonClick());
          }
        )
      ],
    );
  }
}

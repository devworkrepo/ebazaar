import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/main/addhaar_kyc/aadhaar_kyc_controller.dart';
import 'package:spayindia/util/input_validator.dart';

class AadhaarKycPage extends GetView<AadhaarKycController> {
  const AadhaarKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AadhaarKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aadhaar Kyc"),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: const [
                _BuildFormWidget()
              ],
            ),
          )),
          AppButton(text: "Proceed", onClick: () {
            if(controller.formKey.currentState!.validate()){
              controller.onProceed();
            }
          })
        ],
      ),
    );
  }
}

class _BuildFormWidget extends GetView<AadhaarKycController> {
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                  hint: "Aadhaar number is required",
                  label: "Aadhaar Number",
                  validator: (value) {
                    if (value!.length == 14) {
                      return null;
                    } else {
                      return "Enter 12 digits aadhaar number";
                    }
                  },
                  controller: controller.aadhaarNumberController),
              MobileTextField(
                label: "Mobile Number with Aadhaar Linked",
                  controller: controller.mobileNumberController)

            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/security_deposit/security_deposit_controller.dart';
import 'package:spayindia/util/validator.dart';
import 'package:spayindia/widget/radio.dart';
import 'package:spayindia/widget/text_field.dart';

import '../../widget/button.dart';

class SecurityDepositPage extends GetView<SecurityDepositController> {
  const SecurityDepositPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SecurityDepositController());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Security Deposit"),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(child: _buildFormKeyOne()),
            ),
          ],
        ));
  }

  _buildFormKeyOne() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 24, right: 24, left: 24),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text("User Detail",
                          style: Get.textTheme.subtitle1
                              ?.copyWith(color: Get.theme.primaryColor)),
                      SizedBox(
                        height: 16,
                      ),
                      _BuildTitleValueText(
                        title: "First Name",
                        value: "Akash Kumar",
                      ),
                      _BuildTitleValueText(
                        title: "Last Name",
                        value: "Das",
                      ),
                      _BuildTitleValueText(
                        title: "Mobile Number",
                        value: "7982607742",
                      ),
                      _BuildTitleValueText(
                        title: "Email ID",
                        value: "hiakashkd@gmail.com",
                      ),
                      _BuildTitleValueText(
                        title: "Date of Birth",
                        value: "04/05/1998",
                      ),
                      _BuildTitleValueText(
                        title: "PAN Number",
                        value: "CIUPD1085N",
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 24, right: 24, left: 24),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Tenure For",
                          style: Get.textTheme.subtitle1
                              ?.copyWith(color: Get.theme.primaryColor)),
                      Obx(() => Column(
                            children: [
                              AppRadioButton(
                                  groupValue: controller.tenureObs.value,
                                  value: 1,
                                  title: "1 Year",
                                  onChange: (int value) {
                                    controller.tenureObs.value = value;
                                  }),
                              AppRadioButton(
                                  groupValue: controller.tenureObs.value,
                                  value: 2,
                                  title: "2 Years",
                                  onChange: (int value) {
                                    controller.tenureObs.value = value;
                                  }),
                              AppRadioButton(
                                  groupValue: controller.tenureObs.value,
                                  value: 3,
                                  title: "3 Years",
                                  onChange: (int value) {
                                    controller.tenureObs.value = value;
                                  })
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 24, right: 24, left: 24),
                child: SizedBox(
                  width: Get.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      Text("Fill Detail",
                          style: Get.textTheme.subtitle1
                              ?.copyWith(color: Get.theme.primaryColor)),
                      AmountTextField(
                        label: "Deposit Amount",
                        controller: controller.amountController,
                        validator: (value) => FormValidatorHelper.amount(value,
                            minAmount: 200000, maxAmount: -1),
                      ),
                      AadhaarTextField(
                          controller: controller.aadhaarController),
                      MPinTextField(controller: controller.mpinController),
                      const SizedBox(
                        height: 24,
                      ),
                      AppButton(
                          text: "Submit & Proceed",
                          onClick: controller.onSubmit)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildTitleValueText extends StatelessWidget {
  final String title;
  final String value;

  const _BuildTitleValueText(
      {required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey[600]),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        ),
        const Divider(
          indent: 0,
        )
      ],
    );
  }
}

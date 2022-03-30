import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/drop_down.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/util/validator.dart';

import '../../../exception_page.dart';
import 'aeps_settlement_add_bank_controller.dart';

class AepsSettlementAddBankPage
    extends GetView<AepsSettlementAddBankController> {
  const AepsSettlementAddBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsSettlementAddBankController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Settlement Bank"),
      ),
      body:Obx(() => controller.bankListResponseObs.value.when(
          onSuccess: (data) => (data.status == 1)
              ? const _BuildBodyWidget()
              : ExceptionPage(error: Exception(data.message)),
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => ApiProgress(data))) ,
    );
  }


}

class _BuildBodyWidget extends GetView<AepsSettlementAddBankController> {
  const _BuildBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: const [_BuildNoteWidget(), _BuildFormWidget()],
              ),
            )),
        AppButton(text: "Add Bank", onClick: () {
          if(controller.formKey.currentState!.validate()){
            controller.addBank();
          }
        })
      ],
    );
  }
}


class _BuildFormWidget extends GetView<AepsSettlementAddBankController> {
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              AppDropDown(
                maxHeight: Get.height *0.75,
                list: List.from(controller.banks.map((e) => e.name)),
                onChange: (value) {
                  try {
                    controller.selectedBank = controller.banks
                        .firstWhere((element) => element.name == value);
                  } catch (e) {
                    controller.selectedBank = null;
                    Get.snackbar("Bank is not selected",
                        "Exception raised while selecting bank",
                        backgroundColor: Colors.red,
                        colorText: Colors.white);
                  }
                },
                validator: (value) {
                  if (controller.selectedBank == null) {
                    return "Select bank";
                  } else {
                    return null;
                  }
                },
                searchMode: true,
                label: "Select Bank",
                hint: "Select Bank",
              ),
              AppTextField(
                controller: controller.ifscController,
                label: "IFSC Code",
                allCaps: true,
                maxLength: 11,
                validator: (value){
                  if(value!.length == 11){
                    return null;
                  }else {
                    return "Enter 11 digits valid ifsc code";
                  }
                },
              ),
              AppTextField(
                inputType: TextInputType.number,
                maxLength: 20,
                controller: controller.accountNumberController,
                label: "Account Number",
                validator: (value){
                  if(value!.length > 8 && value.length <=20){
                    return null;
                  }
                  else {
                    return "Enter 8 - 20 digits account number";
                  }
                },
              ),
              AppTextField(
                inputType: TextInputType.number,
                maxLength: 20,
                controller: controller.confirmAccountNumberController,
                label: "Confirm Account Number",
                validator: (value){
                  if(value == controller.accountNumberController.text.toString()){
                    return null;
                  }
                  else {
                    return "Account number didn't matched!";
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildNoteWidget extends StatelessWidget {
  const _BuildNoteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/main/settlement/transfer/aeps_settlement_transfer_controller.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/validator.dart';

class AepsSettlementTransferPage
    extends GetView<AepsSettlementTransferController> {
  const AepsSettlementTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsSettlementTransferController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settlement"),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: const [
                _BuildBankInfoWidget(),
                _BuildTermConditionWidget(),
                _BuildAmountWidget(),
              ],
            ),
          )),
          AppButton(
              text: "Proceed",
              onClick: () {
                if (controller.formKey.currentState!.validate()) {
                  controller.onProceed();
                }
              })
        ],
      ),
    );
  }
}

class _BuildTermConditionWidget extends StatelessWidget {
  const _BuildTermConditionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Terms and Conditions:-",
                style: Get.textTheme.subtitle1,
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "1. Please check account number before settlement for imps option. Any transaction to wrong account using imps will not be returned back.",
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.black54),
              ),
              const SizedBox(
                height: 8,
              ),
              RichText(
                text: TextSpan(
                  text: '1. All settlement will be charged ',
                  style:
                      Get.textTheme.bodyText1?.copyWith(color: Colors.black54),
                  children: const <TextSpan>[
                    TextSpan(
                        text: 'Rs 8.00  per Rs 25000 ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red)),
                    TextSpan(text: 'Which deducted from wallet amount.'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildAmountWidget extends GetView<AepsSettlementTransferController> {
  const _BuildAmountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Withdrawal Amount", style: Get.textTheme.subtitle1),
              AmountTextField(
                controller: controller.amountController,
                validator: (value) => FormValidatorHelper.amount(value,
                    minAmount: 10, maxAmount: 25000),
              ),
              MPinTextField(
                controller: controller.mpinController,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildBankInfoWidget extends GetView<AepsSettlementTransferController> {
  const _BuildBankInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bank Detail", style: Get.textTheme.subtitle1),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const BuildLeftListWidget("Holder Name"),
                const BuildDotWidget(),
                BuildRightListWidget(controller.bank.name.orNA())
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const BuildLeftListWidget("Account No."),
                const BuildDotWidget(),
                BuildRightListWidget(controller.bank.accountNumber.orNA())
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const BuildLeftListWidget("Bank Name"),
                const BuildDotWidget(),
                BuildRightListWidget(controller.bank.bankName.orNA())
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const BuildLeftListWidget("IFSC Code"),
                const BuildDotWidget(),
                BuildRightListWidget(controller.bank.ifsc.orNA())
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const BuildLeftListWidget("Available Balance"),
                const BuildDotWidget(),
                BuildRightListWidget(controller.bank.balance.orNA())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

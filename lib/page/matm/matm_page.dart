import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/radio.dart';
import 'package:spayindia/component/status_bar_color_widget.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/util/validator.dart';

import 'matm_controller.dart';

class MatmPage extends GetView<MatmController> {
  const MatmPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmController());
    return StatusBarColorWidget(
      color: Get.theme.primaryColorDark,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Matm"),
        ),
        body: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_buildFormKeyOne()],
            ),
          ),
        ),
        AppButton(
          text: "Capture and Proceed",
          onClick: controller.onProceed,
        )
      ],
    );
  }

  _buildFormKeyOne() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Form(
            key: controller.matmFormKey,
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 24, right: 24, left: 24),
                    child: Column(
                      children: [
                        MobileTextField(
                            controller: controller.mobileController),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 16, bottom: 16, right: 16, left: 16),
                    child: Obx(()=>Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Transaction Type",
                          style: Get.textTheme.subtitle1,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        AppRadioButton<MatmTransactionType>(
                          groupValue: controller.transactionType.value,
                          value: MatmTransactionType.cashWithdrawal,
                          title: "Cash Withdrawal",
                          onChange: (MatmTransactionType type) {
                            controller.transactionType.value = type;
                          },
                        ),
                        AppRadioButton<MatmTransactionType>(
                          groupValue: controller.transactionType.value,
                          value: MatmTransactionType.balanceEnquiry,
                          title: "Balance Enquiry",
                          onChange: (MatmTransactionType type) {
                            controller.transactionType.value = type;
                          },
                        ),
                      ],
                    )),
                  ),
                ),
                Obx(() => (controller.transactionType.value ==
                        MatmTransactionType.cashWithdrawal)
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 16, right: 16, left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transaction Amount",
                                style: Get.textTheme.subtitle1,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              AmountTextField(
                                controller: controller.amountController,
                                validator: (value) =>
                                    FormValidatorHelper.amount(value,
                                        minAmount: (kDebugMode) ? 1 : 100, maxAmount: 10000),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MatmTransactionType {
  cashWithdrawal,
  balanceEnquiry,
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/radio.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/main/settlement/aeps_settlement_controller.dart';
import 'package:spayindia/util/obx_widget.dart';
import 'package:spayindia/util/validator.dart';

import '../../../component/drop_down.dart';

class AepsSettlementPage extends GetView<AepsSettlementController> {
  const AepsSettlementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsSettlementController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Settlement"),
      ),
      body: ObsResourceWidget(
          obs: controller.balanceResponseObs,
          childBuilder: (data) => SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTransferToWidget(),
                    Obx(() => Column(
                          children: [
                            (controller.actionType.value ==
                                    AepsSettlementType.spayAccount)
                                ? _buildSpayAccountWidget()
                                : _buildBankAccountWidget(),
                          ],
                        ))
                  ],
                ),
              )),
    );
  }

  Padding _buildSpayAccountWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formSpayAccount,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Available Aeps Balance"),
                Text(
                  "₹ ${controller.aepsBalance!.balance.toString()}",
                  style: Get.textTheme.headline3?.copyWith(color: Colors.green),
                ),
                AmountTextField(controller: controller.amountController),
                AppTextField(
                  controller: controller.remarkController,
                  label: "Remark",
                  validator: FormValidatorHelper.normalValidation,
                ),
                const SizedBox(
                  height: 16,
                ),
                AppButton(
                    text: "Proceed",
                    onClick: () => controller.onSpayAccountSettlement())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBankAccountWidget() {
    return ObsResourceWidget(
        obs: controller.bankResponseObs,
        childBuilder: (data) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formBankAccount,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Available Aeps Balance"),
                      Text(
                        "₹ ${controller.aepsBalance!.balance.toString()}",
                        style: Get.textTheme.headline3
                            ?.copyWith(color: Colors.green),
                      ),
                      AmountTextField(controller: controller.amountController),
                      AppDropDown(
                        list: List.from(
                            controller.bankList!.map((e) => e.bankName)),
                        onChange: (value) {
                          try {
                            controller.selectedBank = controller.bankList!
                                .firstWhere(
                                    (element) => element.bankName == value);
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
                        controller: controller.remarkController,
                        label: "Remark",
                        validator: FormValidatorHelper.normalValidation,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(
                          text: "Proceed",
                          onClick: () => controller.onBankSettlement())
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Padding _buildTransferToWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Transfer Balance To",
                style: Get.textTheme.subtitle1,
              ),
              const SizedBox(
                height: 8,
              ),
              Obx(() => Row(
                    children: [
                      Expanded(
                          child: AppRadioButton(
                        value: AepsSettlementType.spayAccount,
                        onChange: controller.onActionTypeChange,
                        title: "Spay Account",
                        groupValue: controller.actionType.value,
                      )),
                      Expanded(
                          child: AppRadioButton(
                        value: AepsSettlementType.bankAccount,
                        onChange: controller.onActionTypeChange,
                        title: "Bank Account",
                        groupValue: controller.actionType.value,
                      ))
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

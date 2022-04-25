import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/api_component.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/common/amount_background.dart';
import 'package:spayindia/widget/common/wallet_widget.dart';
import 'package:spayindia/widget/drop_down.dart';
import 'package:spayindia/widget/image.dart';
import 'package:spayindia/widget/text_field.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/recharge/provider/provider_controller.dart';
import 'package:spayindia/page/recharge/recharge/recharge_controller.dart';
import 'package:spayindia/util/validator.dart';

class RechargePage extends GetView<RechargeController> {
  const RechargePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeController());
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.providerName + " Recharge"),
      ),
      body:
          Obx(() => controller.circleResponseObs.value.when(onSuccess: (data) {
                return _buildBody();
              }, onFailure: (e) {
                return ExceptionPage(error: e);
              }, onInit: (data) {
                return ApiProgress(data);
              })),
    );
  }

  Column _buildBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildTopSection(),
                          const SizedBox(
                            height: 16,
                          ),
                          _buildRechargeFormKey(),
                        ],
                      ),
                    ),
                  ),
                  const WalletWidget()
                ],
              ),
            ),
          ),
        ),
        AppButton(
          text: "Proceed",
          onClick: controller.onProceed,
        )
      ],
    );
  }

  _buildTopSection() {
    return Row(
      children: [
        AppCircleAssetSvg(
            "assets/svg/${getProviderInfo(controller.providerType)?.imageName}.svg"),
        Expanded(
          child: Text(
            controller.provider.name,
            style:
                Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  _buildRechargeFormKey() {
    return Form(
      key: controller.rechargeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppDropDown(
            list: controller.circleList.map((e) => e.name).toList(),
            onChange: (value) {
              controller.circle = controller.circleList
                  .firstWhere((element) => element.name == value);
            },
            validator: FormValidatorHelper.normalValidation,
            label: "Circle",
            hint: "Select Circle",
          ),
          AppTextField(
            hint: "Enter Number",
            label: controller.getNumberLabel(),
            maxLength: controller.getMaxLength(),
            inputType: TextInputType.number,
            validator: (value) => controller.numberValidation(value),
            inputFormatters: AppTextField.numberOnly,
            controller: controller.numberController,
          ),
          MPinTextField(controller: controller.mpinController),
          const SizedBox(
            height: 12,
          ),
          AmountBackgroundWidget(
              child: AmountTextField(
                  validator: (value) => FormValidatorHelper.amount(value),
                  controller: controller.amountController)),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

}


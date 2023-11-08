import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/model/investment/inventment_balance.dart';
import 'package:ebazaar/page/investment/component/balance.dart';
import 'package:ebazaar/page/investment/create/create_investment_controller.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/util/obx_widget.dart';
import 'package:ebazaar/widget/check_box.dart';
import 'package:ebazaar/widget/drop_down.dart';
import 'package:ebazaar/widget/text_field.dart';

class CreateInvestmentPage extends GetView<CreateInvestmentController> {
  const CreateInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreateInvestmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Investment"),
      ),
      body: ObsResourceWidget<InvestmentBalanceResponse>(
          obs: controller.responseObs,
          childBuilder: (data) {
            controller.balance = data;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InvestmentBalanceWidget(
                      data,
                      addPanCallback: () {
                        controller.checkPanDetail();
                      },
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              AmountTextField(
                                  controller: controller.amountController),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: AppTextField(
                                        label: "Tenure Duration",
                                        controller: controller.tenureController,
                                        inputType: TextInputType.number,
                                      )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: AppDropDown(
                                          hideLabel: false,
                                          label: "Type",
                                          selectedItem: "Days",
                                          list: const [
                                            "Days",
                                            "Month",
                                            "Year"
                                          ],
                                          onChange: (value) {
                                            controller.tenureType = value;
                                          }))
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: AppCheckBox(
                                    value: false,
                                    onChange: (value) {
                                      controller.isAgree = value;
                                    },
                                    title:
                                        "I Agree To Use My KYC Details With This Investment."),
                              ),
                              SizedBox(
                                width: 140,
                                height: 42,
                                child: ElevatedButton(
                                    onPressed: () {
                                      controller.onSubmit();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.green),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.done),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Continue")
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

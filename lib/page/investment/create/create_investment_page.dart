import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:spayindia/page/investment/component/balance.dart';
import 'package:spayindia/page/investment/create/create_investment_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/security/app_config.dart';
import 'package:spayindia/widget/check_box.dart';
import 'package:spayindia/widget/drop_down.dart';
import 'package:spayindia/widget/text_field.dart';

class CreateInvestmentPage extends GetView<CreateInvestmentController> {
  const CreateInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreateInvestmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Investment"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InvestmentBalanceWidget(),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        AmountTextField(
                            controller: controller.amountController),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                                flex: 4,
                                child: AppTextField(
                                  label: "Tenure Duration",
                                  controller: controller.amountController,
                                  inputType: TextInputType.number,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 4,
                                child: AppDropDown(
                                    hideLabel: false,
                                    label: "Type",
                                    selectedItem: "Days",
                                    list: ["Days", "Months", "Years"],
                                    onChange: (vlalue) {}))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: AppCheckBox(
                              value: false,
                              onChange: (value) {},
                              title:
                                  "I Agree To Use My KYC Details With This Investment."),
                        ),
                        SizedBox(
                          width: 140,
                          height: 42,
                          child: ElevatedButton(
                              onPressed: (){
                                Get.toNamed(AppRoute.reviewInvestmentPage);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green
                              ),
                              child: Row(children: [
                            Icon(Icons.done),
                            SizedBox(width: 5,),
                            Text("Continue")
                          ],)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

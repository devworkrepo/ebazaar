import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:spayindia/page/investment/component/balance.dart';
import 'package:spayindia/page/investment/create/create_investment_controller.dart';
import 'package:spayindia/page/investment/review/review_investment_controller.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/security/app_config.dart';
import 'package:spayindia/widget/check_box.dart';
import 'package:spayindia/widget/drop_down.dart';
import 'package:spayindia/widget/text_field.dart';

class ReviewInvestmentPage extends GetView<ReviewInvestmentController> {
  const ReviewInvestmentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ReviewInvestmentController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Review And Confirm"),
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
                        Row(
                          children: const [
                            Expanded(
                              child: _TitleValue(
                                title: "Amount",
                                value: AppConstant.rupeeSymbol + "10000",
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Tenure Duration",
                                value: "1 Year",
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 8,),
                        Divider(indent: 0,),
                        SizedBox(height: 8,),
                        Row(
                          children: const [
                            Expanded(
                              child: _TitleValue(
                                title: "Interest Rate",
                                value: "12%",
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Total Interest Amt.",
                                value: AppConstant.rupeeSymbol+"100000",
                              ),
                            ),

                          ],
                        ),
                        Divider(indent: 0,),
                        SizedBox(height: 8,),
                        Row(
                          children: const [
                            Expanded(
                              child: _TitleValue(
                                title: "Maturity date",
                                value: "12/12/1998",
                              ),
                            ),

                            Expanded(
                              child: _TitleValue(
                                title: "Maturity Amount",
                                value: AppConstant.rupeeSymbol+"100000",
                                color: Colors.green,
                                fontSize: 22,
                              ),
                            ),

                          ],
                        ),
                        Divider(indent: 0,),
                        SizedBox(height: 16,),

                        MPinTextField(

                            label: "MPIN",
                            controller: controller.pinController),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 42,
                          child: ElevatedButton(
                              onPressed: (){

                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green
                              ),
                              child: Row(children: [
                                Icon(Icons.done),
                                SizedBox(width: 5,),
                                Text("Submit")
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


class _TitleValue extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final int fontSize;
  const _TitleValue({required this.title, required this.value, this.color = Colors.black87,
    this.fontSize = 14,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Text(title,style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),),
        Text(value,style: Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold,
        color: color,fontSize: fontSize.toDouble()),),
      ],
    );
  }
}

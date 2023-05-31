import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/investment/detail/investment_detail_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';

class InvestmentDetailPage extends GetView<InvestmentDetailController> {
  const InvestmentDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(InvestmentDetailController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Investment Detail"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Status  :  ",
                    style: Get.textTheme.subtitle1,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(4)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Open",
                            style: TextStyle(
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.green[700],
                            size: 20,
                          )
                        ],
                      )),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              _BuildItem(
                  title: "Opening date",
                  value: controller.item.addeddate.toString()),
              _BuildItem(
                  title: "Closed date", value: controller.isClosed.toString()),
              _BuildItem(
                  title: "Closed Type",
                  value: controller.item.closedtype.toString()),
              _BuildItem(
                  title: "Completion date",
                  value: controller.item.completedate.toString()),
              _BuildItem(
                  title: "Investment Ref No.",
                  value: controller.item.fd_refno.toString()),
              _BuildItem(
                  title: "Pan No.", value: controller.item.pan_no.toString()),
              _BuildItem(
                  title: "Amount",
                  value: AppConstant.rupeeSymbol +
                      controller.item.amount.toString()),
              _BuildItem(
                  title: "Tenure",
                  value: controller.item.tenure_value.toString() +
                      " " +
                      controller.item.tenure_type.toString()),
              _BuildItem(
                  title: "Int. Rate",
                  value: controller.item.int_rate.toString()),
              _BuildItem(
                  title: "Current Amount",
                  value: AppConstant.rupeeSymbol +
                      controller.item.current_amount.toString()),
              _BuildItem(
                  title: "Maturity Amount",
                  value: AppConstant.rupeeSymbol +
                      controller.item.mature_amount.toString()),
              _BuildItem(
                  title: "Message",
                  value: controller.item.trans_response.toString()),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.toNamed(AppRoute.investmentStatementPage);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(
                          width: 4,
                        ),
                        Text("Statement")
                      ],
                    ),
                  ),
                  Spacer(),
                  if (controller.item.isclosebtn
                          .toString()
                          .trim()
                          .toLowerCase() ==
                      "true")
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(primary: Colors.red),
                        onPressed: () {
                          controller.fetchCloseCalc();
                          // Get.toNamed(AppRoute.investmentBankListPage);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cancel_outlined),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Close Investment")
                          ],
                        )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final String value;

  const _BuildItem({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: Get.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  )),
              Text("  :  "),
              Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: Get.textTheme.subtitle2?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ),
        Divider(
          indent: 0,
          color: Colors.grey[300],
        )
      ],
    );
  }
}

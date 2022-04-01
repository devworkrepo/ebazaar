import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/transaction_page.dart';

import 'bill_payment_txn_response_controller.dart';

// ignore: must_be_immutable
class BillPaymentTxnResponsePage extends GetView<BillPaymentTxnResponseController>
    with TransactionPageComponent {
  BillPaymentTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BillPaymentTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(controller.response.transactionStatus ?? "Pending")),
          buildStatusTitle(getStatusIdFromString(controller.response.transactionStatus ?? "Pending"),
              statusDescription: controller.response.transactionStatus),
          buildMessage(controller.response.message ?? ""),
          buildTransactionTime(controller.response.transactionDate ?? ""),
          buildProviderAndAmount(
              title: (controller.response.billType ?? "").toUpperCase(),
              subTitle: controller.response.billerName ?? "",
              amount: controller.response.amount,
              imageSvgPath: controller.getSvgImage()),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Mobile Number",
                value: controller.response.customerMobile ?? ""),
            buildTitleValueWidget(
                title: "Name",
                value: controller.response.name ?? ""),

            buildTitleValueWidget(
                title: "Operator Name",
                value: controller.response.operatorName ?? ""),
            buildTitleValueWidget(
                title: "Operator Ref No",
                value: controller.response.operatorRefNumber ?? ""),
            buildTitleValueWidget(
                title: "Transaction No",
                value: controller.response.transactionNumber ?? ""),
          ], topBottom: true),

          appLogo(),
        ],
      ),
      status: getStatusIdFromString(controller.response.transactionStatus ?? "Pending"),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}

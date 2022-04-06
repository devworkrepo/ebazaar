import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/transaction_page.dart';

import 'recharge_txn_response_controller.dart';

// ignore: must_be_immutable
class RechargeTxnResponsePage extends GetView<RechargeTxnResponseController>
    with TransactionPageComponent {
  RechargeTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(controller.response.transactionStatus ?? "Pending")),
          buildStatusTitle(getStatusIdFromString(controller.response.transactionStatus ?? "Pending"),
              statusDescription: controller.response.transactionStatus),
          buildMessage(controller.response.transactionResponse ?? ""),
          buildTransactionTime(""),
          buildProviderAndAmount(
              title: controller.response.rechargeType ?? "",
              subTitle: controller.getTitle(),
              amount: controller.response.amount,
              imageSvgPath: controller.getSvgImage()),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Mobile Number",
                value: controller.response.mobileNumber ?? ""),
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

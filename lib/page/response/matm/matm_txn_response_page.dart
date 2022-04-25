import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/transaction_page.dart';

import 'matm_txn_response_controller.dart';

// ignore: must_be_immutable
class MatmTxnResponsePage extends GetView<MatmTxnResponseController>
    with TransactionPageComponent {
  MatmTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MatmTxnResponseController());

    return baseTxnResponseWidget(
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(controller.getStatus())),
          buildStatusTitle(getStatusIdFromString(controller.getStatus()),),
          buildMessage(controller.response.message),
          buildTransactionTime(controller.response.time),
          buildProviderAndAmount(
              title: controller.getTxnType(),
              subTitle: "Micro Atm",
              amount: controller.response.transAmount.toString(),
              imageSvgPath: "assets/svg/matm.svg"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Available Balance",
                value: controller.response.balAmount.toString()),
            buildTitleValueWidget(
                title: "Bank RRN", value: controller.response.bankRrn),
            buildTitleValueWidget(
                title: "Bank Name", value: controller.response.bankName),
            buildTitleValueWidget(
                title: "Card Number", value: controller.response.cardNumber),
          ], topBottom: true),
          appLogo(),
        ],
      ),
      status: getStatusIdFromString(
          controller.getStatus()),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/aeps/aeps_tramo/aeps_page.dart';
import 'package:spayindia/widget/transaction_page.dart';

import 'aeps_txn_response_controller.dart';

// ignore: must_be_immutable
class AepsTxnResponsePage extends GetView<AepsTxnResponseController> with TransactionPageComponent {
  AepsTxnResponsePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsTxnResponseController());

    var goBack = false;
    goBack = controller.aepsTransactionType == AepsTransactionType.balanceEnquiry;

    if(controller.aepsTransactionType == AepsTransactionType.cashWithdrawal){
      var status =  getStatusIdFromString(controller.response.transactionStatus ?? "Pending");
      if(status == 2){
        goBack = true;
      }
    }

    return baseTxnResponseWidget(
      goBack: goBack,
      child: screenshotHelperWidget(
        screenshotController: controller.screenshotController,
        children: [
          buildStatusIcon(getStatusIdFromString(
              controller.response.transactionStatus ?? "Pending")),
          buildStatusTitle(
              getStatusIdFromString(
                  controller.response.transactionStatus ?? "Pending"),
              statusDescription: controller.response.transactionStatus),
          buildMessage(controller.response.transactionResponse ?? ""),
          buildTransactionTime(""),
          buildProviderAndAmount(
              title: controller.getTitle(),
              subTitle: controller.getSubTitle(),
              amount: controller.response.amount,
              imageSvgPath: "assets/svg/aeps.svg"),
          dividerListContainer(children: [
            buildTitleValueWidget(
                title: "Available Balance",
                value: controller.response.availableBalance ?? ""),
            buildTitleValueWidget(
                title: "Bank RRN",
                value: controller.response.rrnNumber ?? ""),

          ], topBottom: true),
          appLogo(),
        ],
      ),
      status: getStatusIdFromString(
          controller.response.transactionStatus ?? "Pending"),
      onShareClick: () => controller.captureAndShare(),
    );
  }
}

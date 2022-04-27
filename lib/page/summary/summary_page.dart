import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/summary/summary_controller.dart';
import 'package:spayindia/util/obx_widget.dart';

class SummaryPage extends GetView<SummaryController> {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SummaryController());
    return SafeArea(
      child: Scaffold(
        body: ObsResourceWidget(
            obs: controller.responseObs,
            childBuilder: (data) => SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildAppbarWidget(),
                      const _BuildTopSectionWidget(),
                      const _BuildMiddleSectionWidget(),
                      const _BuildButtomSectionWidget(),
                    ],
                  ),
                )),
      ),
    );
  }

  Padding _buildAppbarWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
          RichText(
              text: TextSpan(
                  text: "Summary",
                  style: Get.textTheme.headline3?.copyWith(
                      color: Get.theme.primaryColorDark,
                      fontSize: 32,
                      fontWeight: FontWeight.w500),
                  children: [
                TextSpan(
                    text: "\nTransaction",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]))
              ])),
        ],
      ),
    );
  }
}

class _BuildButtomSectionWidget extends GetView<SummaryController> {
  const _BuildButtomSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: Get.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOtherInProgressWidget(
                  onClick: controller.onAepsInProgressClick,
                    text1: "Aeps InProgress Transaction",
                    text2: controller.summary.aepsInProgress.toString()),
                SizedBox(
                  height: 16,
                ),
                _buildOtherInProgressWidget(
                    onClick: controller.onAadhaarPayInProgressClick,
                    text1: "Aadhaar Pay InProgress Transaction",
                    text2: controller.summary.aadhaarPayInProgress.toString()),
                SizedBox(
                  height: 16,
                ),
                _buildOtherInProgressWidget(
                    onClick: controller.onPayoutInProgressClick,
                    text1: "Payout InProgress Transaction",
                    text2: controller.summary.payoutInProgress.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherInProgressWidget(
      {required String text1, required String text2,required VoidCallback onClick}) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(
              text1,
              style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              text2,
              style: Get.textTheme.headline3?.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildMiddleSectionWidget extends GetView<SummaryController> {
  const _BuildMiddleSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "DMT Transactions",
                style: Get.textTheme.subtitle1,
              ),
              Row(
                children: [
                  Expanded(
                      child: _buildItemWidget(
                        onClick: controller.onDmtInProgressClick,
                          backgroundColor: Colors.blue,
                          text1: "InProgress",
                          text2: controller.summary.dmtInProgress.toString())),
                  Expanded(
                      child: _buildItemWidget(
                          onClick: controller.onDmtInRefundPendingClick,
                          backgroundColor: Colors.red,
                          text1: "Refund Pending",
                          text2:
                              controller.summary.dmtRefundPending.toString())),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Utility Transactions",
                style: Get.textTheme.subtitle1,
              ),
              Row(
                children: [
                  Expanded(
                      child: _buildItemWidget(
                          onClick: controller.onUtilityInProgressClick,
                          backgroundColor: Colors.blue,
                          text1: "InProgress",
                          text2:
                              controller.summary.utilityInProgress.toString())),
                  Expanded(
                      child: _buildItemWidget(
                          onClick: controller.onUtilityInRefundPendingClick,
                          backgroundColor: Colors.red,
                          text1: "Refund Pending",
                          text2: controller.summary.utilityRefundPending
                              .toString())),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                "Credit Transactions",
                style: Get.textTheme.subtitle1,
              ),
              Row(
                children: [
                  Expanded(
                      child: _buildItemWidget(
                          onClick: controller.onCreditCardInProgressClick,
                          backgroundColor: Colors.blue,
                          text1: "InProgress",
                          text2:
                              controller.summary.creditInProgress.toString())),
                  Expanded(
                      child: _buildItemWidget(
                          onClick: controller.onCreditCardInRefundPendingClick,
                          backgroundColor: Colors.red,
                          text1: "Refund Pending",
                          text2: controller.summary.creditRefundPending
                              .toString())),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(
      {required Color backgroundColor,
      required String text1,
      required String text2,
        required VoidCallback onClick
      }) {
    return GestureDetector(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: backgroundColor),
          child: Column(
            children: [
              Text(
                text1,
                style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                text2,
                style: Get.textTheme.subtitle1?.copyWith(color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildTopSectionWidget extends GetView<SummaryController> {
  const _BuildTopSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                      child: _buildItem(
                          backgroundColor: Colors.green,
                          text1: controller.summary.fundReceived.toString(),
                          text2: "Fund Received")),
                  Expanded(
                      child: _buildItem(
                          backgroundColor: Colors.purple,
                          text1: controller.summary.moneyTransfer.toString(),
                          text2: "Money\nTransfer")),
                ],
              ),
            ),
            IntrinsicHeight(
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            backgroundColor: Colors.yellow[900]!,
                            text1: controller.summary.utilityTRF.toString(),
                            text2: "Utility Paid")),
                    Expanded(
                        child: _buildItem(
                            backgroundColor: Colors.red,
                            text1: controller.summary.creditCardTRF.toString(),
                            text2: "Credit Card")),
                  ],
                ),
              ),
            ),
            IntrinsicHeight(
              child: Center(
                child: Row(
                  children: [
                    Expanded(
                        child: _buildItem(
                            backgroundColor: Colors.indigo,
                            text1: controller.summary.aepsMatmTRF.toString(),
                            text2: "Aeps / Matm")),
                    Expanded(
                        child: _buildItem(
                            backgroundColor: Colors.blue,
                            text1: controller.summary.aadhaarPayTRF.toString(),
                            text2: "Aadhaar Pay")),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      {required Color backgroundColor, required String text1, required text2}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text1,
            textAlign: TextAlign.center,
            style: Get.textTheme.headline3?.copyWith(color: Colors.white70),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            text2,
            textAlign: TextAlign.center,
            style: Get.textTheme.headline6?.copyWith(color: Colors.white),
          )
        ],
      ),
    );
  }
}

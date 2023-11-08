import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/model/report/dmt.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/page/report/receipt_print_mixin.dart';
import 'package:ebazaar/util/etns/on_string.dart';
import 'package:ebazaar/util/tags.dart';
import 'package:ebazaar/widget/api_component.dart';
import 'package:ebazaar/widget/list_component.dart';
import 'package:ebazaar/widget/no_data_found.dart';

import 'package:ebazaar/widget/common/report_action_button.dart';
import 'package:ebazaar/page/report/report_helper.dart';
import 'package:ebazaar/page/report/report_search.dart';
import '../../../test/test_summary_header.dart';
import '../widget/summary_header.dart';
import 'money_report_controller.dart';

class MoneyReportPage extends GetView<MoneyReportController> {
  final String controllerTag;
  final String origin;

  @override
  String? get tag => controllerTag;

  const MoneyReportPage(
      {Key? key, required this.controllerTag, required this.origin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MoneyReportController(controllerTag, origin), tag: controllerTag);

    return Scaffold(
        appBar: (origin == "summary")
            ? AppBar(
                title: Text((controllerTag == AppTag.moneyReportControllerTag
                    ? "DMT InProgress"
                    : "Payout InProgress")),
              )
            : null,
        body: Obx(
            () => controller.reportResponseObs.value.when(onSuccess: (data) {
                  if (data.code == 1) {
                    if (data.reports!.isEmpty) {
                      return const NoItemFoundWidget();
                    } else {
                      return _buildListBody();
                    }
                  } else {
                    return ExceptionPage(error: Exception(data.message));
                  }
                }, onFailure: (e) {
                  return ExceptionPage(error: e);
                }, onInit: (data) {
                  return ApiProgress(data);
                })),
        floatingActionButton: Obx((){


          return (controller.reportList.isEmpty) ? FloatingActionButton.extended(
              icon: const Icon(Icons.search),
              onPressed: () => _onSearch(),
              label: const Text("Search")) : const SizedBox();
        }));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: (origin != "summary") ? controller.searchStatus : null,
          inputFieldOneTile: "Transaction Number",
          onSubmit:
              (fromDate, toDate, searchInput, searchInputType, status, _, __) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            if (origin != "summary") {
              controller.searchStatus = status;
            }
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.reportList;
    var count = list.length+1;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2)
        ),
        color: Colors.white,
        margin: const EdgeInsets.only(
          bottom: 0,
          left: 4,
          right: 4,
          top: 4,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0, bottom: 100),
          itemBuilder: (context, index) {

            if(index == 0){
              return Obx((){
                var mData = controller.summaryReport.value!;
                return Column(
                  children: [
                    SummaryHeaderWidget(
                      summaryHeader1: [
                        SummaryHeader(title: "Total\nTransactions", value: "${mData.total_count}",isRupee: false),
                        SummaryHeader(title: "Total\nAmount", value: "${mData.total_amt}"),
                        SummaryHeader(title: "Charges\nPaid", value: "${mData.charges_paid}"),

                      ],
                      summaryHeader2: [
                        SummaryHeader(title: "Commission\nReceived", value: "${mData.comm_rec}"),
                        SummaryHeader(title: "Refund\nPending", value: "${mData.refund_pending}",isRupee: false),
                        SummaryHeader(title: "Refunded\nTransactions", value: "${mData.refunded}",isRupee: false),
                      ],
                      callback: (){
                        _onSearch();
                      },
                    ),
                    const SizedBox(height: 12,)
                  ],
                );
              });
            }
            return _BuildListItem(
              list[index-1],
              controller: controller,
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final MoneyReport report;
  final MoneyReportController controller;

  const _BuildListItem(this.report, {Key? key, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        txnNumber: report.transactionNumber,
        isExpanded: report.isExpanded,
        title: "A/C    : " + report.accountNumber.orNA(),
        subTitle: "Bank  : " + report.bankName.orNA(),
        date: "Date : " + report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2: (controller.origin == "summary")
            ? _requeryButton(Get.theme.primaryColorDark, Colors.white)
            : null,
        expandList: [
          ListTitleValue(
              title: "Remitter Number", value: report.senderNubber.toString()),
          ListTitleValue(
              title: "Txn Number", value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Beneficiary Name",
              value: report.beneficiaryName.toString()),
          ListTitleValue(title: "IFSC Code", value: report.ifscCode.toString()),
          ListTitleValue(
              title: "Account Number", value: report.accountNumber.toString()),
          ListTitleValue(
              title: "Transaction Type",
              value: report.transactionType.toString()),
          ListTitleValue(
              title: "Commission", value: report.commission.toString()),
          ListTitleValue(title: "Charge", value: report.charge.toString()),
          ListTitleValue(
              title: "UTR Number", value: report.utrNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionMessage.toString()),
        ],
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _requeryButton(Colors.white, Colors.black),
            const SizedBox(
              width: 8,
            ),
            ReportActionButton(
              title: "Print",
              icon: Icons.print,
              onClick: () {
                if (controller.tag == AppTag.moneyReportControllerTag) {
                  controller.printReceipt(
                      (report.calcId ?? ""), ReceiptType.money);
                } else {
                  controller.printReceipt(
                      (report.calcId ?? ""), ReceiptType.payout);
                }
              },
            ),
            const SizedBox(
              width: 8,
            ),
            ReportActionButton(
              title: "Complaint",
              icon: Icons.messenger_outline,
              onClick: () {
                controller.postNewComplaint({
                  "transactionNumber" : report.transactionNumber.toString(),
                  "type" : "Money Transfer"
                });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _requeryButton(Color background, Color color) {
    return (report.transactionStatus!.toLowerCase() == "inprogress" ||
            kDebugMode)
        ? ReportActionButton(
            title: "Re-query",
            icon: Icons.refresh,
            onClick: () {
              controller.requeryTransaction(report);
            },
            color: color,
            background: background,
          )
        : const SizedBox();
  }
}

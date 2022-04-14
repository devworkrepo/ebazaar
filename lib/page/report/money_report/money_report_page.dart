import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/report/receipt_print_mixin.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/tags.dart';

import '../../../component/common/report_action_button.dart';
import '../report_helper.dart';
import '../report_search.dart';
import 'money_report_controller.dart';

class MoneyReportPage extends GetView<MoneyReportController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  const MoneyReportPage({Key? key, required this.controllerTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MoneyReportController(controllerTag), tag: controllerTag);
    return Scaffold(
        body: Obx(() =>
            controller.reportResponseObs.value.when(onSuccess: (data) {
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
        floatingActionButton: FloatingActionButton.extended(
            icon: const Icon(Icons.search),
            onPressed: () => _onSearch(),
            label: const Text("Search"))
    );
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSeasrchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: controller.searchStatus,
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,_) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.searchStatus = status;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {

    var list = controller.reportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        color:Colors.white,
        margin: const EdgeInsets.only(bottom: 8,left: 8,right: 8,top: 8,),
        child: ListView.builder(padding: const EdgeInsets.only(top: 0,bottom: 100),itemBuilder: (context, index) {
          return _BuildListItem(list[index],controller: controller,);
        },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends StatelessWidget {
  final MoneyReport report;
  final MoneyReportController controller;

  const _BuildListItem(this.report, {Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title: "A/C    : " + report.accountNumber.orNA(),
        subTitle: "Bank  : " + report.bankName.orNA(),
        date: "Date : " + report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        expandList: [
          ListTitleValue(
              title: "Remitter Number", value: report.senderNubber.toString()),
          ListTitleValue(
              title: "Txn Number", value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Beneficiary Name",
              value: report.beneficiaryName.toString()),
          ListTitleValue(
              title: "Account Number", value: report.accountNumber.toString()),
          ListTitleValue(
              title: "Transaction Type",
              value: report.transactionType.toString()),
          ListTitleValue(
              title: "Commission", value: report.commission.toString()),
          ListTitleValue(
              title: "UTR Number", value: report.utrNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionMessage.toString()),
        ],
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          (report.transactionStatus!.toLowerCase() == "inprogress" || kDebugMode)
              ? ReportActionButton(
            title: "Re-query",
            icon: Icons.refresh,
            onClick: () {
              controller.requeryTransaction(report);
            },
          )
              : const SizedBox(),
          const SizedBox(width: 8,),
          ReportActionButton(
            title: "Print",
            icon: Icons.print,
            onClick: () {
              if(controller.tag == AppTag.moneyReportControllerTag){
                controller.printReceipt((report.calcId ?? ""),ReceiptType.money);
              }
              else{
                controller.printReceipt((report.calcId ?? ""),ReceiptType.payout);
              }
            },
          )
        ],),
      ),
    );
  }


}

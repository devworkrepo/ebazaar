import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/api_component.dart';
import 'package:spayindia/widget/common.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/widget/list_component.dart';
import 'package:spayindia/widget/no_data_found.dart';
import 'package:spayindia/model/report/recharge.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';

import '../../../widget/common/report_action_button.dart';
import '../receipt_print_mixin.dart';
import '../report_helper.dart';
import '../report_search.dart';
import 'recharge_report_controller.dart';

class RechargeReportPage extends GetView<RechargeReportController> {

  final String origin;

  const RechargeReportPage({required this.origin,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeReportController(origin));

    return Scaffold(
        appBar: (origin == "summary") ? AppBar(
          title: const Text("Utility InProgress"),
        ): null,
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
          status: (origin != "summary") ? controller.searchStatus : null,
          inputFieldOneTile: "Request Number",
          statusList: const [
            "Success",
            "InProgress",
            "Initiated",
            "Failed",
            "Refund Pending",
            "Refunded",
          ],
          typeList: const [
            "Prepaid",
            "DTH",
            "Mobile Postpaid",
            "Landline Postpaid",
            "Electricity",
            "GAS",
            "Water",
            "CMS",
            "Insurance",
            "Loan",
            "Fastag",
            "Education",
            "Entertainment",
            "Cable",
            "Broadband Postpaid",
            "LPG GAS",
            "Municipal Taxes",
            "Housing Society",
            "Municipal Services",
            "Hospital",
            "Subscription"],
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,rechargeType) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            if(origin != "summary"){
              controller.searchStatus = status;
            }
            controller.rechargeType = rechargeType;
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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index],);
          },itemCount: count,),
      ),
    );
  }
}


class _BuildListItem extends GetView<RechargeReportController> {
  final RechargeReport report;


  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title:""+ report.mobileNumber.orNA(),
        subTitle: report.rechargeType.orNA().toUpperCase(),
        date: "Date : "+report.transactionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.transactionStatus),
        expandList: [
          ListTitleValue(
              title: "Operator Name", value: report.operatorName.toString()),
          ListTitleValue(title: "Pay Id", value: report.payId.toString()),
          ListTitleValue(
              title: "Ref Mobile No", value: report.refMobileNumber.toString()),
          ListTitleValue(
              title: "Operator Ref",
              value: report.operatorRefNumber.toString()),
          ListTitleValue(
              title: "Message", value: report.transactionResponse.toString()),
        ],
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReportActionButton(
              title: "Print",
              icon: Icons.print,
              onClick: () {
                controller.printReceipt(
                    (report.transactionNumber ?? ""), ReceiptType.recharge);
              },
            )
          ],
        ),
      ),
    );
  }


}

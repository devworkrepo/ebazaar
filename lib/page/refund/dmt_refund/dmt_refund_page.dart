import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/tags.dart';
import 'package:spayindia/widget/api_component.dart';
import 'package:spayindia/widget/common/report_action_button.dart';
import 'package:spayindia/widget/list_component.dart';
import 'package:spayindia/widget/no_data_found.dart';

import '../../../model/refund/dmt_refund.dart';
import '../../report/report_helper.dart';
import '../../report/report_search.dart';

class DmtRefundPage extends GetView<DmtRefundController> {
  final String controllerTag;
  final String origin;

  const DmtRefundPage(
      {Key? key, required this.controllerTag, required this.origin})
      : super(key: key);

  @override
  String? get tag => controllerTag;

  @override
  Widget build(BuildContext context) {
    Get.put(DmtRefundController(controllerTag,), tag: controllerTag);

    return Scaffold(
        appBar: (origin == "summary") ? AppBar(
          title:  Text(
                    controllerTag == AppTag.payoutRefundControllerTag
                        ? "Payout Refund Pending"
                        : "DMT Refund Pending"),
              ): null,
        body: Obx(() =>
            controller.moneyReportResponseObs.value.when(onSuccess: (data) {
              if (data.code == 1) {
                if (data.list!.isEmpty) {
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
            label: const Text("Search")));
  }

  _onSearch() {
    Get.bottomSheet(
        CommonReportSearchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,_,__) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
            controller.searchInput = searchInput;
            controller.onSearch();
          },
        ),
        isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {
    var list = controller.moneyReportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(
          bottom: 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index], controller,origin);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final DmtRefund report;
  final DmtRefundController controller;
  final String origin;

  const _BuildListItem(this.report, this.controller,this.origin, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title: "" + report.accountNumber.orNA(),
        subTitle: report.beneficiaryName.orNA(),
        date: "Date : " + report.transactionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        actionWidget2:(origin == "summary") ? _refundButton(
            Get.theme.primaryColorDark,Colors.white
        ) : null,
        expandList: [
          ListTitleValue(
              title: "Remitter Number", value: report.senderNumber.toString()),
          ListTitleValue(
              title: "Transaction No.",
              value: report.transactionNumber.toString()),
          ListTitleValue(
              title: "Beneficary Name",
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
        actionWidget: _refundButton(Colors.white, Colors.black),
      ),
    );
  }

  ReportActionButton _refundButton(Color background, Color color) {
    return ReportActionButton(
      title: "Take Refund",
      icon: Icons.keyboard_return,
      background: background,
      color: color,
      onClick: (){
        Get.bottomSheet(RefundBottomSheetDialog(
          onProceed: (value){
            controller.takeDmtRefund(value,report);
          },
        ),isScrollControlled: true);
      },);
  }
}

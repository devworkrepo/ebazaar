import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/tags.dart';

import '../../../model/report/aeps.dart';
import '../report_helper.dart';
import '../report_search.dart';
import 'aeps_matm_report_controller.dart';

class AepsMatmReportPage extends GetView<AepsMatmReportController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  const AepsMatmReportPage({Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsMatmReportController(controllerTag), tag: controllerTag);
    return Scaffold(
        body: Obx(
            () => controller.reportResponseObs.value.when(onSuccess: (data) {
                  if (data.code == 1) {
                    if (data.reportList!.isEmpty) {
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
        CommonReportSeasrchDialog(
          fromDate: controller.fromDate,
          toDate: controller.toDate,
          status: controller.searchStatus,
          inputFieldOneTile: "Transaction Number",
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status) {
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
        color: Colors.white,
        margin: const EdgeInsets.only(
          bottom: 8,
          left: 8,
          right: 8,
          top: 8,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index], controller);
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends StatelessWidget {
  final AepsMatmReportController controller;
  final AepsReport report;

  const _BuildListItem(this.report, this.controller, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title: (controller.tag == AppTag.aepsReportControllerTag)
            ? report.aadhaarNumber.orNA()
            : report.mobileNumber.orNA(),
        subTitle: report.transactionType.orNA().toUpperCase() == "CW"
            ? "Cash Withdrawal"
            : "Balance Enquiry",
        date: "Date : " + report.transctionDate.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId: ReportHelperWidget.getStatusId(report.transactionStatus),
        expandList: _titleValueWidget(),
      ),
    );
  }

  List<ListTitleValue> _titleValueWidget() {
    List<ListTitleValue> widgetList = [
      ListTitleValue(title: "Bank Name", value: report.bankName.toString()),
      ListTitleValue(
          title: "Transaction Id", value: report.transactionId.toString()),
      ListTitleValue(title: "Rrn Number", value: report.rrn.toString()),
      ListTitleValue(title: "Commission", value: report.commission.toString()),
      ListTitleValue(
          title: "Message", value: report.transactionMessage.toString()),
    ];
    if (controller.tag == AppTag.aepsReportControllerTag) {
      widgetList.add(ListTitleValue(
          title: "Mobile Number", value: report.mobileNumber.toString()));
    }

    return widgetList;
  }
}

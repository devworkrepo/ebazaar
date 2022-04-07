import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/recharge.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/route_aware_widget.dart';
import 'package:spayindia/util/etns/on_string.dart';

import '../report_helper.dart';
import '../report_search.dart';
import 'recharge_report_controller.dart';

class RechargeReportPage extends GetView<RechargeReportController> {

  const RechargeReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RechargeReportController());
    return Scaffold(
        body: Obx(() =>
            controller.reportResponseObs.value.when(onSuccess: (data) {
              if (data.code == 1) {
                if (data.rechargeReport!.isEmpty) {
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
          inputFieldOneTile: "Request Number",
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
        color:Colors.white,
        margin: const EdgeInsets.only(bottom: 8,left: 8,right: 8,top: 8,),
        child: ListView.builder(padding: const EdgeInsets.only(top: 0),itemBuilder: (context, index) {
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
          ListTitleValue(title: "Operator Name", value: report.operatorName.toString()),
          ListTitleValue(title: "Pay Id", value: report.payId.toString()),
          ListTitleValue(title: "Ref Mobile No", value: report.refMobileNumber.toString()),
          ListTitleValue(title: "Operator Ref", value: report.operatorRefNumber.toString()),
          ListTitleValue(title: "Message", value: report.transactionResponse.toString()),

        ],
     ),
    );
  }


}

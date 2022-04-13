import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';

import '../../../model/report/wallet.dart';
import '../report_helper.dart';
import 'wallet_report_controller.dart';
import '../report_search.dart';

class WalletPayReportPage extends GetView<WalletPayReportController> {
  const WalletPayReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WalletPayReportController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Pay Report"),
      ),
      body: Obx(() =>
          controller.reportResponseObs.value.when(onSuccess: (data) {
            if (data.code == 1) {
              if(data.reports!.isEmpty){
                return const NoItemFoundWidget();
              }
              else {
               return  _buildListBody();
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
    Get.bottomSheet(CommonReportSeasrchDialog(
      fromDate: controller.fromDate,
      toDate: controller.toDate,
      onSubmit: (fromDate, toDate, searchInput,searchInputType, status,_) {
        controller.fromDate = fromDate;
        controller.toDate = toDate;
        controller.onSearch();
      },
    ),isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {

    var list = controller.reportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
          return _BuildListItem(list[index]);
        },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends GetView<WalletPayReportController> {
  final WalletPayReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title: "Received By : "+report.receivedBy.orNA(),
        subTitle:"Ref : "+ report.refNumber.orNA(),
        date: "Date : "+report.date.orNA(),
        amount: report.amount.toString(),
        status: report.payStatus.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.payStatus),


        expandList: [
          ListTitleValue(title: "Paid By", value: report.paidBy.toString()),
          ListTitleValue(title: "Message", value: report.payMessage.toString()),
          ListTitleValue(title: "Remark", value: report.remark.toString()),

        ],)
    );
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/model/report/ledger.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/route_aware_widget.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/hex_color.dart';

import '../report_helper.dart';
import 'mone_report_controller.dart';
import '../report_search.dart';

class MoneyReportPage extends GetView<MoneyReportController> {
  const MoneyReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(MoneyReportController());
    return RouteAwareWidget(
      didPush: (){
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          controller.fetchReport();
        });
      },
      child: Scaffold(
        body: Obx(() =>
            controller.moneyReportResponseObs.value.when(onSuccess: (data) {
              if (data.code == 1) {
                if(data.reports!.isEmpty){
                  return NoItemFoundWidget();
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
      ),
    );
  }

  _onSearch() {
    Get.bottomSheet(FundReportSearchDialog(
      fromDate: controller.fromDate,
      toDate: controller.toDate,
      status: controller.searchStatus,
      inputFieldOneTile : "Request Number",
      onSubmit: (fromDate, toDate, searchInput,searchInputType, status) {
        controller.fromDate = fromDate;
        controller.toDate = toDate;
        controller.searchInput = searchInput;
        controller.searchStatus = status;
        controller.onSearch();
      },
    ),isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {

    var list = controller.moneyReportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        color:Colors.white,
        margin: const EdgeInsets.only(bottom: 8,left: 8,right: 8,top: 8,),
        child: ListView.builder(padding: const EdgeInsets.only(top: 0),itemBuilder: (context, index) {
          return _BuildListItem(list[index]);
        },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends GetView<MoneyReportController> {
  final MoneyReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title:"A/C NO : "+ report.accountNumber.orNA(),
        subTitle: report.beneficiaryName.orNA(),
        date: "Date : "+report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.transactionStatus),


        expandList: [
          ListTitleValue(title: "Remitter Number", value: report.senderNubber.toString()),
          ListTitleValue(title: "Txn Number", value: report.transactionNumber.toString()),
          ListTitleValue(title: "Beneficary Name", value: report.beneficiaryName.toString()),
          ListTitleValue(title: "Account Number", value: report.accountNumber.toString()),
          ListTitleValue(title: "Transaction Type", value: report.transactionType.toString()),
          ListTitleValue(title: "Commission", value: report.commission.toString()),
          ListTitleValue(title: "UTR Number", value: report.utrNumber.toString()),
          ListTitleValue(title: "Message", value: report.transactionMessage.toString()),

        ],
     ),
    );
  }


}

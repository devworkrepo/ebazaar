import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/api_component.dart';
import 'package:spayindia/widget/list_component.dart';
import 'package:spayindia/widget/no_data_found.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';

import '../report_helper.dart';
import 'fund_report_controller.dart';
import '../report_search.dart';

class FundRequestReportPage extends GetView<FundRequestReportController> {
  const FundRequestReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FundRequestReportController());
    return Scaffold(
      appBar: AppBar(
        title:  Text((controller.isPendingRequest) ? "Fund Pending Report" : "Fund All Report"),
      ),
      body: Obx(() =>
          controller.fundRequestReportResponseObs.value.when(onSuccess: (data) {
            if (data.code == 1) {
              if(data.moneyList!.isEmpty){
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
    );
  }

  _onSearch() {
    Get.bottomSheet(CommonReportSearchDialog(
      fromDate: controller.fromDate,
      toDate: controller.toDate,
      status:(controller.isPendingRequest) ? null :  controller.searchStatus,
      statusList:(controller.isPendingRequest) ? null :  const [
        "Initiated",
        "Pending",
        "Accepted",
        "Approved",
        "Declined"
      ],
      inputFieldOneTile : "Request Number",
      onSubmit: (fromDate, toDate, searchInput,searchInputType, status,_,__) {
        controller.fromDate = fromDate;
        controller.toDate = toDate;
        controller.searchInput = searchInput;
       if(!controller.isPendingRequest){
         controller.searchStatus = status;
       }
        controller.onSearch();
      },
    ),isScrollControlled: true);
  }

  RefreshIndicator _buildListBody() {

    var list = controller.fundReportList;
    var count = list.length;

    return RefreshIndicator(
      onRefresh: () async {
        controller.swipeRefresh();
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: ListView.builder(
          padding: EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
          return _BuildListItem(list[index]);
        },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends GetView<FundRequestReportController> {
  final FundRequestReport report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title: report.bankAccountName.orNA(),
        subTitle:"Type : "+ report.type.orNA(),
        date: "Date : "+report.addedDate.orNA(),
        amount: report.amount.toString(),
        status: report.status.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.status),


        expandList: getExpandList(),
        actionWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          ((report.picName ?? "").isNotEmpty) ?
          Container(
            padding: EdgeInsets.only(top: 12),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: (){
                  controller.onViewReceipt(report);
                }, child:Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.remove_red_eye),
                SizedBox(width: 5,),
                Text("View Receipt")
              ],)),
          ) : SizedBox(),

          SizedBox(width: 8,),

          (report.status!.toLowerCase() == "pending" || kDebugMode) ?
          Container(
            padding: EdgeInsets.only(top: 12),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: (){
                  controller.onUpdateClick(report);
                }, child:Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.update),
                SizedBox(width: 5,),
                Text("Update")
              ],)),
          ) : SizedBox()
        ],)),


    );
  }

  List<ListTitleValue> getExpandList() {
    var mList = [
        ListTitleValue(title: "Deposit Date", value: report.depositeDate.toString()),
        ListTitleValue(title: "Ref Number", value: report.referenceNumber.toString()),
        ListTitleValue(title: "Remark", value: report.remark.toString()),
        ListTitleValue(title: "Request Number", value: report.requestNumber.toString()),
        ListTitleValue(title: "Modified Remark", value: report.modifiedRemark.toString()),

      ];
    if(report.status != "Initiated"){
      mList.add(ListTitleValue(title: "Modified Date", value: report.modifiedDate.toString()));
    }
    return mList;
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/report/credit_card.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';
import '../../../component/common/report_action_button.dart';
import '../report_helper.dart';
import '../report_search.dart';
import 'credit_card_report_controller.dart';

class CreditCardReportPage extends GetView<CreditCardReportController> {

  const CreditCardReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(CreditCardReportController());
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
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(list[index],);
          },itemCount: count,),
      ),
    );
  }
}



class _BuildListItem extends GetView<CreditCardReportController> {
  final CreditCardReport report;


  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: () => controller.onItemClick(report),
      child: AppExpandListWidget(
        isExpanded: report.isExpanded,
        title:"Card No  : "+ report.cardNumber.orNA(),
        subTitle:"Bank : "+ report.bankName.orNA().toUpperCase(),
        date: "Date : "+report.date.orNA(),
        amount: report.amount.toString(),
        status: report.transactionStatus.toString(),
        statusId:  ReportHelperWidget.getStatusId(report.transactionStatus),


        expandList: [
          ListTitleValue(title: "Name", value: report.cardHolderName.toString()),
          ListTitleValue(title: "Mobile Number", value: report.mobileNumber.toString()),
          ListTitleValue(title: "Card Type", value: report.cardType.toString()),
          ListTitleValue(title: "Txn Number", value: report.transactionNumber.toString()),
          ListTitleValue(title: "Utr Number", value: report.utrNumber.toString()),
          ListTitleValue(title: "IFSC Code", value: report.ifscCode.toString()),
          ListTitleValue(title: "Charge", value: report.charge.toString()),
          ListTitleValue(title: "Commission", value: report.commission.toString()),
          ListTitleValue(title: "Message", value: report.transactionMessage.toString()),

        ],
        actionWidget: (report.transactionStatus!.toLowerCase() == "inprogress")
            ? ReportActionButton(
          title: "Re-query",
          icon: Icons.refresh,
          onClick: () {
            controller.requeryTransaction(report);
          },
        )
            : SizedBox(),
      ),
    );
  }


}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/statement/account_statement.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';

import '../../report/report_search.dart';
import 'account_statement_controller.dart';

class AccountStatementPage extends GetView<AccountStatementController> {
  final String controllerTag;

  @override
  String? get tag => controllerTag;

  const AccountStatementPage({Key? key, required this.controllerTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AccountStatementController(controllerTag), tag: controllerTag);
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
          onSubmit: (fromDate, toDate, searchInput, searchInputType, status,_) {
            controller.fromDate = fromDate;
            controller.toDate = toDate;
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
        margin: const EdgeInsets.only(bottom: 8,left: 8,right: 8,top: 8,),
        color: Colors.white,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 0,bottom: 100),
          itemBuilder: (context, index) {
            return _BuildListItem(
              list[index],
            );
          },
          itemCount: count,
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<AccountStatementController> {
  final AccountStatement report;

  const _BuildListItem(this.report, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inAmount = double.parse(report.inAmount.toString());
    var outAmount = double.parse(report.outAmount.toString());
    var inCommission = double.parse(report.inCommission.toString());
    var outCommission = double.parse(report.outCommission.toString());
    var inTds = double.parse(report.inTds.toString());
    var outTds = double.parse(report.outTds.toString());
    var inCharge = double.parse(report.inCharge.toString());
    var outCharge = double.parse(report.outCharge.toString());

    var headerStyle = Get.textTheme.bodyText1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUpperSection(),
        const SizedBox(
          height: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  const Text("amount"),
                  Text(
                    inAmount > 0.0 ? inAmount.toString() : outAmount.toString(),
                    style: TextStyle(
                        color: (inAmount > 0) ? Colors.green : Colors.red,fontWeight: FontWeight.w500),
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Tds",
                    style: headerStyle,
                  ),
                  Text(inTds > 0.0 ? inTds.toString() : outTds.toString(),style: TextStyle(
                      color: (inTds > 0) ? Colors.green : Colors.red,fontWeight: FontWeight.w500))
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text("Charge", style: headerStyle),
                  Text(inCharge > 0.0
                      ? inCharge.toString()
                      : outCharge.toString(),style: TextStyle(
                      color: (inCharge > 0) ? Colors.green : Colors.red,fontWeight: FontWeight.w500))
                ],
              )),
              Expanded(
                  child: Column(
                children: [
                  Text("Commission", style: headerStyle),
                  Text(inCommission > 0.0
                      ? inCommission.toString()
                      : outCommission.toString(),style: TextStyle(
                      color: (inCommission > 0) ? Colors.green : Colors.red,fontWeight: FontWeight.w500))
                ],
                crossAxisAlignment: CrossAxisAlignment.end,
              ))
            ],
          ),
        ),
        const Divider(
          indent: 0,
        )
      ],
    );
  }

  Widget _buildUpperSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.date.toString()),
              Text(
                report.remark.orNA(),
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
          Expanded(
              child: Column(
            children: [
              Text(
                "Balance",
                style: Get.textTheme.bodyText1,
              ),
              Text(
                report.balance.toString(),
                style: Get.textTheme.headline6,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.end,
          ))
        ],
      ),
    );
  }
}

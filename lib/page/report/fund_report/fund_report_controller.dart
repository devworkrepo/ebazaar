import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

class FundRequestReportController extends GetxController {
  MoneyRequestRepo repo = Get.find<MoneyRequestImpl>();

  String origin = Get.arguments;

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var fundRequestReportResponseObs =
      Resource.onInit(data: FundRequestReportResponse()).obs;
  late List<FundRequestReport> fundReportList;
  FundRequestReport? previousReport;

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    _fetchReport();
  }

  _fetchReport() async {
    try {
      fundRequestReportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchReport({
        "fromdate": fromDate,
        "todate": toDate,
        "requestno": searchInput,
        "status": searchStatus,
      });
      if (response.code == 1) {
        fundReportList = response.moneyList!;
      }
      fundRequestReportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      fundRequestReportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    _fetchReport();
  }

  void onItemClick(FundRequestReport report) {
    if (previousReport == null) {
      report.isExpanded.value = true;
      previousReport = report;
    } else if (previousReport! == report) {
      report.isExpanded.value = !report.isExpanded.value;
      previousReport = null;
    } else {
      report.isExpanded.value = true;
      previousReport?.isExpanded.value = false;
      previousReport = report;
    }
  }

  void onSearch() {
    _fetchReport();
  }

  void onUpdateClick(FundRequestReport report) async {
    try {
      StatusDialog.progress();
      final response = await repo.fetchUpdateInfo({
        "requestid": report.requestId.toString(),
      });

      Get.back();

      if(response.code == 1){

        if(origin == "route"){
          Get.toNamed(AppRoute.fundRequestPage,arguments: response);
        }
        else{
          Get.back(result: response);
        }
      }
      else{
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }
}

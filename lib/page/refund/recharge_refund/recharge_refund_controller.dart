import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/refund/recharge.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

class RechargeRefundController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var reportResponseObs =
      Resource.onInit(data: RechargeRefundListResponse()).obs;
  late List<RechargeRefund> reports;
  RechargeRefund? previousReport;


  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  void takeRechargeRefund(String mPin, RechargeRefund report) async {
    StatusDialog.progress();
    var response = await repo.takeRechargeRefund({
      "transaction_no": report.transactionNumber ?? "",
      "mpin": mPin,
    });

    Get.back();
    if (response.code == 1) {
      StatusDialog.success(title: response.message)
          .then((value) => fetchReport());
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,

        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.rechargeRefundList(_param());
      if (response.code == 1) {
        reports = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchInput = "";
    fetchReport();
  }

  void onItemClick(RechargeRefund report) {
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
    fetchReport();
  }
}

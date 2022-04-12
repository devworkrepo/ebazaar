import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/refund/dmt_refund.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/tags.dart';

class DmtRefundController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  final String tag;

  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var moneyReportResponseObs =
      Resource.onInit(data: DmtRefundListResponse()).obs;
  late List<DmtRefund> moneyReportList;
  DmtRefund? previousReport;

  DmtRefundController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 30);
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  void takeDmtRefund(String mPin, DmtRefund report) async {
    StatusDialog.progress();
    var response = (tag == AppTag.moneyRefundControllerTag) ?
    await repo.takeDmtRefund({
      "transaction_no": report.transactionNumber ?? "",
      "mpin": mPin,
    }) : await repo.takePayoutRefund({
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
      moneyReportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.moneyRefundControllerTag)
          ? await repo.dmtRefundList(_param())
          : await repo.payoutRefundList(_param());
      if (response.code == 1) {
        moneyReportList = response.list!;
      }
      moneyReportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      moneyReportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 30);
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchInput = "";
    fetchReport();
  }

  void onItemClick(DmtRefund report) {
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

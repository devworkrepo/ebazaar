import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
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
  String searchStatus = "";
  String searchInput = "";

  var moneyReportResponseObs =
      Resource.onInit(data: DmtRefundListResponse()).obs;
  late List<DmtRefund> moneyReportList;
  DmtRefund? previousReport;

  DmtRefundController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "requestno": searchInput,
          "status": searchStatus,
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
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
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

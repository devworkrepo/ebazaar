import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/tags.dart';

import '../../../model/report/aeps.dart';

class AepsMatmReportController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: AepsReportResponse()).obs;
  late List<AepsReport> reportList;
  AepsReport? previousReport;

  final String tag;

  AepsMatmReportController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 7);
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "requestno": searchInput,
          "status": searchStatus,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.aepsReportControllerTag)
          ? await repo.fetchAepsTransactionList(_param())
          : await repo.fetchMatmTransactionList(_param());
      if (response.code == 1) {
        reportList = response.reportList!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 7);
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    fetchReport();
  }

  void onItemClick(AepsReport report) {
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

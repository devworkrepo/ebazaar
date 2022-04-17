import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/recharge.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class AccountStatementController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";

  var reportResponseObs = Resource
      .onInit(data: AccountStatementResponse())
      .obs;
  late List<AccountStatement> reportList;
  AccountStatement? previousReport;

  final String tag;

  AccountStatementController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 2);
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.accountStatementControllerTag)
          ? await repo.fetchAccountStatement(_param())
          : await repo.fetchAepsStatement(_param());
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
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 2);
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  void onItemClick(AccountStatement report) {
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

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/repo/report_repo.dart';
import 'package:ebazaar/data/repo_impl/report_impl.dart';
import 'package:ebazaar/model/report/dmt.dart';
import 'package:ebazaar/model/report/recharge.dart';
import 'package:ebazaar/model/statement/credit_debit_statement.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/date_util.dart';
import 'package:ebazaar/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class CreditDebitController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var reportResponseObs = Resource
      .onInit(data: CreditDebitStatementResponse())
      .obs;
  late List<CreditDebitStatement> reportList;
  CreditDebitStatement? previousReport;

  final String tag;

  CreditDebitController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "refno": searchInput,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.creditStatementControllerTag)
          ? await repo.fetchCreditStatement(_param())
          : await repo.fetchDebitStatement(_param());
      if (response.code == 1) {
        reportList = response.reportList!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd(dayBefore: (kDebugMode) ? 30 : null);
    searchInput = "";
    fetchReport();
  }


  void onSearch() {
    fetchReport();
  }
}

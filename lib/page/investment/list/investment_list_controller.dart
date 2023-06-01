import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/investment/investment_list.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';


class InvestmentListController extends GetxController  {

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";
  var showFabObs = false.obs;
  bool goHome = Get.arguments["home"] ?? false;

  var reportResponseObs = Resource.onInit(data: InvestmentListResponse()).obs;
  InvestmentListItem? previousReport;

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
          "transaction_no": searchInput,
          "status": searchStatus,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchInvestmentLists(_param());
      if (response.code == 1) {
       if(response.reports!.isNotEmpty) {
         showFabObs.value = false;
       }
       else{
         showFabObs.value = true;
       }
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      print(e);
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    fetchReport();
  }

  void onItemClick(InvestmentListItem report) {
    Get.toNamed(AppRoute.investmentDetailPage,arguments: report);
  }

  void onSearch() {
    fetchReport();
  }
}

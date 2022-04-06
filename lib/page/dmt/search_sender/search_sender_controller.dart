import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/model/dmt/account_search.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_util.dart';

import 'account_list_dialog.dart';

class DmtSearchSenderController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();

  var numberController = TextEditingController();
  DmtType dmtType = Get.arguments["dmtType"];
  String? mobile = Get.arguments["mobile"];

  //GlobalKey<FormState> senderSearchFormkey = GlobalKey<FormState>();

  var showSearchButton = false.obs;
  var isSearchingSender = false.obs;

  var searchTypeObs = DmtRemitterSearchType.mobile.obs;

  @override
  void onInit() {
    super.onInit();

    numberController.text = mobile ?? "";
    if (numberController.text.toString().length == 10) {
      showSearchButton.value = true;
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        _searchSender();
      });
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    super.dispose();
  }

  onSearchClick() {
    if (searchTypeObs.value == DmtRemitterSearchType.mobile) {
      _searchSender();
    } else {
      _searchBeneficiaryAccount();
    }
  }

  _searchBeneficiaryAccount() async {
    StatusDialog.progress(title: "Searching Account");
    try {
      final accountNumber = numberController.text.toString();
      final data = {"accountno": accountNumber};

      AccountSearchResponse response = await repo.searchAccount(data);
      Get.back();
      if (response.code == 1) {
        Get.dialog(AccountListDialogWidget(
          accountNumber: accountNumber,
          accountList: response.accounts!,
          onAccountClick: (value) {
            Get.back();
            _searchSender(accountSearch: value);
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      AppUtil.logger(e.toString());
      Get.to(() => ExceptionPage(error: e));
    }
  }

  onMobileChange(String value) {
    final mobileNumber = numberController.text.toString();

    if (mobileNumber.length == 10 &&
        searchTypeObs.value == DmtRemitterSearchType.mobile) {
      showSearchButton.value = true;
      _searchSender();
    } else if (mobileNumber.length > 6 &&
        searchTypeObs.value == DmtRemitterSearchType.account) {
      showSearchButton.value = true;
    } else {
      showSearchButton.value = false;
    }
  }

  _searchSender({AccountSearch? accountSearch}) async {
    StatusDialog.progress(title: "Searching");
    try {
      final mobile = accountSearch != null
          ? accountSearch.senderNumber!
          : numberController.text.toString();
      final data = {"mobileno": mobile};

      SenderInfo sender = await repo.searchSender(data);
      Get.back();

      if (sender.code == 1) {
        final args = {"sender": sender, "dmtType": dmtType, "account" : accountSearch};
        Get.toNamed(RouteName.dmtBeneficiaryListPage, arguments: args);
      } else if (sender.code == 2) {
        final args = {
          "mobile": mobile,
          "dmtType": dmtType,
        };
        Get.toNamed(RouteName.dmtSenderAddPage, arguments: args);
      } else {
        StatusDialog.failure(title: sender.message);
      }
    } catch (e) {
      Get.back();
      AppUtil.logger(e.toString());
      Get.to(() => ExceptionPage(error: e));
    }
  }

  getInputTextFieldLabel() =>
      (searchTypeObs.value == DmtRemitterSearchType.mobile)
          ? "Remitter Mobile Number"
          : "Beneficiary Account Number";

  getInputTextFielMaxLegth() =>
      (searchTypeObs.value == DmtRemitterSearchType.mobile) ? 10 : 20;
}


enum DmtRemitterSearchType{
  mobile,account
}
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:new_version/new_version.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/data/repo_impl/auth_impl.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/data/repo_impl/matm_credo_impl.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/data/repo_impl/virtual_account_impl.dart';
import 'package:spayindia/data/repo_impl/wallet_repo_impl.dart';
import 'package:spayindia/page/matm_credo/matm_credo_page.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/service/provide_async.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

appBinding() async {
  //async binding
  SharedPreferences preferences = await provideSharePreference();
  Get.put(preferences, permanent: true);
  Get.put(AppPreference(Get.find()));

  var newVersion =  NewVersion(androidId: 'com.spayindia.app',);
  VersionStatus? versionStatus = await newVersion.getVersionStatus();
  Get.put(versionStatus,permanent: true);




  //network client binding
  Get.lazyPut(() => Connectivity(), fenix: true);
  Get.lazyPut(() => NetworkClient(Get.find(), Get.find()), fenix: true);

  //repo binding
  Get.lazyPut(() => AuthRepoImpl(), fenix: true);
  Get.lazyPut(() => RechargeRepoImpl(), fenix: true);
  Get.lazyPut(() => HomeRepoImpl(), fenix: true);
  Get.lazyPut(() => DmtRepoImpl(), fenix: true);
  Get.lazyPut(() => AepsRepoImpl(), fenix: true);
  Get.lazyPut(() => ReportRepoImpl(), fenix: true);
  Get.lazyPut(() => WalletRepoImpl(), fenix: true);
  Get.lazyPut(() => MoneyRequestImpl(), fenix: true);
  Get.lazyPut(() => VirtualAccountImpl(), fenix: true);
  Get.lazyPut(() => SecurityDepositImpl(), fenix: true);
  Get.lazyPut(() => MatmCredoImpl(), fenix: true);

}

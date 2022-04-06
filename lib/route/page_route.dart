import 'package:get/get.dart';
import 'package:spayindia/page/aeps/aeps_e_kyc/aeps_e_kyc_page.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/page/app_setting/app_setting_page.dart';
import 'package:spayindia/page/auth/fogot_password/fogot_password_page.dart';
import 'package:spayindia/page/auth/login/login_page.dart';
import 'package:spayindia/page/auth/login_otp/login_otp_page.dart';
import 'package:spayindia/page/dmt/beneficiary_add/beneficiary_add_page.dart';
import 'package:spayindia/page/dmt/beneficiary_list/beneficiary_page.dart';
import 'package:spayindia/page/dmt/dmt_transaction/dmt_transaction_page.dart';
import 'package:spayindia/page/dmt/import_beneficiary/import_beneficiary_tab.dart';
import 'package:spayindia/page/dmt/search_sender/search_sender_page.dart';
import 'package:spayindia/page/dmt/sender_add/sender_add_page.dart';
import 'package:spayindia/page/dmt/sender_change/change_mobile/sender_change_mobile_page.dart';
import 'package:spayindia/page/dmt/sender_change/change_name/sender_change_name_page.dart';
import 'package:spayindia/page/fund/fund_request_page.dart';
import 'package:spayindia/page/main/change_password/change_password_page.dart';
import 'package:spayindia/page/main/change_pin/change_pin_page.dart';
import 'package:spayindia/page/main_page.dart';
import 'package:spayindia/page/matm/matm_page.dart';
import 'package:spayindia/page/recharge/bill_payment/bill_payment_page.dart';
import 'package:spayindia/page/recharge/provider/provider_page.dart';
import 'package:spayindia/page/recharge/recharge/recharge_page.dart';
import 'package:spayindia/page/report/fund_report/fund_report_page.dart';
import 'package:spayindia/page/report/tabs/transaction_tab.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_search/wallet_search_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_transfer/wallet_transfer_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/test/test_image_picker.dart';

final getAllPages = [
  GetPage(
    name: RouteName.mainPage,
    page: () => const MainPage(),
  ),
  GetPage(
    name: RouteName.testPage,
    page: () => const TestImagePicker(),
  ),

  GetPage(
    name: RouteName.loginPage,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: RouteName.loginOtpPage,
    page: () => const LoginOtpPage(),
  ),
  GetPage(
    name: RouteName.forgotPasswordPage,
    page: () => const ForgotPasswordPage(),
  ),
  GetPage(
    name: RouteName.providerPage,
    page: () => const ProviderPage(),
  ),
  GetPage(
    name: RouteName.rechargePage,
    page: () => const RechargePage(),
  ),
  GetPage(
    name: RouteName.billPaymentPage,
    page: () => const BillPaymentPage(),
  ),
  GetPage(
    name: RouteName.aepsPage,
    page: () => const AepsPage(),
  ),
  GetPage(
    name: RouteName.aepsEkycPage,
    page: () => const AepsEKycPage(),
  ),
  GetPage(
    name: RouteName.mamtPage,
    page: () => const MatmPage(),
  ),
  GetPage(
    name: RouteName.dmtSearchSenderPage,
    page: () => const DmtSearchSenderPage(),
  ),
  GetPage(
    name: RouteName.dmtBeneficiaryListPage,
    page: () => const BeneficiaryListPage(),
  ),

  GetPage(
    name: RouteName.dmtSenderAddPage,
    page: () => const SenderAddPage(),
  ),

  GetPage(
    name: RouteName.dmtBeneficiaryAddPage,
    page: () => const BeneficiaryAddPage(),
  ),
  GetPage(
    name: RouteName.dmtTransactionPage,
    page: () => const DmtTransactionPage(),
  ),

  GetPage(
    name: RouteName.dmtChangeSenderNamePage,
    page: () => const SenderNameChangePage(),
  ),
  GetPage(
    name: RouteName.dmtChangeSenderMobilePage,
    page: () => const SenderMobileChangePage(),
  ),
  GetPage(
    name: RouteName.dmtImportBeneficiaryPage,
    page: () => const ImportBeneficiaryTabPage(),
  ),


  GetPage(
    name: RouteName.fundRequestPage,
    page: () => const FundRequestPage(),
  ),
  GetPage(
    name: RouteName.fundReportPage,
    page: () => const FundRequestReportPage(),
    arguments: "route",
  ),


  GetPage(
    name: RouteName.changePassword,
    page: () => const ChangePasswordPage(),
  ),

  GetPage(
    name: RouteName.changePin,
    page: () => const ChangePinPage(),
  ),

  //report

  GetPage(
    name: RouteName.transactionReportPage,
    page: () => const TransactionTabPage(),
  ),
  //kyc

  GetPage(
    name: RouteName.walletSearchPage,
    page: () => const WalletSearchPage(),
  ),


  GetPage(
    name: RouteName.walletTransferPage,
    page: () => const WalletTransferPage(),
  ),
  GetPage(
    name: RouteName.appSetting,
    page: () => const AppSettingPage(),
  ),

];

_bindController(String controllerType) {
  switch (controllerType) {
  /* case RouteName.homePage:
      return BindingsBuilder(() => Get.lazyPut(() => HomeController()));
    case RouteName.secondPage:
      return BindingsBuilder(() => Get.lazyPut(() => SecondController()));*/
  }
}

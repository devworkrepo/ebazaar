import 'package:get/get.dart';
import 'package:spayindia/page/aeps/aeps_e_kyc/aeps_e_kyc_page.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/page/app_setting/app_setting_page.dart';
import 'package:spayindia/page/auth/fogot_password/fogot_password_page.dart';
import 'package:spayindia/page/auth/login/login_page.dart';
import 'package:spayindia/page/auth/login_otp/login_otp_page.dart';
import 'package:spayindia/page/credit_card/credit_card_page.dart';
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
import 'package:spayindia/page/ott/ott_operator/ott_operator_page.dart';
import 'package:spayindia/page/paytm_wallet/paytm_wallet_page.dart';
import 'package:spayindia/page/recharge/bill_payment/bill_payment_page.dart';
import 'package:spayindia/page/recharge/lic_online_payment/lic_online_page.dart';
import 'package:spayindia/page/recharge/provider/provider_page.dart';
import 'package:spayindia/page/recharge/recharge/recharge_page.dart';
import 'package:spayindia/page/report/transaction_tab.dart';
import 'package:spayindia/page/report/wallet_pay/wallet_report_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_search/wallet_search_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_transfer/wallet_transfer_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/test/test_image_picker.dart';

import '../page/main/aeps_onboarding/aeps_onboarding_page.dart';
import '../page/ott/ott_plan/ott_plan_page.dart';
import '../page/ott/ott_transaction/ott_transaction_page.dart';
import '../page/report/fund_report/fund_report_page.dart';

final getAllPages = [
  GetPage(
    name: AppRoute.mainPage,
    page: () => const MainPage(),
  ),
  GetPage(
    name: AppRoute.testPage,
    page: () => const TestImagePicker(),
  ),

  GetPage(
    name: AppRoute.loginPage,
    page: () => const LoginPage(),
  ),
  GetPage(
    name: AppRoute.loginOtpPage,
    page: () => const LoginOtpPage(),
  ),
  GetPage(
    name: AppRoute.forgotPasswordPage,
    page: () => const ForgotPasswordPage(),
  ),
  GetPage(
    name: AppRoute.providerPage,
    page: () => const ProviderPage(),
  ),
  GetPage(
    name: AppRoute.rechargePage,
    page: () => const RechargePage(),
  ),
  GetPage(
    name: AppRoute.billPaymentPage,
    page: () => const BillPaymentPage(),
  ),
  GetPage(
    name: AppRoute.licPaymentPage,
    page: () => const LicOnlinePagePage(),
  ),
  GetPage(
    name: AppRoute.aepsPage,
    page: () => const AepsPage(),
  ),
  GetPage(
    name: AppRoute.aepsEkycPage,
    page: () => const AepsEKycPage(),
  ),
  GetPage(
    name: AppRoute.aepsOnboardingPage,
    page: () => const AepsOnboardingPage(),
  ),
  GetPage(
    name: AppRoute.mamtPage,
    page: () => const MatmPage(),
  ),
  GetPage(
    name: AppRoute.creditCardPage,
    page: () => const CreditCardPage(),
  ),
  GetPage(
    name: AppRoute.dmtSearchSenderPage,
    page: () => const DmtSearchSenderPage(),
  ),
  GetPage(
    name: AppRoute.dmtBeneficiaryListPage,
    page: () => const BeneficiaryListPage(),
  ),

  GetPage(
    name: AppRoute.dmtSenderAddPage,
    page: () => const SenderAddPage(),
  ),

  GetPage(
    name: AppRoute.dmtBeneficiaryAddPage,
    page: () => const BeneficiaryAddPage(),
  ),
  GetPage(
    name: AppRoute.dmtTransactionPage,
    page: () => const DmtTransactionPage(),
  ),

  GetPage(
    name: AppRoute.dmtChangeSenderNamePage,
    page: () => const SenderNameChangePage(),
  ),
  GetPage(
    name: AppRoute.dmtChangeSenderMobilePage,
    page: () => const SenderMobileChangePage(),
  ),
  GetPage(
    name: AppRoute.dmtImportBeneficiaryPage,
    page: () => const ImportBeneficiaryTabPage(),
  ),


  GetPage(
    name: AppRoute.fundRequestPage,
    page: () => const FundRequestPage(),
  ),
  GetPage(
    name: AppRoute.fundReportPage,
    page: () => const FundRequestReportPage(),
    arguments: "route",
  ),

  GetPage(
    name: AppRoute.walletReportPage,
    page: () => const WalletPayReportPage()
  ),


  GetPage(
    name: AppRoute.changePassword,
    page: () => const ChangePasswordPage(),
  ),

  GetPage(
    name: AppRoute.changePin,
    page: () => const ChangePinPage(),
  ),

  //report

  GetPage(
    name: AppRoute.transactionReportPage,
    page: () => const TransactionTabPage(),
  ),
  //kyc

  GetPage(
    name: AppRoute.walletSearchPage,
    page: () => const WalletSearchPage(),
  ),


  GetPage(
    name: AppRoute.walletTransferPage,
    page: () => const WalletTransferPage(),
  ),
  GetPage(
    name: AppRoute.appSetting,
    page: () => const AppSettingPage(),
  ),
  GetPage(
    name: AppRoute.paytmWalletLoadPage,
    page: () => const PaytmWalletPage(),
  ),
  GetPage(
    name: AppRoute.ottOperatorPage,
    page: () => const OttOperatorPage(),
  ),
  GetPage(
    name: AppRoute.ottPlanPage,
    page: () => const OttPlanPage(),
  ),

  GetPage(
    name: AppRoute.ottTransactionPage,
    page: () => const OttTransactionPage(),
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

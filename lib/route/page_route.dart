import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/aeps/aeps_e_kyc/aeps_e_kyc_page.dart';
import 'package:spayindia/page/aeps/aeps_airtel/aeps_page.dart';
import 'package:spayindia/page/aeps/aeps_tramo/aeps_page.dart';
import 'package:spayindia/page/aeps_settlement/account_status/account_status_page.dart';
import 'package:spayindia/page/aeps_settlement/add_bank/add_bank_page.dart';
import 'package:spayindia/page/aeps_settlement/bank_transfer/aeps_bank_transfer_page.dart';
import 'package:spayindia/page/aeps_settlement/select_bank/select_bank_page.dart';
import 'package:spayindia/page/app_setting/login_session_page.dart';
import 'package:spayindia/page/auth/login/login_page.dart';
import 'package:spayindia/page/auth/login_otp/login_otp_page.dart';
import 'package:spayindia/page/auth/signup/signup_page.dart';
import 'package:spayindia/page/cms_service/cms_service_page.dart';
import 'package:spayindia/page/complaint/complain_info/complain_info_page.dart';
import 'package:spayindia/page/credit_card/credit_card_page.dart';
import 'package:spayindia/page/device_security_page.dart';
import 'package:spayindia/page/dmt/beneficiary_add/beneficiary_add_page.dart';
import 'package:spayindia/page/dmt/beneficiary_list/beneficiary_page.dart';
import 'package:spayindia/page/dmt/dmt_transaction/dmt_transaction_page.dart';
import 'package:spayindia/page/dmt/import_beneficiary/import_beneficiary_tab.dart';
import 'package:spayindia/page/dmt/kyc_info/sender_kyc_info_page.dart';
import 'package:spayindia/page/dmt/search_sender/search_sender_page.dart';
import 'package:spayindia/page/dmt/sender_add/sender_add_page.dart';
import 'package:spayindia/page/dmt/sender_change/change_mobile/sender_change_mobile_page.dart';
import 'package:spayindia/page/dmt/sender_change/change_name/sender_change_name_page.dart';
import 'package:spayindia/page/dtm_ekyc/dmt_ekyc_page.dart';
import 'package:spayindia/page/fund/fund_request_page.dart';
import 'package:spayindia/page/main/change_password/change_password_page.dart';
import 'package:spayindia/page/main/change_pin/change_pin_page.dart';
import 'package:spayindia/page/main_page.dart';
import 'package:spayindia/page/matm_credo/matm_credo_page.dart';
import 'package:spayindia/page/ott/ott_operator/ott_operator_page.dart';
import 'package:spayindia/page/paytm_wallet/paytm_wallet_page.dart';
import 'package:spayindia/page/recharge/bill_payment/bill_payment_page.dart';
import 'package:spayindia/page/recharge/lic_online_payment/lic_online_page.dart';
import 'package:spayindia/page/recharge/provider/provider_page.dart';
import 'package:spayindia/page/recharge/recharge/recharge_page.dart';
import 'package:spayindia/page/report/security_deposit_report/security_deposit_report_page.dart';
import 'package:spayindia/page/report/transaction_tab.dart';
import 'package:spayindia/page/report/wallet_pay/wallet_report_page.dart';
import 'package:spayindia/page/security_deposit/security_deposit_page.dart';
import 'package:spayindia/page/summary/summary_page.dart';
import 'package:spayindia/page/upi_payment/upi_payment_page.dart';
import 'package:spayindia/page/virtual_account/account/virtual_account_page.dart';
import 'package:spayindia/page/virtual_account/report/transaction_tab.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_search/wallet_search_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_transfer/wallet_transfer_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/test/test_credo_pay.dart';
import 'package:spayindia/test/test_local_auth_page.dart';
import 'package:spayindia/test/test_notification_page.dart';
import 'package:spayindia/test/test_pg.dart';

import '../main.dart';
import '../page/aeps/aeps_air_kyc/aeps_e_kyc_page.dart';
import '../page/aeps_settlement/import_account/import_account_page.dart';
import '../page/aeps_settlement/settlement/settlement_page.dart';
import '../page/complaint/complain_post/complain_post_page.dart';
import '../page/complaint/complaint_list/complaint_list_page.dart';
import '../page/dmt/sender_kcy/sender_kyc_page.dart';
import '../page/main/aeps_onboarding/aeps_onboarding_page.dart';
import '../page/matm_tramo/matm_page.dart';
import '../page/notification/notification_page.dart';
import '../page/ott/ott_plan/ott_plan_page.dart';
import '../page/ott/ott_transaction/ott_transaction_page.dart';
import '../page/pg/payment_gateway_page.dart';
import '../page/refund/refund_tab.dart';
import '../page/report/fund_report/fund_report_page.dart';
import '../page/root_page.dart';
import '../page/statement/statement_tab.dart';

final getAllPages = [
  GetPage(
    name: AppRoute.mainPage,
    page: () => const MainPage(),
  ),

  GetPage(
    name: AppRoute.rootPage,
    page: () => const RootPage(),
  ),

  GetPage(
    name: AppRoute.testPage,
    page: () =>
        testPageMode() ??
        const Scaffold(
          body: Center(
            child: Text("Test Page Not Found!"),
          ),
        ),
  ),

  GetPage(
    name: AppRoute.loginPage,
    page: () => const LoginPage(),
  ),

  GetPage(
    name: AppRoute.deviceLockPage,
    page: () => const DeviceLockPage(),
  ),

  GetPage(
    name: AppRoute.loginOtpPage,
    page: () => const LoginOtpPage(),
  ),
  GetPage(
    name: AppRoute.signupPage,
    page: () => const SignupPage(),
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
    name: AppRoute.aepsTramoPage,
    page: () => const AepsPage(),
  ),
  GetPage(
    name: AppRoute.aepsAirtelPage,
    page: () => const AepsAirtelPage(),
  ),
  GetPage(
    name: AppRoute.aepsAirtelKycPage,
    page: () => const AepsAirEKycPage(),
  ),
  GetPage(
    name: AppRoute.aepsEkycPage,
    page: () => const AepsEKycPage(),
  ),

  GetPage(
    name: AppRoute.senderKycPage,
    page: () => const SenderKycPage(),
  ),

  GetPage(
    name: AppRoute.senderKycInfoPage,
    page: () => const SenderKycInfoPage(),
  ),

  GetPage(
    name: AppRoute.aepsSettlementPage,
    page: () => const AepsSettlementPage(),
  ),

  GetPage(
    name: AppRoute.aepsBankTransferPage,
    page: () => const AepsBankTransferPage(),
  ),

  GetPage(
    name: AppRoute.aepsSettlemenBankListtPage,
    page: () => const SettlementAccountStatusPage(),
  ),

  GetPage(
    name: AppRoute.aepsSelectSettlementBank,
    page: () => const SelectAepsSettlementBankPage(),
  ),
  GetPage(
    name: AppRoute.addSettlementBank,
    page: () => const SettlementBankAddPage(),
  ),
  GetPage(
    name: AppRoute.importSettlementBank,
    page: () => const ImportSettlementAccountPage(),
  ),

  GetPage(
    name: AppRoute.aepsOnboardingPage,
    page: () => const AepsOnboardingPage(),
  ),
  GetPage(
    name: AppRoute.matmTramopage,
    page: () => const MatmTramoPage(),
  ),
  GetPage(
    name: AppRoute.matmCredoPage,
    page: () => const MatmCredoPage(),
  ),
  GetPage(
    name: AppRoute.creditCardPage,
    page: () => const CreditCardPage(),
  ),
  GetPage(
    name: AppRoute.virtualAccountPage,
    page: () => const VirtualAccountPage(),
  ),
  GetPage(
    name: AppRoute.virtualAccountTransactionTabPage,
    page: () => const VirtualTransactionTabPage(),
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
    name: AppRoute.dmtEkycPage,
    page: () => const DmtKycWebView(),
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
      name: AppRoute.walletReportPage, page: () => const WalletPayReportPage()),

  GetPage(
      name: AppRoute.securityDepositReportPage, page: () => const SecurityDepositReportPage()),

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
  GetPage(
    name: AppRoute.refundReportPage,
    page: () => const RefundTabPage(),
  ),

  GetPage(
    name: AppRoute.statementReportPage,
    page: () => const StatementTabPage(),
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
    name: AppRoute.manageLoginSession,
    page: () => const LoginSessionPage(),
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
  GetPage(
    name: AppRoute.notificationPage,
    page: () => const NotificationPage(),
  ),

  GetPage(
    name: AppRoute.summaryPage,
    page: () => const SummaryPage(),
  ),
  GetPage(
    name: AppRoute.securityDepositPage,
    page: () => const SecurityDepositPage(),
  ),

  GetPage(
    name: AppRoute.complaintPage,
    page: () => const ComplaintListPage(),
  ),

  GetPage(
    name: AppRoute.complainPostPage,
    page: () => const ComplainPostPage(),
  ),

  GetPage(
    name: AppRoute.complainInfoPage,
    page: () => const ComplainInfoPage(),
  ),
  GetPage(
    name: AppRoute.addFundOnline,
    page: () => const PaymentGatewayPage(),
  ),
  GetPage(
    name: AppRoute.upiPayment,
    page: () => const UpiPaymentPage(),
  ),
  GetPage(
    name: AppRoute.cmsServicePage,
    page: () => const CMSServicePage(),
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

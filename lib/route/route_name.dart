class AppRoute {

  AppRoute._();
  static const mainPage = "/";
  static const testPage = "/test";

  //auth
  static const loginPage = "/login";
  static const deviceVerificationPage = "/device-verification-page";
  static const loginOtpPage = "/login-otp";

  //recharge and bill payments
  static const providerPage = "/provider-page";
  static const rechargePage = "/recharge-page";
  static const billPaymentPage = "/bll-payment-page";
  static const licPaymentPage = "/lic-payment-page";

  //aeps
  static const aepsPage = "/aeps";
  static const mamtPage = "/matm";

  //credit card
  static const creditCardPage = "/credit_card_page";

  //dmt
  static const dmtSearchSenderPage = "/dmt-search-sender-page";
  static const dmtBeneficiaryListPage = "/dmt-beneficiary_list-page";
  static const dmtSenderAddPage = "/dmt-sender-add-page";
  static const dmtBeneficiaryAddPage = "/dmt-beneficiary-add-page";
  static const dmtTransactionPage = "/dmt-transaction-page";
  static const dmtTransactionResponsePage = "/dmt-transaction-response-page";
  static const dmtChangeSenderNamePage = "/dmt-change-sender-name-page";
  static const dmtChangeSenderMobilePage = "/dmt-change-sender-mobile-page";
  static const dmtImportBeneficiaryPage = "/dmt-import-beneficiary-page";


  //fund request

  static const fundRequestOptionPage = "/fund-request-option-page";
  static const fundRequestBankListPage = "/fund-request-bank-list-page";
  static const fundRequestPage = "/fund-request-page";
  static const fundReportPage = "/fund-report-page";
  static const walletReportPage = "/wallet-report-page";
  static const fundRequestUpiPage = "/fund-request-upi-page";
  static const showQRCodePage = "/show-qr-code-page";


  //change pin
  static const changePassword = "/change-password";
  static const changePin = "/change-pin";



  //report
  static const transactionReportPage = "/transaction-report-page";
  static const refundReportPage = "/refund-report-page";
  static const statementReportPage = "/statement-report-page";
  static const aepsAllReportPage = "/aeps-all-report-page";
  static const complainListPage = "/complain-list-page";
  static const complainPostPage = "/complain-post-page";

  static const aepsEkycPage = "/aeps-kyc-page";
  static const senderKycPage = "/sender-kyc-page";
  static const senderKycInfoPage = "/sender-kyc-info-page";
  static const aepsSettlementPage = "/settlement-page";

  static const aepsOnboardingPage = "/aeps-onboarding-page";

  //wallet to wallet
  static const walletSearchPage = "/wallet-search-page";
  static const walletTransferPage = "/wallet-transfer-page";

//paytm wallet load
  static const paytmWalletLoadPage = "/paytm_wallet_load_page";

  static const appSetting = "/app-setting-page";
  static const ottOperatorPage = "/ott-operator-page";
  static const ottPlanPage = "/ott-plan-page";
  static const ottTransactionPage = "/ott-transaction-page";
  static const notificationPage = "/notification-page";
  static const summaryPage = "/summary-page";
}

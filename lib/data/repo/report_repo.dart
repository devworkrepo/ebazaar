import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/refund/dmt_refund.dart';
import 'package:spayindia/model/report/aeps.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/wallet.dart';
import '../../model/refund/credit_card.dart';
import '../../model/refund/recharge.dart';
import '../../model/report/credit_card.dart';
import '../../model/report/recharge.dart';
import '../../model/report/requery.dart';
import '../../model/statement/account_statement.dart';
import '../../model/statement/credit_debit_statement.dart';

abstract class ReportRepo{


  //report
  Future<MoneyReportResponse> fetchMoneyTransactionList(data);
  Future<MoneyReportResponse> fetchPayoutTransactionList(data);
  Future<RechargeReportResponse> fetchRechargeTransactionList(data);
  Future<AepsReportResponse> fetchAepsTransactionList(data);
  Future<AepsReportResponse> fetchMatmTransactionList(data);
  Future<WalletPayReportResponse> fetchWalletPayReport(data);
  Future<CreditCardReportResponse> fetchCreditCardReport(data);

  //refund
  Future<DmtRefundListResponse> dmtRefundList(data);
  Future<DmtRefundListResponse> payoutRefundList(data);
  Future<RechargeRefundListResponse> rechargeRefundList(data);
  Future<CreditRefundListResponse> creditCardRefundList(data);
  Future<CommonResponse> takeDmtRefund(data);
  Future<CommonResponse> takeRechargeRefund(data);
  Future<CommonResponse> takeCreditCardRefund(data);

  //re-query
  Future<ReportRequeryResponse> requeryDmtTransaction(data);
  Future<ReportRequeryResponse> requeryPayoutTransaction(data);
  Future<ReportRequeryResponse> requeryCreditCardTransaction(data);


  //statement
  Future<AccountStatementResponse> fetchAccountStatement(data);
  Future<AccountStatementResponse> fetchAepsStatement(data);
  Future<CreditDebitStatementResponse> fetchCreditStatement(data);
  Future<CreditDebitStatementResponse> fetchDebitStatement(data);


}
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/refund/dmt_refund.dart';
import 'package:spayindia/model/report/aeps.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/wallet.dart';
import '../../model/report/recharge.dart';
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

  //refund
  Future<DmtRefundListResponse> dmtRefundList(data);
  Future<DmtRefundListResponse> payoutRefundList(data);
  Future<CommonResponse> takeDmtRefund(data);

  //statement
  Future<AccountStatementResponse> fetchAccountStatement(data);
  Future<AccountStatementResponse> fetchAepsStatement(data);
  Future<CreditDebitStatementResponse> fetchCreditStatement(data);
  Future<CreditDebitStatementResponse> fetchDebitStatement(data);


}
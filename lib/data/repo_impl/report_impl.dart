import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/receipt/aeps.dart';
import 'package:spayindia/model/receipt/recharge.dart';
import 'package:spayindia/model/refund/credit_card.dart';
import 'package:spayindia/model/refund/dmt_refund.dart';
import 'package:spayindia/model/report/aeps.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/service/network_client.dart';

import '../../model/receipt/credit_card.dart';
import '../../model/receipt/money.dart';
import '../../model/refund/recharge.dart';
import '../../model/report/credit_card.dart';
import '../../model/report/recharge.dart';
import '../../model/report/requery.dart';
import '../../model/report/wallet.dart';
import '../../model/statement/account_statement.dart';
import '../../model/statement/credit_debit_statement.dart';

class ReportRepoImpl extends ReportRepo{
  
  NetworkClient client = Get.find();

  @override
  Future<MoneyReportResponse> fetchMoneyTransactionList (data) async{
    var response = await  client.post("/GetTransactionList",data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReportResponse> fetchPayoutTransactionList (data) async{
    var response = await  client.post("/GetPayoutList",data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

  @override
  Future<DmtRefundListResponse> dmtRefundList(data) async {
    var response = await  client.post("/GetRefundDMTList",data: data);
    return DmtRefundListResponse.fromJson(response.data);
  }


 @override
  Future<DmtRefundListResponse> payoutRefundList(data) async {
    var response = await  client.post("/GetRefundPayoutList",data: data);
    return DmtRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeDmtRefund(data) async {
    var response = await  client.post("/ClaimDMTRefund",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takePayoutRefund(data) async {
    var response = await  client.post("/ClaimPayoutRefund",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<RechargeReportResponse> fetchRechargeTransactionList(data) async {
    var response = await  client.post("/GetRechagesList",data: data);
    return RechargeReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchAepsTransactionList(data) async {
    var response = await  client.post("/AEPSTransactionList",data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AepsReportResponse> fetchMatmTransactionList(data) async {
    var response = await  client.post("/MatmTransactionList",data: data);
    return AepsReportResponse.fromJson(response.data);
  }

  @override
  Future<AccountStatementResponse> fetchAccountStatement(data) async {
    var response = await  client.post("/GetAccountStatement",data: data);
    return AccountStatementResponse.fromJson(response.data);
  }

  @override
  Future<AccountStatementResponse> fetchAepsStatement(data) async {
    var response = await  client.post("/GetAepsStatement",data: data);
    return AccountStatementResponse.fromJson(response.data);
  }

  @override
  Future<CreditDebitStatementResponse> fetchCreditStatement(data) async{
    var response = await  client.post("/GetCreditList",data: data);
    return CreditDebitStatementResponse.fromJson(response.data);
  }

  @override
  Future<CreditDebitStatementResponse> fetchDebitStatement(data) async {
    var response = await  client.post("/GetDebitList",data: data);
    return CreditDebitStatementResponse.fromJson(response.data);
  }

  @override
  Future<WalletPayReportResponse> fetchWalletPayReport(data) async {
    var response = await  client.post("/GetWalletList",data: data);
    return WalletPayReportResponse.fromJson(response.data);
  }

  @override
  Future<RechargeRefundListResponse> rechargeRefundList(data) async {
    var response = await  client.post("/GetRefundRechagesList",data: data);
    return RechargeRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeRechargeRefund(data) async {
    var response = await  client.post("/ClaimRechargeRefund",data: data);
    return CommonResponse.fromJson(response.data);

  }

  @override
  Future<TransactionInfoResponse> requeryDmtTransaction(data) async {
    var response = await  client.post("/RequeryTransaction",data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryPayoutTransaction(data) async {
    var response = await  client.post("/RequeryPayout",data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<CreditCardReportResponse> fetchCreditCardReport(data) async {
    var response = await  client.post("/GetCreditTransactionList",data: data);
    return CreditCardReportResponse.fromJson(response.data);
  }

  @override
  Future<TransactionInfoResponse> requeryCreditCardTransaction(data) async {
    var response = await  client.post("/RequeryCreditTransaction",data: data);
    return TransactionInfoResponse.fromJson(response.data);
  }

  @override
  Future<CreditRefundListResponse> creditCardRefundList(data) async {
    var response = await  client.post("/GetRefundCreditList",data: data);
    return CreditRefundListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> takeCreditCardRefund(data) async {
    var response = await  client.post("/ClaimCreditCardRefund",data: data);
    return CommonResponse.fromJson(response.data);
  }


  @override
  Future<CommonResponse> rechargeValues() async {
    var response = await  client.post("/GetRechValues");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReceiptResponse> moneyTransactionReceipt(data) async {
    var response = await  client.post("/GetTransactionInfo",data: data);
    return MoneyReceiptResponse.fromJson(response.data);
  }

  @override
  Future<MoneyReceiptResponse> payoutTransactionReceipt(data) async {
    var response = await  client.post("/GetPayoutInfo",data: data);
    return MoneyReceiptResponse.fromJson(response.data);
  }

  @override
  Future<RechargeReceiptResponse> rechargeTransactionReceipt(data)async {
    var response = await  client.post("/GetRechagesInfo",data: data);
    return RechargeReceiptResponse.fromJson(response.data);
  }

  @override
  Future<AepsReceiptResponse> aepsTransactionReceipt(data) async {
    var response = await  client.post("/GetAEPSInfo",data: data);
    return AepsReceiptResponse.fromJson(response.data);
  }

  @override
  Future<CreditCardReceiptResponse> creditCardTransactionReceipt(data) async {
    var response = await  client.post("/GetCreditCardInfo",data: data);
    return CreditCardReceiptResponse.fromJson(response.data);
  }



}
import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/refund/dmt_refund.dart';
import 'package:spayindia/model/report/aeps.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/service/network_client.dart';

import '../../model/report/recharge.dart';
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

}
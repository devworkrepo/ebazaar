import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/investment/Investment_close_calc.dart';
import 'package:spayindia/model/investment/inventment_balance.dart';
import 'package:spayindia/model/investment/inventment_calc.dart';
import 'package:spayindia/model/investment/investment_list.dart';
import 'package:spayindia/model/investment/investment_summary.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/api/test_response.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:dio/dio.dart' as dio;

import '../../model/report/security_deposit.dart';

class SecurityDepositImpl extends SecurityDepositRepo{

  NetworkClient client = Get.find();


  @override
  Future<CommonResponse> addDeposit(data)  async{
    var response = await client.post("/AddSecurityDeposit",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<SecurityDepositReportResponse> fetchReport(data) async {
    var response = await client.post("/GetDepositList",data: data);
    return SecurityDepositReportResponse.fromJson(response.data);
  }

  @override
  Future<InvestmentBalanceResponse> fetchInvestmentBalance() async{
    var response = await client.post("/GetInvestBalance",data: null);
    return InvestmentBalanceResponse.fromJson(response.data);
  }

  @override
  Future<InvestmentCalcResponse> fetchInvestmentCalc(data) async {
    return InvestmentCalcResponse.fromJson(TestResponse.commonSuccessResponse());
    var response = await client.post("/GetInvestCalc",data: data);
    return InvestmentCalcResponse.fromJson(response.data);
  }

  @override
  Future<InvestmentListResponse> fetchInvestmentLists(data) async {
    return InvestmentListResponse.fromJson(TestResponse.investmentListResponse());
    var response = await client.post("/GetInvestCalc",data: data);
    return InvestmentListResponse.fromJson(response.data);
  }

  @override
  Future<InvestmentCloseCalcResponse> fetchCloseCalc(data) async {
    return InvestmentCloseCalcResponse.fromJson(TestResponse.closeCalcResponse());
    var response = await client.post("/CalcInvestPay",data: data);
    return InvestmentCloseCalcResponse.fromJson(response.data);
  }

  @override
  Future<InvestmentSummaryResponse> fetchSummary() async {
    var response = await client.post("/Summary_SMPanel ",data: null);
    return InvestmentSummaryResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> uploadPanDetail(dio.FormData data) async {
    var response = await client.post("/AddPAN",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkPanDetail()async {
    var response = await client.post("/CheckPANStatus ",data: null);
    return CommonResponse.fromJson(response.data);
  }

}
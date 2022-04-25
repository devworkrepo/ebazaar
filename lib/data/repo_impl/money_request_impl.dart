import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/model/money_request/bank_dertail.dart';
import 'package:spayindia/model/money_request/update_detail.dart';
import 'package:spayindia/model/user/signup/mobile_submit.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:dio/dio.dart' as dio;

class MoneyRequestImpl extends MoneyRequestRepo{

  NetworkClient client = Get.find();


  @override
  Future<BankTypeDetailResponse> fetchBankType()  async{
    var response = await client.post("/GetMoneyMasters");
    return BankTypeDetailResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> makeRequest(dio.FormData data) async {
    var response = await client.post("/AddMoneyRequest",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<BondResponse> requestBond(dio.FormData data) async {

    var response = await client.post("/GetMoneyRequestBond",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return BondResponse.fromJson(response.data);
  }

  @override
  Future<FundRequestReportResponse> fetchReport(data) async {
    var response = await client.post("/MoneyRequestList",data: data);
    return FundRequestReportResponse.fromJson(response.data);
  }

  @override
  Future<MoneyRequestUpdateResponse> fetchUpdateInfo(data) async {
    var response = await client.post("/MoneyRequestDetails",data: data);
    return MoneyRequestUpdateResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> updateRequest(dio.FormData data) async {
    var response = await client.post("/UpdateMoneyRequest",data: data,options: Options(
        contentType : "application/json",
        headers: {
          "Accept" : "application/json"
        }
    ));
    return CommonResponse.fromJson(response.data);
  }

}
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/model/recharge/bill_payment.dart';
import 'package:spayindia/model/recharge/extram_param.dart';
import 'package:spayindia/model/recharge/recharge.dart';
import 'package:spayindia/model/recharge/response.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

class RechargeRepoImpl extends RechargeRepo {
  final NetworkClient client = Get.find();

  @override
  Future<ProviderResponse> fetchProviders(Map<String, String> data) async {
    var response = await client.post("GetOperators", data: data);
    return ProviderResponse.fromJson(response.data);
  }


  @override
  Future<RechargeResponse> makeMobilePrepaidRecharge(Map<String, String> data) async {
    //var response = await client.post("/PrepaidRecharge", data: data);
    var response = await AppUtil.parseJsonFromAssets("recharge_response");
    return RechargeResponse.fromJson(response);
  }

  @override
  Future<BillExtraParamResponse> fetchExtraParam(data) async {
    var response = await client.post("GetBillerFields", data: data);
    return BillExtraParamResponse.fromJson(response.data);
  }

  @override
  Future<BillInfoResponse> fetchBillInfo(data) async {
    var response = await client.post("FetchBill", data: data);
    return BillInfoResponse.fromJson(response.data);
  }

  @override
  Future<BillPaymentResponse> makeBillPayment(data) async {
    var response = await client.post("bill/payment", data: data);
    return BillPaymentResponse.fromJson(response.data);
  }

  @override
  Future<RechargeCircleResponse> fetchCircles(Map<String, String> data) async {
    var response = await client.post("/GetCircles", data: data);
    return RechargeCircleResponse.fromJson(response.data);
  }
}

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
  Future<RechargeResponse> makeMobilePrepaidRecharge(
      Map<String, String> data,CancelToken? cancelToken) async {
    var response = await client.post("/PrepaidRecharge", data: data,cancelToken: cancelToken);
    return RechargeResponse.fromJson(response.data);
  }

  @override
  Future<RechargeResponse> makeMobilePostpaidRecharge(
      Map<String, String> data,CancelToken? cancelToken) async {
    var response = await client.post("/PostpaidRecharge", data: data,cancelToken: cancelToken);
    return RechargeResponse.fromJson(response.data);
  }

  @override
  Future<RechargeResponse> makeDthRecharge(Map<String, String> data,CancelToken? cancelToken) async {
    var response = await client.post("/DTHRecharge", data: data,cancelToken: cancelToken);
    return RechargeResponse.fromJson(response.data);
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
  Future<BillPaymentResponse> makeOfflineBillPayment(data,cancelToken) async {
    var response = await client.post("/BillPaymentOffline", data: data,cancelToken: cancelToken);
    //var response = await AppUtil.parseJsonFromAssets("bill_payment_response");
    return BillPaymentResponse.fromJson(response.data);
  }

  @override
  Future<BillPaymentResponse> makePartBillPayment(data,cancelToken) async {
    var response = await client.post("/BillPaymentPart", data: data,cancelToken: cancelToken);
   // var response = await AppUtil.parseJsonFromAssets("bill_payment_response");
    return BillPaymentResponse.fromJson(response.data);
  }


  @override
  Future<RechargeCircleResponse> fetchCircles(Map<String, String> data) async {
    var response = await client.post("/GetCircles", data: data);
    return RechargeCircleResponse.fromJson(response.data);
  }
}

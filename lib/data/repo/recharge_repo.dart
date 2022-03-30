import 'package:dio/dio.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/recharge/bill_payment.dart';
import 'package:spayindia/model/recharge/extram_param.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/recharge/recharge.dart';
import 'package:spayindia/model/recharge/recharge_plan.dart';
import 'package:spayindia/model/recharge/response.dart';

abstract class RechargeRepo{

  Future<ProviderResponse> fetchProviders(Map<String,String> data);
  Future<RechargeCircleResponse> fetchCircles(Map<String,String> data);
  Future<RechargeResponse> makeMobilePrepaidRecharge(Map<String,String> data);

  //bill payment

  Future<BillExtraParamResponse> fetchExtraParam(data);
  Future<BillInfoResponse> fetchBillInfo(data);
  Future<BillPaymentResponse> makeBillPayment(data);


}
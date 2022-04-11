import 'package:dio/dio.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/recharge/bill_payment.dart';
import 'package:spayindia/model/recharge/extram_param.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/recharge/recharge.dart';
import 'package:spayindia/model/recharge/recharge_plan.dart';
import 'package:spayindia/model/recharge/response.dart';

import '../../model/recharge/credit_card.dart';

abstract class RechargeRepo{

  Future<ProviderResponse> fetchProviders(Map<String,String> data);
  Future<RechargeCircleResponse> fetchCircles(Map<String,String> data);
  Future<RechargeResponse> makeMobilePrepaidRecharge(Map<String,String> data, CancelToken? cancelToken);
  Future<RechargeResponse> makeDthRecharge(Map<String,String> data, CancelToken? cancelToken);
  Future<RechargeResponse> makeMobilePostpaidRecharge(Map<String,String> data, CancelToken? cancelToken);

  //bill payment

  Future<BillExtraParamResponse> fetchExtraParam(data);
  Future<BillInfoResponse> fetchBillInfo(data);
  Future<BillPaymentResponse> makeOfflineBillPayment(data, CancelToken? cancelToken);
  Future<BillPaymentResponse> makePartBillPayment(data, CancelToken? cancelToken);

  //card
  Future<BankListResponse> fetchCreditCardBank();
  Future<CreditCardTypeResponse> fetchCreditCardType();
  Future<CreditCardLimitResponse> fetchCreditLimit(data);
  Future<CreditCardPaymentResponse> makeCardPayment(data, CancelToken? cancelToken);



}
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/fund/request_report.dart';
import 'package:ebazaar/model/money_request/bank_dertail.dart';
import 'package:ebazaar/model/money_request/update_detail.dart';
import 'package:ebazaar/model/user/signup/mobile_submit.dart';
import 'package:ebazaar/model/wallet/wallet_fav.dart';
import 'package:dio/dio.dart' as dio;

import '../../model/money_request/pg_charge.dart';
import '../../model/money_request/pg_initiate.dart';
import '../../model/money_request/pg_payment_mode.dart';

abstract class MoneyRequestRepo{
  Future<BankTypeDetailResponse> fetchBankType();
  Future<CommonResponse> makeRequest(dio.FormData data);
  Future<CommonResponse> updateRequest(dio.FormData data);
  Future<BondResponse> requestBond(dio.FormData data);
  Future<FundRequestReportResponse> fetchReport(data);
  Future<MoneyRequestUpdateResponse> fetchUpdateInfo(data);

  Future<PgPaymentModeResponse> fetchPgPaymentList(data);
  Future<PgChargeResponse> fetchPgCharge(data);
  Future<PgInitiateResponse> initiatePaymentGateway(data);
}
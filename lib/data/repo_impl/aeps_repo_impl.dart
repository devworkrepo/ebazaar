import 'dart:convert';

import 'package:get/get.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/aadhaar_kyc_request_otp.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/kyc/document_kyc_list.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

class AepsRepoImpl extends AepsRepo{
  
  NetworkClient client = Get.find();
  
  @override
  Future<BankListResponse> fetchAepsBankList() async {
    var response = await client.post("BanksList");
    return BankListResponse.fromJson(response.data);

  }

  List<Bank> randomExpensesFromJson(String str) =>
      List<Bank>.from(
          json.decode(str).map((x) => Bank.fromJson(x)));


  @override
  Future<AepsTransactionResponse> aepsTransaction(data)async {
  var response = await client.post("aeps/transaction",data: data);
  return AepsTransactionResponse.fromJson(response.data);
  }


  @override
  Future<AepsTransactionResponse> checkStatus(data)async {
    var response = await client.get("aeps/table/check-status",queryParameters: data);
    return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<AepsSettlementBankListResponse> fetchAepsSettlementBankList() async {
    var response = await client.get("aeps-settlement/get-bank");
    return AepsSettlementBankListResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> addSettlementBank(data) async {
    var response = await client.post("aeps-settlement/add-bank",data: data);
    return StatusMessageResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> settlementTransfer(data) async {
    var response = await client.post("aeps-settlement/transaction",data: data);
    return StatusMessageResponse.fromJson(response.data);
  }

  @override
  Future<AadhaarKycRequestOtp> aadhaarKycRequestOtp(data) async{
    var response = await client.post("aadhaar-kyc/send-otp",data: data);
    return AadhaarKycRequestOtp.fromJson(response.data);

  }


  @override
  Future<StatusMessageResponse> aadhaarKycVerifyOtp(data) async{
    var response = await client.post("aadhaar-kyc/verify-otp",data: data);
    return StatusMessageResponse.fromJson(response.data);

  }


  @override
  Future<DocumentKycDetailResponse> fetchKycDocumentDetails() async {

    var response = await client.get("kyc-document/show");
    return DocumentKycDetailResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> documentKycUploadFile(data) async{
    var response = await client.post("kyc-document/upload",data: data);
    return StatusMessageResponse.fromJson(response.data);

  }

  @override
  Future<StatusMessageResponse> aepsSettlementDocumentUpload(data) async{
    var response = await client.post("aeps-settlement/upload-document",data: data);
    return StatusMessageResponse.fromJson(response.data);

  }

}
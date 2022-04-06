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

import '../../model/matm/matm_request_response.dart';

class AepsRepoImpl extends AepsRepo{
  
  NetworkClient client = Get.find();
  
  @override
  Future<AepsBankResponse> fetchAepsBankList() async {
    var response = await client.post("/GetAEPSBanks");
    return AepsBankResponse.fromJson(response.data);
  }

  @override
  Future<AepsTransactionResponse> aepsTransaction(data)async {
  var response = await client.post("/AEPSTransaction",data: data);
  return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> eKycRequestOtp(data) async {
    var response = await client.post("/SendKycOTP",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<MatmRequestResponse> initiateMatm(data) async {
    var response = await client.post("/MatmTransactionRequest",data: data);
    return MatmRequestResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> getMamtTransactionNumber() async {
    var response = await client.post("/GetTransactionNo",);
    return CommonResponse.fromJson(response.data);
  }



}
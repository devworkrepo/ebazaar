import 'package:get/get.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/e_kyc.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

import '../../model/aeps/aeps_state.dart';
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
  Future<MatmRequestResponse> initiateMatm(data) async {
    var response = await client.post("/MatmTransactionRequest", data: data);
    return MatmRequestResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> getMamtTransactionNumber() async {
    var response = await client.post(
      "/GetTransactionNo",
    );
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AepsStateListResponse> getAepsState() async {
    var response = await client.post(
      "/GetStatesAEPS",
    );
    return AepsStateListResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> onBoardAeps(data) async {
    var response = await client.post("/OnBoardAEPS", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> eKycAuthenticate(data) async {
    //var response = await client.post("/KycAuth", data: data);
    var response = await AppUtil.parseJsonFromAssets("kyc_auth");
    return CommonResponse.fromJson(response);
  }

  @override
  Future<EKycResponse> eKycResendOtp(data) async {
  //  var response = await client.post("/SendKycOTP", data: data);
    var response = await AppUtil.parseJsonFromAssets("kyc_resend_otp");
    return EKycResponse.fromJson(response);
  }

  @override
  Future<EKycResponse> eKycSendOtp(data) async {
    //var response = await client.post("/SendKycOTP", data: data);
    var response = await AppUtil.parseJsonFromAssets("kyc_request_otp");
    return EKycResponse.fromJson(response);
  }

  @override
  Future<EKycResponse> eKycVerifyOtp(data) async {
    //var response = await client.post("/VerifyKycOTP", data: data);
    var response = await AppUtil.parseJsonFromAssets("kyc_verify_otp");
    return EKycResponse.fromJson(response);
  }


}
import 'package:get/get.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_token.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/service/network_client.dart';

import '../../model/common.dart';
import '../repo/aeps_aitel_repo.dart';

class AepsAirtelRepoImpl extends AepsAirtelRepo {
  NetworkClient client = Get.find();

  @override
  Future<AepsBankResponse> fetchAepsBankList() async {
    var response = await client.post("/GetAEPSBanks_Air");
    return AepsBankResponse.fromJson(response.data);
  }

  @override
  Future<AepsTransactionResponse> aepsTransaction(data) async {
    var response = await client.post("/AEPSTransaction_Air", data: data);
    return AepsTransactionResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> aepsOnBoarding(data) async {
    var response = await client.post("/OnBoardAEPS_Air", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AepsTokenCheckResponse> checkToken() async {
    var response = await client.post("/CheckToken_Air");
    return AepsTokenCheckResponse.fromJson(response.data);
  }

  @override
  Future<AepsTokenCheckResponse> requestGenerateTokenOtp() async {
    var response = await client.post("/TokenSendOTP_Air");
    return AepsTokenCheckResponse.fromJson(response.data);
  }

  @override
  Future<AepsTokenCheckResponse> verifyGenerateTokenOpt(data) async {
    var response = await client.post("/TokenVerifyOTP_Air",data: data);
    return AepsTokenCheckResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> verifyBiometricData(data) async{
    var response = await client.post("/TokenBioAuth_Air",data: data);
    return CommonResponse.fromJson(response.data);
  }
}

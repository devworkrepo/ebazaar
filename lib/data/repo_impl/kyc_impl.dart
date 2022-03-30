import 'package:spayindia/data/repo/kyc_repo.dart';
import 'package:spayindia/model/aeps/kyc/aeps_kyc_data.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:get/get.dart';

class KycRepoImpl extends KycRepo{
  NetworkClient client = Get.find();
  @override
  Future<AepsKycDataResponse> fetchKycData() async {
   //var response = await AppUtil.parseJsonFromAssets("fetch_kyc_data");
    var response = await client.get("aeps/kyc/data");
   return AepsKycDataResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> requestOtpForAepsKyc() async {
   // var response = await AppUtil.parseJsonFromAssets("request_otp_aeps_kyc");
    var response = await client.get("aeps/kyc/send-otp");
    return StatusMessageResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> validateOtpForAepsKyc(data) async {
   // var response = await AppUtil.parseJsonFromAssets("validate_otp_aeps_kyc");
    var response = await client.post("aeps/kyc/otp/validate",data: data);
    return StatusMessageResponse.fromJson(response.data);
  }

  @override
  Future<StatusMessageResponse> verifyFingerprint(data) async {
   // var response = await AppUtil.parseJsonFromAssets("verify_finger");
    var response = await client.post("aeps/kyc/finger/verify",data: data);
    return StatusMessageResponse.fromJson(response.data);
  }
}
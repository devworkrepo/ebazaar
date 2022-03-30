import 'package:get/get.dart';
import 'package:spayindia/data/repo/signup_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/signup/mobile_submit.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

class SignupRepoImpl extends SignupRepo{

  NetworkClient client = Get.find();


  @override
  Future<SignupCommonResponse> submitMobile(data)  async{
    //var response = await AppUtil.parseJsonFromAssets("submit_mobile");
    var response = await client.post("/self/signup/mobile/process",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }


  @override
  Future<SignupCommonResponse> verifyMobile(data) async {
    //var response = await AppUtil.parseJsonFromAssets("verify_mobile");
    var response = await client.post("/self/signup/mobile/verify",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }

  @override
  Future<SignupCommonResponse> submitEmail(data) async {
    //var response = await AppUtil.parseJsonFromAssets("submit_email");
    var response = await client.post("/self/signup/email/process",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }
  @override
  Future<SignupCommonResponse> verifyEmail(data) async {
   // var response = await AppUtil.parseJsonFromAssets("verify_email");
    var response = await client.post("/self/signup/email/verification",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }


  @override
  Future<SignupCommonResponse> submitAndVerifyPan(data) async{
   // var response = await AppUtil.parseJsonFromAssets("submit_verify_pan");
    var response = await client.post("/self/signup/pan/process",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }



  @override
  Future<SignupCommonResponse> finalRegistrationPan(data) async {
   // var response = await AppUtil.parseJsonFromAssets("registration");
    var response = await client.post("/self/signup/registration",data: data);
    return SignupCommonResponse.fromJson(response.data);
  }



}
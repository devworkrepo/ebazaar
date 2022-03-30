import 'package:spayindia/data/repo/auth_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/login.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:get/get.dart';

class AuthRepoImpl extends AuthRepo {
  final NetworkClient client = Get.find();


  @override
  Future<LoginResponse> agentLogin(Map<String, String> data) async {
    var response = await client.dio.post("AgentLogin", data: data);
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> loginOtp(Map<String, String> data) async {
    var response = await client.dio.post("LoginOTPVerify", data: data);
    return LoginResponse.fromJson(response.data);
  }


  @override
  Future<CommonResponse> resendLoginOtp(Map<String, String> data) async {
    var response = await client.dio.post("LoginOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordRequestOtp(Map<String, String> data) async {
    var response = await client.dio.post("forget-password", data: data);
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> forgotPasswordVerifyOtp(Map<String, String> data) async {
    var response = await client.dio.post("set-forget-password", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<ForgotPasswordResponse> forgotPasswordResendOtp(Map<String, String> data) async {
    var response = await client.dio.post("resend-forgot-password-otp", data: data);
    return ForgotPasswordResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> checkDevice(data) async{
    var response = await client.dio.post("CheckDvc",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> registerNewDevice(data) async
  {
    var response = await client.dio.post("RegisterDvc",data: data);
    return CommonResponse.fromJson(response.data);
  }

}

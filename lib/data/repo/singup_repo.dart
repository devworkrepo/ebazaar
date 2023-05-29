import 'dart:collection';

import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/singup/captcha_response.dart';
import 'package:spayindia/model/singup/kyc_detail_response.dart';
import 'package:spayindia/model/singup/kyc_otp_response.dart';
import 'package:spayindia/model/singup/singup_user_response.dart';
import 'package:spayindia/model/singup/verify_pan_response.dart';
import 'package:spayindia/model/user/login.dart';
import 'package:dio/dio.dart' as dio;


abstract class SignUpRepo {

  Future<CommonResponse> sendMobileOtp(Map<String,String> data);
  Future<CommonResponse> verifyMobileOtp(Map<String,String> data);
  Future<SignUpCaptchaResponse> getCaptcha(Map<String,String> data);
  Future<SignUpCaptchaResponse> getReCaptcha(Map<String,String> data);
  Future<SignUpEKycResponse> sendEKycOtp(Map<String,String> data);
  Future<SignUpEKycResponse> resendEKycOtp(Map<String,String> data);
  Future<SignUpEKycResponse> verifyEKycOtp(Map<String,String> data);
  Future<SignUpKycDetailResponse> getKycDetail(Map<String,String> data);
  Future<SignUpVerifyPanResponse> verifyPan(Map<String,String> data);
  Future<CommonResponse> signUpUser(dio.FormData data);

}

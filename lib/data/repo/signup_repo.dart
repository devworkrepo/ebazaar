import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/signup/mobile_submit.dart';

abstract class SignupRepo{
  Future<SignupCommonResponse> submitMobile(data);
  Future<SignupCommonResponse> verifyMobile(data);
  Future<SignupCommonResponse> submitEmail(data);
  Future<SignupCommonResponse> verifyEmail(data);
  Future<SignupCommonResponse> submitAndVerifyPan(data);
  Future<SignupCommonResponse> finalRegistrationPan(data);
}
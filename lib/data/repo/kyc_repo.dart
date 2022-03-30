import 'package:spayindia/model/aeps/kyc/aeps_kyc_data.dart';
import 'package:spayindia/model/common.dart';

abstract class KycRepo{
  Future<AepsKycDataResponse> fetchKycData();
  Future<StatusMessageResponse> requestOtpForAepsKyc();
  Future<StatusMessageResponse> validateOtpForAepsKyc(data);
  Future<StatusMessageResponse> verifyFingerprint(data);

}
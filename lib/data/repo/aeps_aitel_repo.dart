import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_token.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/e_kyc.dart';
import 'package:spayindia/model/aeps/settlement/balance.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';

import '../../model/aeps/aeps_state.dart';
import '../../model/matm/matm_request_response.dart';
import '../../model/report/requery.dart';

abstract class AepsAirtelRepo {
  //aeps
  Future<AepsBankResponse> fetchAepsBankList();

  Future<AepsTransactionResponse> aepsTransaction(data);

  //on boarding
  Future<CommonResponse> aepsOnBoarding(data);

  Future<AepsTokenCheckResponse> checkToken();
  Future<AepsTokenCheckResponse> requestGenerateTokenOtp();
  Future<AepsTokenCheckResponse> verifyGenerateTokenOpt(data);
  Future<CommonResponse> verifyBiometricData(data);
}

import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/aadhaar_kyc_request_otp.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/kyc/document_kyc_list.dart';

import '../../model/matm/matm_request_response.dart';

abstract class AepsRepo {

  //aeps
  Future<AepsBankResponse> fetchAepsBankList();
  Future<AepsTransactionResponse> aepsTransaction(data);
  Future<CommonResponse> eKycRequestOtp(data);

  //matm
  Future<CommonResponse> getMamtTransactionNumber();
  Future<MatmRequestResponse> initiateMatm(data);

}

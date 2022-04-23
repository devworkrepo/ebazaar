import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/e_kyc.dart';
import 'package:spayindia/model/aeps/settlement/balance.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';

import '../../model/aeps/aeps_state.dart';
import '../../model/matm/matm_request_response.dart';
import '../../model/report/requery.dart';

abstract class AepsRepo {

  //aeps
  Future<AepsBankResponse> fetchAepsBankList();
  Future<AepsTransactionResponse> aepsTransaction(data);


  //aeps settlement
  Future<AepsBalance> fetchAepsBalance();
  Future<BankListResponse> fetchAepsSettlementBank();
  Future<TransactionInfoResponse> spayAccountSettlement(data);
  Future<TransactionInfoResponse> bankAccountSettlement(data);

  //matm
  Future<CommonResponse> getMamtTransactionNumber();
  Future<MatmRequestResponse> initiateMatm(data);
  Future<CommonResponse> updateMatmDataToServer(data);

  //onbaording
  Future<AepsStateListResponse> getAepsState();
  Future<CommonResponse> onBoardAeps(data);


  //kyc
  Future<EKycResponse> eKycSendOtp(data);
  Future<EKycResponse> eKycResendOtp(data);
  Future<EKycResponse> eKycVerifyOtp(data);
  Future<CommonResponse> eKycAuthenticate(data);
}

import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/dmt/account_search.dart';
import 'package:spayindia/model/dmt/calculate_charge.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/dmt/sender.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/model/dmt/verification_charge.dart';

abstract class DmtRepo {
  Future<SenderInfo> searchSender(Map<String, String> data);
  Future<AccountSearchResponse> searchAccount(Map<String, String> data);
  Future<BankListResponse> fetchBankList();
  Future<AccountVerifyResponse> verifyAccount(data);
  Future<DmtBeneficiaryResponse> fetchBeneficiary(Map<String, String> data);
  Future<CommonResponse> addBeneficiary(Map<String, String> data);
  Future<CommonResponse> senderRegistration(Map<String, String> data);
  Future<CommonResponse> senderRegistrationOtp(Map<String, String> data);
  Future<CalculateChargeResponse> calculateNonKycCharge(Map<String, String> data);
  Future<CalculateChargeResponse> calculateKycCharge(Map<String, String> data);
  Future<DmtCheckStatusResponse> transactionCheckStatus(Map<String, String> data);
  Future<CommonResponse> beneficiaryDelete(Map<String, String> data);
  Future<DmtVerificationChargeResponse> accountVerificationCharge();
  Future<CommonResponse> changeSenderName(data);
  Future<CommonResponse> changeSenderMobile(data);
  Future<CommonResponse> changeSenderOtp(data);
  Future<DmtTransactionResponse> nonKycTransaction(Map<String, String> data);
  Future<DmtTransactionResponse> kycTransaction(Map<String, String> data);
}

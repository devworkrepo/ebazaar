import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/aeps/kyc/aadhaar_kyc_request_otp.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/kyc/document_kyc_list.dart';

abstract class AepsRepo {
  Future<BankListResponse> fetchAepsBankList();

  Future<AepsTransactionResponse> aepsTransaction(data);

  Future<AepsTransactionResponse> checkStatus(data);

  Future<AepsSettlementBankListResponse> fetchAepsSettlementBankList();

  Future<StatusMessageResponse> addSettlementBank(data);

  Future<StatusMessageResponse> settlementTransfer(data);

  Future<DocumentKycDetailResponse> fetchKycDocumentDetails();

  Future<AadhaarKycRequestOtp> aadhaarKycRequestOtp(data);
  Future<StatusMessageResponse> aadhaarKycVerifyOtp(data);
  Future<StatusMessageResponse> documentKycUploadFile(data);
  Future<StatusMessageResponse> aepsSettlementDocumentUpload(data);

}

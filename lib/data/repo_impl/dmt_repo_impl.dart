import 'package:get/get.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/dmt/account_search.dart';
import 'package:spayindia/model/dmt/calculate_charge.dart';
import 'package:spayindia/model/dmt/kyc_info.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/model/dmt/verification_charge.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

class DmtRepoImpl extends DmtRepo {
  final NetworkClient client = Get.find();

  @override
  Future<SenderInfo> searchSender(Map<String, String> data) async {
   // var response = await AppUtil.parseJsonFromAssets("sender_info_response");
    var response = await client.post("SearchRemitter", data: data);
    return SenderInfo.fromJson(response.data);
  }

  @override
  Future<DmtBeneficiaryResponse> fetchBeneficiary(data) async {
    var response = await client.post("BeneficiaryList", data: data);
    return DmtBeneficiaryResponse.fromJson(response.data);
  }

  @override
  Future<BankListResponse> fetchBankList() async {

    var response = await client.post("BanksList");
    return BankListResponse.fromJson(response.data);

  }

  @override
  Future<AccountVerifyResponse> verifyAccount(data) async {
    var response = await client.post(
        "VerifyBeneficiary", data: data);
    return AccountVerifyResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addBeneficiary(Map<String, String> data) async {
    var response = await client.post("AddBeneficiary", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistration(Map<String, String> data) async {
    var response = await client.post(
        "RemitterOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> senderRegistrationOtp(Map<String, String> data) async {
    var response = await client.post(
        "AddRemitter", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> transaction(Map<String, String> data) async {
    var response = await client.post("premium-wallet/transaction",data: data);
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<DmtCheckStatusResponse> transactionCheckStatus(Map<String, String> data) async {
    var response = await client.get("transaction/table-check-status",queryParameters: data);
    return DmtCheckStatusResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> beneficiaryDelete(Map<String, String> data) async {
    var response = await client.post("DeleteBeneficiary",data: data);
    return CommonResponse.fromJson(response.data);
  }


  @override
  Future<DmtVerificationChargeResponse> accountVerificationCharge() async {
    var response = await client.get("premium-wallet/get-validation-charge");
    return DmtVerificationChargeResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculateKycCharge(Map<String, String> data) async {
    var response = await client.post("CalcKycCharges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<CalculateChargeResponse> calculateNonKycCharge(Map<String, String> data)async {
    var response = await client.post("CalcNonKycCharges",data: data);
    return CalculateChargeResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderName(data) async{
    var response = await client.post("ChangeSenderName",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderOtp(data) async {
    var response = await client.post("ChangeRemitterOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changeSenderMobile(data) async {
    var response = await client.post("ChangeSenderMobile", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<AccountSearchResponse> searchAccount(Map<String, String> data) async {
    var response = await client.post("/SearchBeneficiary", data: data);
    return AccountSearchResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> kycTransaction(Map<String, String> data)  async{
    var response = await client.post("/KycTransaction", data: data);

    //todo remove local response
   // var response = await AppUtil.parseJsonFromAssets("dmt_transaction_response");
    return DmtTransactionResponse.fromJson(response.data);
  }

  @override
  Future<DmtTransactionResponse> nonKycTransaction(Map<String, String> data) async {
    var response = await client.post("/NonKycTransaction", data: data);
    //todo remove local response
  //  var response = await AppUtil.parseJsonFromAssets("dmt_transaction_response");
    return DmtTransactionResponse.fromJson(response.data);

  }

  @override
  Future<KycInfoResponse> kycInfo(data) async {
    var response = await client.post("/SenderKycDetails", data: data);
    return KycInfoResponse.fromJson(response.data);
  }
}

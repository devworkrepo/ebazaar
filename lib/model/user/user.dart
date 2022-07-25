class UserDetail {

  late int code;
  late String message;
  late String status;
  String? agentId;
  String? fullName;
  String? outletName;
  String? picName;
  String? agentCode;
  String? userType;
  String? availableBalance;
  String? openBalance;
  String? creditBalance;
  bool? isPayoutBond;
  bool? isInstantPay;
  bool? isWalletPay;
  bool? isRecharge;
  bool? isDth;
  bool? isVirtualAccount;
  bool? isSecurityDeposit;
  bool? isInsurance;
  bool? isBill;
  bool? isCreditCard;
  bool? isPaytmWallet;
  bool? isLic;
  bool? isOtt;
  bool? isBillPart;
  bool? isPayout;
  bool? isAeps;
  bool? isMatm;
  bool? isLoginResendOtp;
  bool? isMoneyRequest;


  UserDetail();

  UserDetail.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    agentId = json['agentid'];
    fullName = json["fullname"];
    outletName = json["outlet_name"];
    picName = json['picname'];
    agentCode = json['agentcode'];
    userType = json['usertype'];
    isPayout = json['is_payout'];
    availableBalance = json['availbalance'].toString();
    openBalance = json['openbalance'].toString();
    creditBalance = json['creditbalance'].toString();
    isPayoutBond = json['is_payout_bond'];
    isWalletPay = json['is_walletpay'];
    isRecharge = json['is_recharge'];
    isDth = json['is_dth'];
    isInsurance = json['is_insurance'];
    isInstantPay = json['is_instantpay'];
    isBill = json['is_bill'];
    isVirtualAccount = json['is_virtualacc'];
    isSecurityDeposit = json['is_security_deposit'];
    isCreditCard = json['is_creditcard'];
    isPaytmWallet = json['is_paytmwallet'];
    isLic = json['is_lic'];
    isOtt = json['is_ott'];
    isBillPart = json['is_billpart'];
    isAeps = json['is_aeps'];
    isMatm = json['is_matm'];
    isLoginResendOtp = json['is_matm'];
    isMoneyRequest = json['is_moneyrequest'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data ['code']=code;
    data ['message']=message;
    data ['status']=status;
    data ['agentid']=agentId;
    data ["fullname"]=fullName;
    data ["outlet_name"]=outletName;
    data ['picname']=picName;
    data ['agentcode']=agentCode;
    data ['usertype']=userType;
    data ['availbalance']=availableBalance;
    data ['openbalance']=openBalance;
    data ['creditbalance']=creditBalance;
    data ['is_payout_bond']=isPayoutBond;
    data ['is_payout']=isPayout;
    data ['is_walletpay']=isWalletPay;
    data ['is_instantpay']=isInstantPay;
    data ['is_recharge']=isRecharge;
    data ['is_dth']=isDth;
    data ['is_insurance']=isInsurance;
    data ['is_bill']=isBill;
    data ['is_creditcard']=isCreditCard;
    data ['is_paytmwalle']=isPaytmWallet;
    data ['is_lic']=isLic;
    data ['is_ott']=isOtt;
    data ['is_virtualacc']=isVirtualAccount;
    data ['is_security_deposit']=isSecurityDeposit;
    data ['is_billpart']=isBillPart;
    data ['is_aeps']=isAeps;
    data ['is_matm']=isMatm;
    data ['is_matm']=isLoginResendOtp;
    data ['is_moneyrequest']=isMoneyRequest;
    return data;
  }



}

class UserBalance{
  late int status;
  String? wallet;

  UserBalance();

  UserBalance.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    wallet = json['wallet'];

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['wallet'] = wallet;
    return data;
  }


}



class KycDetails {

  String? isPanKyc;
  String? isAadhaarKyc;
  String? isDocumentKyc;
  String? isAepsKyc;

  KycDetails.fromJson(Map<String, dynamic> json){
    isPanKyc = json['is_pan_kyc'];
    isAadhaarKyc = json['is_aadhaar_kyc'];
    isDocumentKyc = json['is_document_kyc'];
    isAepsKyc = json['is_aeps_kyc'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['is_pan_kyc'] = isPanKyc;
    _data['is_aadhaar_kyc'] = isAadhaarKyc;
    _data['is_document_kyc'] = isDocumentKyc;
    _data['is_aeps_kyc'] = isAepsKyc;
    return _data;
  }

  @override
  String toString() {
    return 'KycDetails{isPanKyc: $isPanKyc, isAadhaarKyc: $isAadhaarKyc, isDocumentKyc: $isDocumentKyc, isAepsKyc: $isAepsKyc}';
  }
}
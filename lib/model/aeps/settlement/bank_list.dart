class AepsSettlementBankListResponse {

  AepsSettlementBankListResponse();

  late final int status;
  late final String message;
  List<AepsSettlementBank>? bankDetails;

  AepsSettlementBankListResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    bankDetails = List.from(json['data']).map((e)=>AepsSettlementBank.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = bankDetails?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class AepsSettlementBank {

  String? id;
  String? accountNumber;
  String? bankName;
  String? branchName;
  String? ifsc;
  String? remark;
  int? isBankVerified;
  String? documentStatus;
  String? createdAt;
  String? name;
  int? statusId;
  String? status;
  String? balance;
  String? aepsBloackedAmount;
  String? aepsCharge;





  AepsSettlementBank.fromJson(Map<String, dynamic> json){
    id = json['id'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    branchName = json['branch_name'];
    ifsc = json['ifsc'];
    remark = json['remark'];
    isBankVerified = json['is_bank_verified'];
    documentStatus = json['document_status'];
    createdAt = json['created_at'];
    name = json['name'];
    status = json['status'];
    statusId = json['statusId'];
    balance = json['balance'];
    aepsBloackedAmount = json['aeps_bloacked_amount'];
    aepsCharge = json['aeps_charge'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['account_number'] = accountNumber;
    _data['bank_name'] = bankName;
    _data['branch_name'] = branchName;
    _data['ifsc'] = ifsc;
    _data['remark'] = remark;
    _data['is_bank_verified'] = isBankVerified;
    _data['document_status'] = documentStatus;
    _data['created_at'] = createdAt;
    _data['name'] = name;
    _data['status'] = status;
    _data['status_id'] = statusId;
    _data['balance'] = balance;
    _data['aeps_bloacked_amount'] = aepsBloackedAmount;
    _data['aeps_charge'] = aepsCharge;
    return _data;
  }
}
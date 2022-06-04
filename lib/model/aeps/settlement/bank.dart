class AepsSettlementBankListResponse {
  late int code;
  late String message;
  String? status;
  List<AepsSettlementBank>? banks;

  AepsSettlementBankListResponse();

  AepsSettlementBankListResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
    banks = (json["banks"]!=null) ? List.from(json["banks"])
        .map((e) => AepsSettlementBank.fromJson(e))
        .toList() : null;
  }
}

class AepsSettlementBank {
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? ifscCode;
  String? cancelCheque;
  String? bankStatus;
  String? remark;
  String? date;

  AepsSettlementBank.fromJson(Map<String, dynamic> json) {
    accountName = json["acc_name"];
    accountNumber = json["acc_no"];
    bankName = json["bank_name"];
    ifscCode = json["ifsc"];
    cancelCheque = json["cancel_cheque"];
    bankStatus = json["bank_status"];
    remark = json["remark"];
    date = json["addeddate"];
  }
}
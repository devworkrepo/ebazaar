class Bank{
  late String bankName;
  late String ifscCode;

  Bank();

  Bank.fromJson(Map<String, dynamic> json) {
    bankName = json['bank_name'];
    ifscCode = json['ifsc_code'];


  }
}

class BankListResponse{

  late int code;
  late String status;
  late String message;
  late List<Bank> banks;

  BankListResponse();

  BankListResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    banks = List.from(json["data"]).map((e) => Bank.fromJson(e)).toList();


  }

}
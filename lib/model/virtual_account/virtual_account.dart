class VirtualAccountDetailResponse {
  late int code;
  late String message;
  String? status;
  YesBankVirtualAccount? yesBankVirtualAccount;
  IciciVirtualAccount? iciciVirtualAccount;

  VirtualAccountDetailResponse();
  VirtualAccountDetailResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
    iciciVirtualAccount = IciciVirtualAccount.fromJson(json["Vici"]);
    yesBankVirtualAccount = YesBankVirtualAccount.fromJson(json["Vyes"]);
  }
}

class IciciVirtualAccount {
  String? bank_name;
  String? account_no;
  String? ifsc;
  bool? isexist;

  IciciVirtualAccount.fromJson(Map<String, dynamic> json) {
    bank_name = json["bank_name"];
    account_no = json["account_no"];
    ifsc = json["ifsc"];
    isexist = json["isexist"];
  }
}

class YesBankVirtualAccount {
  String? bank_name;
  String? account_no;
  String? ifsc;
  String? qr_img;
  String? upi_id;
  bool? isexist;

  YesBankVirtualAccount.fromJson(Map<String, dynamic> json) {
    bank_name = json["bank_name"];
    account_no = json["account_no"];
    ifsc = json["ifsc"];
    qr_img = json["qr_img"];
    upi_id = json["upi_id"];
    isexist = json["isexist"];
  }
}

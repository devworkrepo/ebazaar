import 'package:get/get.dart';

class AepsSuccessReportResponse {
  late final int status;
  List<AepsSuccessReport>? reports;
  int? count;
  String? page;

  AepsSuccessReportResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    reports =
        List.from(json['reports']).map((e) => AepsSuccessReport.fromJson(e)).toList();
    count = json['count'];
    page = json['page'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['reports'] = reports?.map((e) => e.toJson()).toList();
    _data['count'] = count;
    _data['page'] = page;
    return _data;
  }
}

class AepsSuccessReport {

  String? createdAt;
  int? orderId;
  String? slipId;
  String? txnId;
  String? AadhaarNumber;
  String? BankName;
  String? type;
  String? openingBalance;
  String? amount;
  String? creditAmount;
  String? debitAmount;
  String? tds;
  String? colsingBalance;
  String? customerNumber;
  String? txnType;
  String? status;
  int? statusId;
  RxBool isExpanded = false.obs;

  AepsSuccessReport.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    orderId = json['orderId'];
    slipId = json['slip_id'];
    txnId = json['txnId'];
    AadhaarNumber = json['AadhaarNumber'];
    BankName = json['BankName'];
    type = json['type'];
    openingBalance = json['openingBalance'];
    amount = json['amount'];
    creditAmount = json['creditAmount'];
    debitAmount = json['debitAmount'];
    tds = json['tds'];
    colsingBalance = json['colsingBalance'];
    customerNumber = json['customerNumber'];
    txnType = json['txnType'];
    status = json['status'];
    statusId = json['statusId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['created_at'] = createdAt;
    _data['orderId'] = orderId;
    _data['slip_id'] = slipId;
    _data['txnId'] = txnId;
    _data['AadhaarNumber'] = AadhaarNumber;
    _data['BankName'] = BankName;
    _data['type'] = type;
    _data['openingBalance'] = openingBalance;
    _data['amount'] = amount;
    _data['creditAmount'] = creditAmount;
    _data['debitAmount'] = debitAmount;
    _data['tds'] = tds;
    _data['colsingBalance'] = colsingBalance;
    _data['customerNumber'] = customerNumber;
    _data['txnType'] = txnType;
    _data['status'] = status;
    _data['statusId'] = statusId;
    return _data;
  }
}

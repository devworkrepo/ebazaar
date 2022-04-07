import 'package:get/get.dart';

class AepsReportResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<AepsReport>? reportList;

  AepsReportResponse();

  AepsReportResponse.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    totalCount = json['totalcount'].toString();
    totalAmount = json['totalamt'].toString();
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => AepsReport.fromJson(e))
          .toList();
    }
  }
}

class AepsReport {
  String? transactionNumber;
  String? bcid;
  String? mobileNumber;
  String? aadhaarNumber;
  String? transactionType;
  String? amount;
  String? commission;
  String? bankName;
  String? transactionId;
  String? transactionStatus;
  String? transactionMessage;
  String? rrn;
  String? transctionDate;
  RxBool isExpanded = false.obs;

  AepsReport.fromJson(Map<String, dynamic> json) {
    transactionNumber = json["transaction_no"];
    bcid = json["bcid"];
    mobileNumber = json["mobileno"];
    aadhaarNumber = json["aadharno"];
    transactionType = json["txntype"];
    amount = json["amount"].toString();
    commission = json["commission"].toString();
    bankName = json["bank_name"];
    transactionId = json["transactionid"];
    transactionStatus = json["trans_status"];
    transactionMessage = json["trans_message"];
    rrn = json["rrn"];
    transctionDate = json["addeddate"];
  }
}

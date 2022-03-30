import 'package:flutter/material.dart';


class BillPaymentResponse {
  late int status;
  late String message;
  String? orderId;
  String? transactionId;
  String? transactionTime;
  String? operatorId;
  String? billerName;
  String? providerName;
  String? amount;
  String? statusDescription;
  String? billNumber;
  String? reportId;
  String? slipId;

  BillPaymentResponse();

  BillPaymentResponse.fromJson(Map<String, dynamic> json){
    status = json["status"];
    message = json["message"];
    orderId = json["order_id"];
    transactionId = json["txn_id"];
    transactionTime = json["txn_time"];
    operatorId = json["operator_id"];
    billerName = json["biller_name"];
    providerName = json["provider_name"];
    amount = json["amount"];
    slipId = json["slip_id"];
    statusDescription = json["status_description"];
    billNumber = json["bill_number"];
    if (json["report_id"] != null) {
      reportId = json["report_id"].toString();
    };
  }

}
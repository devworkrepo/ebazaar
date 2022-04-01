class BillPaymentResponse {

  late int code;
  late String status;
  String? message;
  String ? transactionNumber;
  String ? transactionDate;
  String ? customerMobile;
  String ? operatorName;
  String ? name;
  String ? billerName;
  String ? amount;
  String ? billType;
  String ? operatorRefNumber;
  String ? transactionStatus;

  BillPaymentResponse();

  BillPaymentResponse.fromJson(Map<String, dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    transactionNumber = json["transaction_no"];
    transactionDate = json["transaction_date"];
    customerMobile = json["cust_mobile"];
    billerName = json["billername"];
    name = json["name"];
    amount = json["amount"];
    billType = json["billtype"];
    operatorRefNumber = json["operator_refno"];
    transactionStatus = json["trans_status"];
    operatorName = json["operator_name"];
  }

}
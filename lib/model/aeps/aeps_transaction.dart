class AepsTransactionResponse {
  AepsTransactionResponse();

  late int status;
  late String message;
  String? orderId;
  String? httpsCode;
  String? bankRef;
  String? aadhaarNumber;
  String? transactionAmount;
  String? availableAmount;
  String? txnTime;
  String? transactionType;
  String? txnId;
  String? customerNumber;
  String? statusDescription;
  List<AepsStatement>? statement;
  String? bankName;

  String? payType;
  String? slipId;

  AepsTransactionResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    orderId = json['order_id'];
    httpsCode = json['https_code'];
    bankRef = json['bank_ref'];
    aadhaarNumber = json['aadhaar_number'];
    transactionAmount = json['transaction_amount'];
    availableAmount = json['available_amount'];
    txnTime = json['txn_time'];
    transactionType = json['transaction_type'];
    txnId = json['txn_id'];
    customerNumber = json['customer_number'];
    statusDescription = json['status_description'];
    bankName = json['bank_name'];
    message = json['message'];
    payType = json['pay_type'];
    slipId = json['slip_id'];

    if(json["statement"] != null){
      if(json["statement"] != "[]" || json["statement"] != ""){
        statement =
            List.from(json['statement']).map((e) => AepsStatement.fromJson(e)).toList();
      }
    }
  }
}

class AepsStatement {
  AepsStatement();

  String? date;
  String? txnType;
  String? amount;
  String? narration;

  AepsStatement.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    txnType = json['txnType'];
    amount = json['amount'];
    narration = json['narration'];
  }
}
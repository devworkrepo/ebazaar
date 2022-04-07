
class CreditDebitStatementResponse {
  late int code;
  String? status;
  String? message;
  String? totalCount;
  String? totalAmount;
  List<CreditDebitStatement>? reportList;

  CreditDebitStatementResponse();

  CreditDebitStatementResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalCount = json["totalcount"].toString();
    totalAmount = json["totalamt"].toString();
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => CreditDebitStatement.fromJson(e))
          .toList();
    }
  }
}

class CreditDebitStatement {
  String? date;
  String? refno;
  String? type;
  String? narration;
  String? remark;
  String? amt;


  CreditDebitStatement.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    narration = json["narration"];
    remark = json["remark"];
    amt = json["amt"].toString();
    type = json["type"];
    refno = json["refno"];
  }
}

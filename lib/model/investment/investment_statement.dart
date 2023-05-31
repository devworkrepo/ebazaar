import 'package:get/get.dart';

class InvestmentStatementResponse {


  late int code;
  String? status;
  String? message;
  String? totalcr;
  String? totaldr;
  String? balance;
  String? words;
  String? fdrefno;
  String? openamt;
  String? matureamt;
  String? roi;
  String? opendate;
  String? completedate;
  String? tenure;
  List<InvestmentStatement>? reportList;

  InvestmentStatementResponse();

  InvestmentStatementResponse.fromJson(Map<String, dynamic> json) {

    code = json["code"];
    status = json["status"];
    message = json["message"];
    totalcr = json["totalcr"];
    totaldr = json["totaldr"];
    balance = json["balance"];
    words = json["words"];
    fdrefno = json["fdrefno"];
    openamt = json["openamt"];
    matureamt = json["matureamt"];
    roi = json["roi"];
    opendate = json["opendate"];
    completedate = json["completedate"];
    tenure = json["tenure"];
    if (json["translist"] != null) {
      reportList = List.from(json['translist'])
          .map((e) => InvestmentStatement.fromJson(e))
          .toList();
    }
  }
}

class InvestmentStatement {

  String? date;
  String? narration;
  String? remark;
  String? in_amt;
  String? out_amt;
  String? in_charge;
  String? out_charge;
  String? in_comm;
  String? out_comm;
  String? in_tds;
  String? out_tds;
  String? balance;
  RxBool isExpanded = false.obs;


  InvestmentStatement.fromJson(Map<String, dynamic> json) {

    date = json["date"];
    narration = json["narration"];
    remark = json["remark"];
    in_amt = json["in_amt"];
    out_amt = json["out_amt"];
    in_charge = json["in_charge"];
    out_charge = json["out_charge"];
    in_comm = json["in_comm"];
    out_comm = json["out_comm"];
    in_tds = json["in_tds"];
    out_tds = json["out_tds"];
    balance = json["balance"];
  }
}

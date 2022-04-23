class TransactionSummary {

  String? aadhaarPayInProgress;
  String? aadhaarPayTRF;
  String? aepsInProgress;
  String? aepsMatmTRF;
  late int  code;
  String? creditCardTRF;
  String? creditInProgress;
  String? creditRefundPending;
  String? dmtInProgress;
  String? dmtRefundPending;
  String? fundReceived;
  String? message;
  String? moneyTransfer;
  String? payoutInProgress;
  String? payoutRefundPending;
  String? status;
  String? utilityInProgress;
  String? utilityRefundPending;
  String? utilityTRF;

  TransactionSummary();

  TransactionSummary.fromJson(Map<String,dynamic> json){
    aadhaarPayInProgress = json["aadharpay_inprogress"];
    aadhaarPayTRF = json["aadharpay_trf"];
    aepsInProgress = json["aeps_inprogress"];
    aepsMatmTRF = json["aeps_matm_trf"];
    code = json["code"];
    creditCardTRF = json["credit_card_trf"];
    creditInProgress = json["credit_inprogress"];
    creditRefundPending = json["credit_refundpending"];
    dmtInProgress = json["dmt_inprogress"];
    dmtRefundPending = json["dmt_refundpending"];
    fundReceived = json["fund_received"];
    message = json["message"];
    moneyTransfer = json["money_transfer"];
    payoutInProgress = json["payout_inprogress"];
    payoutRefundPending = json["payout_refundpending"];
    status = json["status"];
    utilityInProgress = json["utility_inprogress"];
    utilityRefundPending = json["utility_refundpending"];
    utilityTRF = json["utility_trf"];
  }


}

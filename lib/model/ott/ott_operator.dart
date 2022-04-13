class OttOperatorListResponse{
  late int code;
  String? status;
  String? message;
  List<OttOperator>? operators;
  OttOperatorListResponse();
  OttOperatorListResponse.fromJson(Map<String,dynamic> json){
    code = json["code"];
    status = json["status"];
    message = json["message"];
    operators = List.from(json["data"]).map((e) => OttOperator.fromJson(e)).toList();
  }

}

class OttOperator{
  String? operatorCode;
  String? operatorName;
  String? operatorPic;

  OttOperator.fromJson(Map<String,dynamic> json){
    operatorCode = json["ope_code"];
    operatorName = json["ope_name"];
    operatorPic = json["ope_pic"];
  }
}
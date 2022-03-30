class AepsBank{
  String? id;
  String? name;

  AepsBank._();

  AepsBank.fromJson(Map<String,dynamic> json){
    id = json["iinno"];
    name = json["bankName"];
  }
}

class AepsBankResponse{
  late int status;
  late String message;
  List<AepsBank>? aepsBankList;

  AepsBankResponse();

  AepsBankResponse.fromJson(Map<String,dynamic> json){
    status = json["status"];
    message = json["message"];
    if(json["bank_list"] != null ){
      aepsBankList = List<AepsBank>.from(json["bank_list"].map((e)=>AepsBank.fromJson(e)));
    }
  }
}
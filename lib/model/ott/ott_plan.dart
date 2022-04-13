class OttPlanResponse {
  late int code;
  String? message;
  String? status;
  List<OttPlan>? ottPlanList;

  OttPlanResponse();

  OttPlanResponse.fromJson(Map<String, dynamic> json) {
    code = json["code"];
    message = json["message"];
    status = json["status"];
    ottPlanList =
        List.from(json["planslist"]).map((e) => OttPlan.fromJson(e)).toList();
  }
}

class OttPlan {
  String? amount;
  String? duration;
  String? id;
  String? code;

  OttPlan.fromJson(Map<String, dynamic> json) {
    amount = json["amount"];
    duration = json["duration"];
    id = json["id"];
    code = json["code"];
  }
}

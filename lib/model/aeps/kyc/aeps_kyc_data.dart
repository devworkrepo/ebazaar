class AepsKycDataResponse {
  late final int status;
  late final String message;
  AepsKycData? details;

  AepsKycDataResponse();

  AepsKycDataResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    details = AepsKycData.fromJson(json['details']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['details'] = details?.toJson();
    return _data;
  }
}

class AepsKycData {
  String? agentName;
  String? agentId;
  String? mobile;
  String? panNumber;
  String? aadhaarNumber;
  String? merchantLoginId;
  int? id;

  AepsKycData.fromJson(Map<String, dynamic> json) {
    agentName = json['agent_name'];
    agentId = json['agent_id'];
    mobile = json['mobile'];
    panNumber = json['pan_number'];
    aadhaarNumber = json['aadhaar_number'];
    merchantLoginId = json['merchant_login_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_name'] = agentName;
    _data['agent_id'] = agentId;
    _data['mobile'] = mobile;
    _data['pan_number'] = panNumber;
    _data['aadhaar_number'] = aadhaarNumber;
    _data['merchant_login_id'] = merchantLoginId;
    _data['id'] = id;
    return _data;
  }
}

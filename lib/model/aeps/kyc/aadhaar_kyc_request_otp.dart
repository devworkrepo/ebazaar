class AadhaarKycRequestOtp{
  late int status;
  late String message;
  String? requestId;

  AadhaarKycRequestOtp();

  AadhaarKycRequestOtp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    requestId = json['request_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    data['request_id'] = requestId;
    return data;
  }
}
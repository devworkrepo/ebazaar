class DocumentKycDetailResponse {
  DocumentKycDetailResponse();
  late final int status;
  late final String message;
  DocumentKycDetail? data;

  DocumentKycDetailResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    data = DocumentKycDetail?.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['data'] = data?.toJson();
    return _data;
  }
}

class DocumentKycDetail {

  late final String shopImageStatus;
  late final String shopImage;
  late final String panCardImageStatus;
  late final String panCardImage;
  late final String aadhaarFrontImageStatus;
  late final String aadhaarCardImage;
  late final String aadhaarBackImageStatus;
  late final String aadhaarImgBack;
  late final String chequeImageStatus;
  late final String chequeImage;
  late final String profileImageStatus;
  late final String profilePicture;
  late final String gstImageStatus;
  late final String gstImage;
  late final int userId;

  DocumentKycDetail.fromJson(Map<String, dynamic> json){
    shopImageStatus = json['shop_image_status'];
    shopImage = json['shop_image'];
    panCardImageStatus = json['pan_card_image_status'];
    panCardImage = json['pan_card_image'];
    aadhaarFrontImageStatus = json['aadhaar_front_image_status'];
    aadhaarCardImage = json['aadhaar_card_image'];
    aadhaarBackImageStatus = json['aadhaar_back_image_status'];
    aadhaarImgBack = json['aadhaar_img_back'];
    chequeImageStatus = json['cheque_image_status'];
    chequeImage = json['cheque_image'];
    profileImageStatus = json['profile_image_status'];
    profilePicture = json['profile_picture'];
    gstImageStatus = json['gst_image_status'];
    gstImage = json['gst_image'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['shop_image_status'] = shopImageStatus;
    _data['shop_image'] = shopImage;
    _data['pan_card_image_status'] = panCardImageStatus;
    _data['pan_card_image'] = panCardImage;
    _data['aadhaar_front_image_status'] = aadhaarFrontImageStatus;
    _data['aadhaar_card_image'] = aadhaarCardImage;
    _data['aadhaar_back_image_status'] = aadhaarBackImageStatus;
    _data['aadhaar_img_back'] = aadhaarImgBack;
    _data['cheque_image_status'] = chequeImageStatus;
    _data['cheque_image'] = chequeImage;
    _data['profile_image_status'] = profileImageStatus;
    _data['profile_picture'] = profilePicture;
    _data['gst_image_status'] = gstImageStatus;
    _data['gst_image'] = gstImage;
    _data['user_id'] = userId;
    return _data;
  }
}
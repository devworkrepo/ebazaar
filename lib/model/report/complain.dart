import 'package:get/get.dart';

class ComplainListResponse {

  late final int status;
  late final String message;
  String? page;
  int? count;
  List<Complain>? complains;

  ComplainListResponse.fromJson(Map<String, dynamic> json){
    status = json['status'];
    message = json['message'];
    page = json['page'];
    count = json['count'];
    complains = List.from(json['complains']).map((e)=>Complain.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['message'] = message;
    _data['page'] = page;
    _data['count'] = count;
    _data['complains'] = complains?.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Complain {
  Complain({
    required this.complainId,
    required this.dateTime,
    required this.reportId,
    required this.complainType,
    required this.service,
    required this.txnAmount,
    required this.complainRemark,
    required this.updateRemark,
    required this.status,
    required this.statusId,
    required this.updatedTime,
  });
  int? complainId;
  String? dateTime;
  String? reportId;
  String? complainType;
  String? service;
  String? txnAmount;
  String? complainRemark;
  String? updateRemark;
  String? status;
  int? statusId;
  String? updatedTime;
  RxBool isExpanded = false.obs;

  Complain.fromJson(Map<String, dynamic> json){
    complainId = json['complainId'];
    dateTime = json['dateTime'];
    reportId = json['reportId'];
    complainType = json['complainType'];
    service = json['service'];
    txnAmount = json['txnAmount'];
    complainRemark = json['complainRemark'];
    updateRemark = json['updateRemark'];
    status = json['status'];
    statusId = json['statusId'];
    updatedTime = json['updatedTime'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['complainId'] = complainId;
    _data['dateTime'] = dateTime;
    _data['reportId'] = reportId;
    _data['complainType'] = complainType;
    _data['service'] = service;
    _data['txnAmount'] = txnAmount;
    _data['complainRemark'] = complainRemark;
    _data['updateRemark'] = updateRemark;
    _data['status'] = status;
    _data['statusId'] = statusId;
    _data['updatedTime'] = updatedTime;
    return _data;
  }
}
import 'package:flutter/material.dart';

class InAppUpdateData {
  InAppUpdateData();
  bool shouldUpdate = true;
  bool forceUpdate = true;

  InAppUpdateData.fromJson(Map<String, dynamic>? json ){
    shouldUpdate = json?['should_update'];
    forceUpdate = json?['force_update'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['should_update'] = shouldUpdate;
    _data['force_update'] = forceUpdate;
    return _data;
  }

  @override
  String toString() {
    return 'InAppUpdateData{shouldUpdate: $shouldUpdate, forceUpdate: $forceUpdate}';
  }
}

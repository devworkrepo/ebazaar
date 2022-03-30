import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateUtil {
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');

  static showDatePickerDialog(Function(String) onPick) async {
    DateTime? dateTime = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (dateTime != null) onPick(formatter.format(dateTime));
  }


  static String currentDateInYyyyMmDd(){
    return formatter.format(DateTime.now());
  }

}

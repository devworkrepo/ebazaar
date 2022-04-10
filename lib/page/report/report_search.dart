import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/drop_down.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/util/date_util.dart';


class CommonReportSeasrchDialog extends StatefulWidget {
  final String fromDate;
  final String toDate;
  final String? status;
  final String? inputFieldOneTile;

  final Function(String fromDate, String toDate, String searchInput,
      String searchInputType, String status) onSubmit;

  const CommonReportSeasrchDialog(
      {Key? key,
      required this.onSubmit,
      required this.fromDate,
      required this.toDate,
      this.status,
      this.inputFieldOneTile})
      : super(key: key);

  @override
  _SearchDialogWidgetState createState() => _SearchDialogWidgetState();
}

class _SearchDialogWidgetState extends State<CommonReportSeasrchDialog> {
  var fromDateController = TextEditingController();
  var toDateController = TextEditingController();
  var searchInputController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var searchInput = "";
  var status = "";
  var searchInputType = "";

  @override
  void initState() {
    super.initState();
    fromDateController.text = widget.fromDate;
    toDateController.text = widget.toDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                filterTitleAndIcon(),
                AppTextField(
                  controller: fromDateController,
                  label: "From Date",
                  onFieldTab: () {
                    DateUtil.showDatePickerDialog((dateInString) {
                      fromDateController.text = dateInString;
                    });
                  },
                ),
                AppTextField(
                  controller: toDateController,
                  label: "To Date",
                  onFieldTab: () {
                    DateUtil.showDatePickerDialog((dateInString) {
                      toDateController.text = dateInString;
                    });
                  },
                ),
                (widget.status != null) ? AppDropDown(
                  maxHeight: Get.height/0.75,
                  list: _listOfStatus,
                  label: "Select Status",
                  hint: "Select Status Search",
                  mode: Mode.BOTTOM_SHEET,
                  searchMode: false,
                  selectedItem:
                  (widget.status!.isNotEmpty) ? widget.status : null,
                  validator: (value) {
                    return null;
                  },
                  onChange: (value) {
                    status = value;
                  },
                ) : SizedBox(),
                (widget.inputFieldOneTile == null)
                    ? const SizedBox()
                    : AppTextField(
                        controller: searchInputController,
                        label: widget.inputFieldOneTile,
                        hint: "Enter ${widget.inputFieldOneTile}",
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  var fromDate = fromDateController.text.toString();
                  var tomDate = toDateController.text.toString();
                  var searchInput = searchInputController.text.toString();
                  Get.back();
                  widget.onSubmit(
                      fromDate, tomDate, searchInput, searchInputType, (status == "All") ? "" : status);
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search),
                      Text("Search"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterTitleAndIcon() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.filter_list),
          Text(
            "Filter",
            style: Get.textTheme.headline4,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    fromDateController.dispose();
    searchInputController.dispose();
    toDateController.dispose();
    super.dispose();
  }
}

var _listOfStatus = <String>[
  "All",
  "Success",
  "InProgress",
  "Initiated",
  "Failed",
  "Declined",
  "Refund Pending",
  "Refunded",
  "Scheduled",
];

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDropDown extends StatelessWidget {
  final List<String> list;
  final String hint;
  final String label;
  final Mode mode;
  final bool searchMode;
  final double? maxHeight;
  final Function(String?)? validator;
  final Function(String) onChange;
  final String? selectedItem;
  final bool hideLabel;

  const AppDropDown(
      {required this.list,
      required this.onChange,
      this.hint = "Required*",
      this.label = "Label",
      this.validator,
      this.hideLabel = false,
      this.searchMode = true,
      this.maxHeight,
      this.mode = Mode.BOTTOM_SHEET,
      this.selectedItem,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: DropdownSearch<String>(
        mode: mode,

        dropdownSearchDecoration:  InputDecoration(
          errorStyle: TextStyle(color: Colors.red[900],fontWeight: FontWeight.w500),
          prefixIcon: Icon(Icons.input),
          label: Text(label),
          labelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          alignLabelWithHint: false,
        ),
        showSelectedItems: true,
        items: list,
        showAsSuffixIcons: true,
        dropdownBuilderSupportsNullItem: true,
        dropdownBuilder:  (context,item){

          if(item == null) return SizedBox();
          return Text(item.toString(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),);
        },
        showSearchBox: searchMode,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        hint: hint,
        searchFieldProps: TextFieldProps(
            decoration: const InputDecoration(hintText: "Search")),
        popupSafeArea: const PopupSafeAreaProps(top: true),
        maxHeight: maxHeight,
        validator: (value) {
          if (validator != null) {
            return validator!(value);
          } else {
            if (value == null) {
              return "select $label";
            }
            if (value == "") {
              return "select $label";
            } else
              return null;
          }
        },
        selectedItem: selectedItem,
        onChanged: (value) => onChange(value.toString()),
      ),
    );
  }
}

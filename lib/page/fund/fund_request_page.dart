import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/drop_down.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/fund/fund_request_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/validator.dart';

class FundRequestPage extends GetView<FundRequestController> {
  const FundRequestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(FundRequestController());
    return Scaffold(
      appBar: _buildAppbar(),
      body: Obx(
          () => controller.bankTypeResponseObs.value.when(onSuccess: (data) {
                if (data.code == 1) {
                  return _buildBody();
                } else {
                  return ExceptionPage(error: Exception(data.message));
                }
              }, onFailure: (e) {
                return ExceptionPage(
                  error: e,
                );
              }, onInit: (data) {
                return ApiProgress(data);
              })),
    );
  }

  Padding _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                const FundRequestFormField(),
              ],
            ),
          )),
          AppButton(
              text: (controller.updateDetail != null) ? "Update Request" :  "Make Request",
              onClick: () => controller.onFundRequestSubmitButtonClick())
        ],
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      title:  Text("Fund Request ${(controller.updateDetail != null) ? "Update" : ""}"),
      actions: [
        PopupMenuButton<String>(
          onSelected: (i){
            Get.toNamed(RouteName.fundReportPage);
          },

          itemBuilder: (BuildContext context) {
            return {'Report'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}

class FundRequestFormField extends GetView<FundRequestController> {
  const FundRequestFormField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fundRequestFormKey,
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                  AppDropDown(
                    list: controller.typeList.map((e) => e.name!).toList(),
                    onChange: (value) {
                      controller.paymentType = value;
                    },
                    selectedItem: (controller.updateDetail != null) ? controller.updateDetail!.type : null,
                    label: "Payment Type",
                  ),
                AppDropDown(
                  list: controller.accountList.map((e) => e.name!).toList(),
                  onChange: (value) {
                    controller.paymentAccount = value;
                  },
                  selectedItem: (controller.updateDetail != null) ? controller.updateDetail!.bankAccountNumber : null,
                  label: "Payment Account",
                ),
                  AppTextField(
                    controller: controller.paymentDateController,
                    label: "Payment Date",
                    hint: "Required*",
                    onFieldTab: () {
                      DateUtil.showDatePickerDialog((dateTime) {
                        controller.selectedDate = dateTime;
                      });
                    },
                  ),
                ],
              ),
          ),
        ),


        Card(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  AppTextField(
                    controller: controller.uploadSlipController,
                    prefixIcon: Icons.file_copy_outlined,
                    label: "Upload Slip",
                    hint: "Required*",
                    onFieldTab: () =>
                        controller.showImagePickerBottomSheetDialog(),
                    validator: (value) {
                      return FormValidatorHelper.empty(value);
                    },
                  ),
                  AppTextField(controller: controller.remarkController,label: "Remark", hint: "Optional",),
                  AmountTextField(
                    controller: controller.amountController,
                    validator: (value) => FormValidatorHelper.amount(value,
                        minAmount: 1, maxAmount: 10000000),
                  ),
                ],
            ),
          ),
        )
      ],),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/model/virtual_account/virtual_account.dart';
import 'package:ebazaar/page/virtual_account/account/virtual_account_controller.dart';
import 'package:ebazaar/util/obx_widget.dart';
import 'package:ebazaar/widget/no_data_found.dart';

class VirtualAccountPage extends GetView<VirtualAccountController> {
  const VirtualAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VirtualAccountController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Virtual Account"),
      ),
      body: ObsResourceWidget<VirtualAccountDetailResponse>(
          obs: controller.responseObs,
          childBuilder: (data) {
            if (data.code == 1) {
              if (!(data.iciciVirtualAccount?.isexist ?? false)) {
                return _BuildItemListWidget(
                    VirtualAccountCreationType.iciciBank, data);
              }
              if ((data.iciciVirtualAccount?.isexist ?? false) &&
                  !(data.yesBankVirtualAccount?.isexist ?? false)) {
                return _BuildItemListWidget(
                    VirtualAccountCreationType.yesBank, data);
              }
              return _BuildItemListWidget(
                  VirtualAccountCreationType.none, data);
            } else {
              return NoItemFoundWidget(
                icon: Icons.info,
                message: data.message,
              );
            }
          }),
    );
  }
}

class _AddNewVirtualAccountWidget extends GetView<VirtualAccountController> {
  final VirtualAccountCreationType type;

  const _AddNewVirtualAccountWidget(this.type, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: () => controller.addNewVirtualAccount(type),
                child: const Icon(Icons.add),
                mini: true,
              ),
              const SizedBox(
                width: 16,
              ),
              Text(
                "Add New Virtual Account",
                style: Get.textTheme.headline6,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildItemListWidget extends GetView<VirtualAccountController> {
  final VirtualAccountCreationType type;
  final VirtualAccountDetailResponse response;

  const _BuildItemListWidget(this.type, this.response, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          (type == VirtualAccountCreationType.none)
              ? const SizedBox()
              : _AddNewVirtualAccountWidget(type),
          Expanded(
              child: ListView(
            children: [
              Card(
                child: Column(children: [

                  if ((response.iciciVirtualAccount?.isexist ?? false) ||
                      (response.yesBankVirtualAccount?.isexist ?? false))
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: Get.width,
                        child: Column(

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          const Text("Account Holder Name"),
                          Text(controller.appPreference.user.outletName ?? "",style: Get.textTheme.headline6,)
                        ],),
                      ),
                    ),

                    if (response.iciciVirtualAccount?.isexist ?? false)
                    _BuildIciciBankWidget(response.iciciVirtualAccount!),
                  if (response.yesBankVirtualAccount?.isexist ?? false)
                    _BuildYesBankWidget(response.yesBankVirtualAccount!),

                ],),
              ),
              if ((response.iciciVirtualAccount?.isexist ?? false) ||
                  (response.yesBankVirtualAccount?.isexist ?? false))  Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            "Payment Modes Accepted",
                            style: Get.textTheme.subtitle1,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            "IMPS, NEFT & RTGS",
                            style: Get.textTheme.bodyText1,
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ))
        ],
      ),
    );
  }
}

mixin _VirtualAccountWidgetMixin {
  buildCommonDetailWidget(
      String bankName, String accountNumber, String ifscCode) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           "A/C No :"+ accountNumber,
            style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Bank  : " + bankName,
            style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Ifsc    : " + ifscCode,
            style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _BuildYesBankWidget extends GetView<VirtualAccountController>
    with _VirtualAccountWidgetMixin {
  final YesBankVirtualAccount account;

  const _BuildYesBankWidget(this.account, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: buildCommonDetailWidget(
                      account.bank_name!, account.account_no!, account.ifsc!)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => controller.showQRCode(account),
                        icon: const Icon(
                          Icons.qr_code,
                          size: 32,
                          color: Colors.white70,
                        )),
                    const Text(
                      "Show\nQR",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white70),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _BuildIciciBankWidget extends StatelessWidget
    with _VirtualAccountWidgetMixin {
  final IciciVirtualAccount account;

  const _BuildIciciBankWidget(this.account, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Card(
        color: Get.theme.primaryColor,
        child: buildCommonDetailWidget(
            account.bank_name!, account.account_no!, account.ifsc!),
      ),
    );
  }
}

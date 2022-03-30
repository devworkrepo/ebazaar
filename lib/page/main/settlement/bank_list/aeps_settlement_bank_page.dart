import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/etns/on_string.dart';

import 'aeps_settlement_bank_controller.dart';

class AepsSettlementBankListPage extends GetView<AepsSettlementBankController> {
  const AepsSettlementBankListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AepsSettlementBankController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settlement Bank List"),
      ),
      body: Obx(() => controller.bankListResponseObs.value.when(
          onSuccess: (data) => (data.status == 1)
              ? const _BuildListBody()
              : ExceptionPage(error: Exception(data.message)),
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => ApiProgress(data))),
    );
  }
}

class _BuildListBody extends GetView<AepsSettlementBankController> {
  const _BuildListBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAddBankWidget(() =>
            Get.toNamed(RouteName.aepsSettlementAddBankPage)?.then((value) {
              if (value) {
                controller.fetchBankList();
              }
            })),
        Expanded(
            child: ListView.builder(
                itemCount: controller.banks.length,
                itemBuilder: (context, index) {
                  return _BuildListItem(controller.banks[index]);
                }))
      ],
    );
  }

  Widget _buildAddBankWidget(VoidCallback onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
          child: Row(
            children: [
              const FloatingActionButton(
                elevation: 0,
                mini: true,
                onPressed: null,
                backgroundColor: Colors.green,
                child: Icon(Icons.add),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Add New Settlement Bank",
                  style: Get.textTheme.subtitle1,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildListItem extends GetView<AepsSettlementBankController> {
  final AepsSettlementBank bank;

  const _BuildListItem(this.bank, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildBankDetail(),
            const SizedBox(
              width: 8,
            ),
            _buildLeftSideWidget()
          ],
        ),
      ),
    );
  }

  _buildLeftSideWidget() {
    if (bank.statusId == 1) {
      return Column(
        children: [_buildSendWidget(), _buildStatus(1)],
      );
    } else if (bank.statusId == 3) {
      return Column(
        children: [
          (bank.documentStatus == "0")
              ? _buildUploadWidget()
              : _buildUploadedWidget(),
          _buildStatus(3),
        ],
      );
    } else {
      return _buildStatus(2);
    }
  }

  Container _buildUploadedWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey)),
      child: Row(
        children: const [
          Icon(
            Icons.check_circle_outline_outlined,
            color: Colors.green,
          ),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Text(
              "Screening",
              style: TextStyle(color: Colors.green),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUploadWidget() {
    return GestureDetector(
      onTap: ()=> controller.onUpload(bank.id!),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey)),
        child: Row(
          children: const [
            Icon(
              Icons.file_copy,
              color: Colors.black54,
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text(
                "Upload\nDocuments",
                style: TextStyle(color: Colors.black54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSendWidget() {
    return GestureDetector(
      onTap: () => Get.toNamed(RouteName.aepsSettlementTransferPage,
          arguments: {"bank": bank}),
      child: Transform.rotate(
          angle: 5.5,
          child: const Icon(
            Icons.send,
            size: 32,
          )),
    );
  }

  Widget _buildStatus(int status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        (status == 1)
            ? "Active"
            : (status == 3)
                ? "Pending for\n approval"
                : "Rejected",
        style: Get.textTheme.bodyText1?.copyWith(
            fontSize: 12,
            color: (status == 1)
                ? Colors.green
                : (status == 3)
                    ? Colors.yellow[900]!
                    : Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Expanded _buildBankDetail() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              bank.name!.trim().orNA(),
              style: Get.textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              bank.bankName ?? "N/A",
              style: Get.textTheme.subtitle1?.copyWith(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              bank.accountNumber ?? "N/A",
              style: Get.textTheme.subtitle1?.copyWith(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w400),
            ),
          ),
          /*  Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Text(
              "IFSC : " + bank.ifsc.orNA(),
              style: Get.textTheme.bodyText2?.copyWith(
                  color: Colors.grey[700], fontWeight: FontWeight.w400),
            ),
          ),*/
          (bank.remark.orEmpty().trim().isEmpty)
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Text(
                    bank.remark ?? "",
                    style: Get.textTheme.bodyText2?.copyWith(
                        color: (bank.statusId == 1)
                            ? Colors.green
                            : (bank.statusId == 3)
                                ? Colors.yellow[900]!
                                : Colors.red),
                  ),
                ),
        ],
      ),
    ));
  }
}

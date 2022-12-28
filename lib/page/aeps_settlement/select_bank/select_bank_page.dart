import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/page/report/report_helper.dart';
import 'package:spayindia/util/obx_widget.dart';
import 'package:spayindia/widget/list_component.dart';
import 'package:spayindia/widget/no_data_found.dart';

import '../../../res/style.dart';
import '../../../route/route_name.dart';
import '../../../widget/text_field.dart';
import 'select_bank_controller.dart';

class SelectAepsSettlementBankPage
    extends GetView<SelectSettlementBankController> {
  const SelectAepsSettlementBankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SelectSettlementBankController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aeps Settlement Banks"),
      ),
      body:Stack(
        children: [
          Column(children: [
            _addNewBankWidget(),
            Expanded(child:  ObsResourceWidget<AepsSettlementBankListResponse>(
              obs: controller.responseObs,
              childBuilder: (data) {
                if (data.code == 1) {
                  if (data.banks!.isNotEmpty) {
                    return _BankListWidget();
                  } else {
                    return const NoItemFoundWidget();
                  }
                } else if (data.code == 2) {
                  return const NoItemFoundWidget();
                } else {
                  return NoItemFoundWidget(
                    icon: Icons.info,
                    message: data.message,
                  );
                }
              },
              handleCode: true,
            ))
          ],),
          Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                width: Get.width,
                decoration: AppStyle.searchDecoration(
                    color: Colors.black38, borderRadius: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        onChange: controller.onSearchChange,
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Widget _addNewBankWidget() {
    return SizedBox(
      width: Get.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Row(
                children: [
                  Expanded(
                    child: _buildHeaderIcon(
                        "Add Account", Icons.add, Colors.green,(){
                      Get.toNamed(AppRoute.addSettlementBank, arguments: true);
                    }),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: _buildHeaderIcon(
                        "Import Accounts", Icons.sync, Colors.blue,(){
                          controller.onImportClick();
                    }),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(String title, IconData iconData, Color color,VoidCallback callback) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: callback,
          child: Row(
            children: [
              Icon(iconData),
              SizedBox(
                width: 8,
              ),
              Text(title),
            ],
          ),
          style: ElevatedButton.styleFrom(primary: color),
        )
      ],
    );
  }

}

class _BankListWidget extends GetView<SelectSettlementBankController> {

  const _BankListWidget( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Obx(()=>ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.beneficiaryListObs.length,
          itemBuilder: (context, index) {
            AepsSettlementBank bank = controller.beneficiaryListObs[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.blue[900],
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    (bank.accountName ?? "NA"),
                                    style: Get.textTheme.subtitle1
                                        ?.copyWith(color: Colors.blue[900]),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.account_balance),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        bank.accountNumber ?? "NA",
                                        style: Get.textTheme.subtitle1,
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        (bank.bankName ?? "NA"),
                                        style: Get.textTheme.subtitle2
                                            ?.copyWith(
                                            color: Colors.grey[600]),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        (bank.ifscCode ?? "NA"),
                                        style: Get.textTheme.subtitle2
                                            ?.copyWith(
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.onDeleteClick(bank),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.delete_forever,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red, onPrimary: Colors.black),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    ElevatedButton(
                      onPressed: () => controller.onTransferClick(bank),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.send,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Transfer",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.black),
                    )
                  ],
                ),
                const Divider(
                  indent: 0,
                )
              ],
            );
          })),
    );
  }


}

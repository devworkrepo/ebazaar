import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/progress.dart';
import 'package:spayindia/page/dmt/beneficiary_list/beneficiary_controller.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/dmt_beneficiary_list_item.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/dmt_kyc_info_dialog.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/sender_header.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';

class BeneficiaryListPage extends GetView<BeneficiaryListController> {
  const BeneficiaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BeneficiaryListController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () =>controller.addBeneficiary(),
        child: const Icon(Icons.add),
      ),
      body: Obx(() => controller.beneficiaryResponseObs.value.when(
          onSuccess: (data) => _buildBody(),
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => AppProgressbar(
                data: data,
              ))),
    );
  }

  CustomScrollView _buildBody() {
    return CustomScrollView(
              slivers: [
                _buildSilverAppbar(),
                _buildSilverList(),
              ],
            );
  }

  SliverAppBar _buildSilverAppbar() {
    return SliverAppBar(
      actions: [
        PopupMenuButton<String>(
          onSelected: (i){
            controller.fetchKycInfo();
          },

          itemBuilder: (BuildContext context) {
            return {'Kyc Info'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
      expandedHeight: 180,
      pinned: true,
      title: const Text("Beneficiary List"),
      flexibleSpace: FlexibleSpaceBar(
        background: BeneficiarySenderHeader(
          mobileNumber: controller.sender?.senderNumber ?? "",
          senderName: controller.sender?.senderNameObs.value ?? "",
          limit: controller.sender?.impsNKycLimitView ?? "",
          onClick: () {
            Get.toNamed(RouteName.dmtBeneficiaryAddPage, arguments: {
              "mobile": controller.sender!.senderNumber!,
              "dmtType": controller.dmtType
            })?.then((value) {
              if (value != null) {
                if (value) {
                  controller.fetchBeneficiary();
                }
              }
            });
          },
        ),
      ),
    );
  }

  SliverList _buildSilverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {

          var bottomPadding = 1.0;
          if(index == controller.beneficiaries.length -1){
            bottomPadding = 120.0;
          }

          return Padding(
            padding:  EdgeInsets.only(left: 7,right: 7,bottom: bottomPadding,top: 1),
            child: DmtBeneficiaryListItem(index),
          );
        },
        childCount: controller.beneficiaries.length,
      ),
    );
  }
}

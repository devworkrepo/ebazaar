import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/dmt/beneficiary_list/beneficiary_controller.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/dmt_beneficiary_list_item.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/sender_header.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/obx_widget.dart';

class BeneficiaryListPage extends GetView<BeneficiaryListController> {
  const BeneficiaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(BeneficiaryListController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.addBeneficiary(),
        child: const Icon(Icons.add),
      ),
      body: ObsResourceWidget(
          obs: controller.beneficiaryResponseObs,
          childBuilder: (data)=>_buildBody())
      /*Obx(() => controller.beneficiaryResponseObs.value.when(
          onSuccess: (data) => _buildBody(),
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => AppProgressbar(
                data: data,
              )))*/
      ,
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
        PopupMenuButton<BeneficiaryListPopMenu>(
          onSelected: (i)=>controller.onSelectPopupMenu(i),
          itemBuilder: (BuildContext context) {
            return controller.popupMenuList().map((BeneficiaryListPopMenu choice) {
              return PopupMenuItem<BeneficiaryListPopMenu>(
                value: choice,
                child: Row(children: [
                  Icon(choice.icon,size: 24,color: Colors.black,),
                  const SizedBox(width: 8,),
                  Text(choice.title)
                ],),
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


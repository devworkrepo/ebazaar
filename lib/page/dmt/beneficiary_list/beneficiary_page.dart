import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/dmt/beneficiary_list/beneficiary_controller.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/dmt_beneficiary_list_item.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/sender_header.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/exception.dart';
import 'package:spayindia/widget/api_component.dart';

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
      body: Obx(
          () => controller.beneficiaryResponseObs.value.when(onSuccess: (data) {
                if (data.code == 1) {
                  return _buildBody();
                } else {
                  return ExceptionPage(
                      error: UnknownException(message: data.message));
                }
              }, onFailure: (e) {
                return ExceptionPage(error: e);
              }, onInit: (data) {
                return ApiProgress(data);
              }))
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
                child: Row(
                  children: [
                    Icon(
                      choice.icon,
                      size: 24,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(choice.title)
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
      expandedHeight: (controller.sender!.isKycVerified ?? false) ? 190 : 270,
      pinned: true,
      title: const Text("Beneficiary List"),
      flexibleSpace: FlexibleSpaceBar(background: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BeneficiarySenderHeader(
                mobileNumber: controller.sender?.senderNumber ?? "",
                senderName: controller.sender?.senderName ?? "",
                limit: controller.sender?.impsNKycLimitView ?? "",
                onClick: () {
                  Get.toNamed(AppRoute.dmtBeneficiaryAddPage, arguments: {
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
              (controller.sender!.isKycVerified ?? false)
                  ? const SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              "You can get monthly sender limit upto 2 Lac by doing EKYC of Customer.",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Get.toNamed(AppRoute.senderKycPage,arguments: {
                                  "dmt_type" : controller.dmtType,
                                  "mobile_number" : controller.sender!.senderNumber!
                                });
                              }, child: Text("Do Kyc"))
                        ],
                      ),
                    )
            ],
          );
        },
      )),
    );
  }

  SliverList _buildSilverList() {
    var mList = controller.beneficiaries;
    var isListEmpty = mList.isEmpty;
    var mCount = mList.length;
    if (isListEmpty) {
      mCount = 1;
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (_, int index) {
          if (isListEmpty) {
            return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
              "No beneficiary found!",
              style: Get.textTheme.headline3,
            ),
                ));
          } else {
            var bottomPadding = 1.0;
            if (index == controller.beneficiaries.length - 1) {
              bottomPadding = 120.0;
            }

            return Padding(
              padding: EdgeInsets.only(
                  left: 7, right: 7, bottom: bottomPadding, top: 1),
              child: DmtBeneficiaryListItem(index),
            );
          }
        },
        childCount: mCount,
      ),
    );
  }
}


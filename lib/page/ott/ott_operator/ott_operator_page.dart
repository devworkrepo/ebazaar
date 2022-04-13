import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/ott/ott_operator.dart';
import 'package:spayindia/page/ott/ott_operator/ott_operator_controller.dart';
import 'package:spayindia/util/obx_widget.dart';

class OttOperatorPage extends GetView<OttOperatorController> {
  const OttOperatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(OttOperatorController());
    return Scaffold(
      appBar: AppBar(title: const Text("OTT Subscription")),
      body: ObsResourceWidget(
        obs: controller.operatorsResponseObs,
        childBuilder: (data) => const _BuildBody(),
      ),
    );
  }
}

class _BuildBody extends GetView<OttOperatorController> {
  const _BuildBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var itemCount = controller.operatorList.length;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12, left: 12, right: 12),
      child: Card(
        child: GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          children: List.generate(
            itemCount,
            (index) => _buildItem(controller.operatorList[index], index),
          ),
        ),
      ),
    );
    ;
  }

  _buildItem(OttOperator operator, int index) {
    return Padding(
      padding:  const EdgeInsets.all(12.0),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: ()=>controller.onItemTap(operator),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue,width: 1)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CachedNetworkImage(
                imageUrl: "https://spayindia.in/img/"+operator.operatorPic.toString(),
                errorWidget: (context, url, error) => const Expanded(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                  Icons.image_not_supported_outlined,
                ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

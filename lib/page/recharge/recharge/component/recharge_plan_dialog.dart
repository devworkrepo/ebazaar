import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/recharge/recharge_plan.dart';

class RechargePlanDialogWidget extends StatelessWidget {
  final List<RechargePlan> rechargePlanList;
  final Function(RechargePlan) onItemClick;

  const RechargePlanDialogWidget(
      {required this.rechargePlanList, required this.onItemClick, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recharge plan"),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: rechargePlanList.length,
          itemBuilder: (context, index) {
            return _buildRechargePlanItem(rechargePlanList[index]);
          }),
    );
  }

  Widget _buildRechargePlanItem(RechargePlan rechargePlan) {
    return GestureDetector(
      onTap: () {
        onItemClick(rechargePlan);
        Get.back();
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rs. " + rechargePlan.rs,
                  style: Get.textTheme.headline5,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(child: Text(rechargePlan.desc))
              ],
            ),
          ),
          const Divider(
            height: 40,
          ),
        ],
      ),
    );
  }
}

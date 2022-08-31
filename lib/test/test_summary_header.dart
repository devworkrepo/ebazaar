import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/res/color.dart';

class TestSummaryHeaderPage extends StatelessWidget {
  const TestSummaryHeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary",
              style: Get.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                buildItem(
                  title: "Amount Credited",
                  value: "0",
                    color: Colors.green
                ),
                buildItem(
                  title: "Amount Debited",
                  value: "0",
                    color: Colors.red
                ),
                buildItem(
                    title: "Charges Deducted", value: "0", color: Colors.red),
                buildItem(
                    title: "Charges Reversed", value: "0", color: Colors.green),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                buildItem(
                  title: "Commission Credited",
                  value: "0",
                    color: Colors.green
                ),
                buildItem(
                  title: "Commission Reversed",
                  value: "0",
                    color: Colors.red
                ),
                buildItem(
                  title: "TDS \nDeducted",
                  value: "0",
                    color: Colors.red
                ),
                buildItem(
                  title: "TDS\nReversed",
                  value: "0",
                  color: Colors.green
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Transaction",
              style: Get.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildItem(
      {required String title,
      required String value,
      bool isRupee = true,
      Color? color}) {
    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 0.5),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text((isRupee) ? "₹ $value" : "$value",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: (color == null) ? Colors.black : color)),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  color: (color == null) ? Colors.grey[600] : color.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

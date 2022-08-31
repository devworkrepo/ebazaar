import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';

class SummaryHeader {
  final String title;
  final String value;
  final bool isRupee;
  final Color? backgroundColor;

  SummaryHeader(
      {required this.title,
      required this.value,
      this.isRupee = true,
      this.backgroundColor});
}

class SummaryHeaderWidget extends StatelessWidget {
  final List<SummaryHeader> summaryHeader1;
  final List<SummaryHeader?>? summaryHeader2;
  final String? totalCreditedAmount;
  final String? totalDebitedAmount;
  final VoidCallback callback;

  const SummaryHeaderWidget(
      {required this.summaryHeader1,
      required this.callback,
      this.summaryHeader2,
      this.totalCreditedAmount,
      this.totalDebitedAmount,
      Key? key})
      : super(key: key);

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
            if (totalCreditedAmount != null && totalDebitedAmount != null)
              _BuildAmountSectionWidget(
                  totalDebitedAmount, totalCreditedAmount),
            Text(
              "Summary",
              style: Get.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...summaryHeader1.map((e) => buildItem(summaryHeader: e))
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...?summaryHeader2?.map((e) => buildItem(summaryHeader: e))
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: () {
                callback();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Transaction",
                      style: Get.textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Get.theme.primaryColor, width: 1)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_list_sharp,
                          color: Get.theme.primaryColor,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          "Filter",
                          style: TextStyle(color: Get.theme.primaryColor),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Expanded buildItem({required SummaryHeader? summaryHeader}) {
    if (summaryHeader == null) {
      return const Expanded(flex: 1, child: SizedBox());
    }

    return Expanded(
      flex: 1,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        decoration: (summaryHeader.backgroundColor != null)
            ? BoxDecoration(
                color: summaryHeader.backgroundColor,
                borderRadius: BorderRadius.circular(4))
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey[600]!, width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                (summaryHeader.isRupee)
                    ? "₹${summaryHeader.value == "null" ? "0" : summaryHeader.value}"
                    : (summaryHeader.value == "null")
                        ? "0"
                        : summaryHeader.value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: (summaryHeader.backgroundColor != null)
                        ? Colors.white
                        : Colors.black)),
            const SizedBox(
              height: 8,
            ),
            Spacer(),
            Text(
              summaryHeader.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                color: (summaryHeader.backgroundColor == null)
                    ? Colors.black.withOpacity(0.8)
                    : Colors.white.withOpacity(0.9),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildAmountSectionWidget extends StatelessWidget {
  final String? totalDebitedAmount;
  final String? totalCreditedAmount;

  const _BuildAmountSectionWidget(
      this.totalDebitedAmount, this.totalCreditedAmount);

  @override
  Widget build(BuildContext context) {
    var appPreference = Get.find<AppPreference>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Your Available Balance",
          style: TextStyle(
              fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "₹ ${appPreference.user.availableBalance}",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[800]),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            _buildItem(Colors.green[800], "Total Amount\nCredited",
                totalCreditedAmount!),
            SizedBox(
              width: 8,
            ),
            _buildItem(
                Colors.red[800], "Total Amount\nDebited", totalDebitedAmount!),
          ],
        ),
        SizedBox(
          height: 12,
        )
      ],
    );
  }

  Expanded _buildItem(Color? backgroundColor, String title, String value) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: Column(
        children: [
          Text(
            "₹ $value",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            title,
            style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                fontSize: 14),
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }
}

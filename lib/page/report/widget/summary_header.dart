import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SummaryHeader {
  final String title;
  final String value;
  final bool isRupee;
  final Color? color;

  SummaryHeader(
      {required this.title,
      required this.value,
      this.isRupee = true,
      this.color});
}

class SummaryHeaderWidget extends StatelessWidget {
  final List<SummaryHeader> summaryHeader1;
  final List<SummaryHeader?>? summaryHeader2;
  final VoidCallback callback;

  const SummaryHeaderWidget(
      {required this.summaryHeader1,required this.callback, this.summaryHeader2, Key? key})
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
            Text(
              "Summary",
              style: Get.textTheme.headline6
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                ...summaryHeader1.map((e) => buildItem(summaryHeader: e))
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                ...?summaryHeader2?.map((e) => buildItem(summaryHeader: e))
              ],
            ),
            const SizedBox(
              height: 12,
            ),
           GestureDetector(
             onTap: (){
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
                   padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(30),
                     border: Border.all(color:Get.theme.primaryColor,width: 1)
                   ),
                   child: Row(
                     children: [
                       Icon(Icons.filter_list_sharp,color: Get.theme.primaryColor,),
                       const SizedBox(width: 8,),
                       Text("Filter",style: TextStyle(color: Get.theme.primaryColor),)
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
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Get.theme.primaryColor, width: 0.5),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Text(
                (summaryHeader.isRupee)
                    ? "₹ ${summaryHeader.value == "null" ? "0" : summaryHeader.value}"
                    : (summaryHeader.value == "null") ? "0" : summaryHeader.value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: (summaryHeader.color == null)
                        ? Colors.black
                        : summaryHeader.color)),
            Text(
              summaryHeader.title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: (summaryHeader.color == null)
                      ? Get.theme.primaryColor
                      : summaryHeader.color?.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}

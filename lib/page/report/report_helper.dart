import 'package:flutter/material.dart';
import 'package:spayindia/component/button.dart';

enum TransactionReportType {
  ledger,
  aeps,
  aepsAll,
  settlement,
  dmt,
  upi,
  billPayment,
  recharge

}

class ReportHelperWidget{
 static int getStatusId(String? status) {
    if (status == null) {
      return 0;
    }
    else if (status.toLowerCase() == "declined") {
      return 2;
    }
    else if (status.toLowerCase() == "accepted" ||
        status.toLowerCase() == "accept" || status.toLowerCase() == "success"){
      return 1;
    }
    else if(status.toLowerCase() == "initiated"){
      return 4;
    }
    else {
      return 3;
    }
  }

}

class BuildComplainAndPrintWidget extends StatelessWidget {
  final bool? print;
  final bool? complain;
  final bool? checkStatus;
  final VoidCallback? onComplainClick;
  final VoidCallback? onPrintClick;
  final VoidCallback? onCheckStatusClick;

  const BuildComplainAndPrintWidget(
      {Key? key,
      this.print = false,
      this.complain = false,
      this.checkStatus = false,
      this.onComplainClick,
      this.onPrintClick,
      this.onCheckStatusClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (complain ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(text: "Complain", onClick: onComplainClick),
              ))
            : const SizedBox(),
        (print ?? false)
            ? const SizedBox(
                width: 16,
              )
            : const SizedBox(),
        (print ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(text: "Print", onClick: onPrintClick),
              ))
            : const SizedBox(),
        (checkStatus ?? false)
            ? const SizedBox(
                width: 16,
              )
            : const SizedBox(),
        (checkStatus ?? false)
            ? Expanded(
                child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: AppButton(
                    text: "Check Status", onClick: onCheckStatusClick),
              ))
            : const SizedBox()
      ],
    );
  }
}

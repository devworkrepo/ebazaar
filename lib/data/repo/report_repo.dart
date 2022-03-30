import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/report/aeps_success.dart';
import 'package:spayindia/model/report/complain.dart';
import 'package:spayindia/model/report/ledger.dart';
import 'package:spayindia/model/report/print_receipt.dart';
import 'package:spayindia/model/user/user.dart';

abstract class ReportRepo{

  Future<MoneyReportResponse> fetchMoneyTransactionList(data);

}
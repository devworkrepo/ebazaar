import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/report/aeps_success.dart';
import 'package:spayindia/model/report/complain.dart';
import 'package:spayindia/model/report/ledger.dart';
import 'package:spayindia/model/report/print_receipt.dart';
import 'package:spayindia/service/network_client.dart';

class ReportRepoImpl extends ReportRepo{
  
  NetworkClient client = Get.find();

  @override
  Future<MoneyReportResponse> fetchMoneyTransactionList (data) async{
    var response = await  client.post("/GetTransactionList",data: data);
    return MoneyReportResponse.fromJson(response.data);
  }

}
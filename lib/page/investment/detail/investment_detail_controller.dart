import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/investment/investment_list.dart';
import 'package:spayindia/page/investment/detail/investment_close_calc_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class InvestmentDetailController extends GetxController{

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  InvestmentListItem item = Get.arguments!;


  void fetchCloseCalc() async {

    StatusDialog.progress(title: "Fetching Detail");
    await Future.delayed(Duration(seconds: 2));
    var response = await repo.fetchCloseCalc({});
    Get.back();
    if(response.code ==1){
      Get.bottomSheet(InvestmentCloseCalcDialog(response));
    }
    else {
      StatusDialog.alert(title: response.message);
    }

  }



}
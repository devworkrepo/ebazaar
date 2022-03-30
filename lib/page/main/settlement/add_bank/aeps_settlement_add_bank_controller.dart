import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';

class AepsSettlementAddBankController extends GetxController{

  AepsRepo repo = Get.find<AepsRepoImpl>();

  final ifscController = TextEditingController();
  final accountNumberController = TextEditingController();
  final confirmAccountNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var bankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  late List<AepsBank> banks;

 AepsBank? selectedBank;

  @override
  void onInit() {
    super.onInit();
    _fetchBankList();
  }

  void addBank()  async{

    try{
      StatusDialog.progress();
      var param = {
        "bank_name" : selectedBank?.name ?? "",
        "account_number" : accountNumberController.text.toString(),
        "confirm_account_number" : accountNumberController.text.toString(),
        "ifsc" : ifscController.text.toString(),
      };
      var response = await repo.addSettlementBank(param);
      Get.back();

      if(response.status == 1){
        StatusDialog.success(title: response.message).then((value) => Get.back(result: true));
      }
      else {
        StatusDialog.failure(title: response.message);
      }


    }catch(e){
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }

  }


  _fetchBankList() async {

    try{
      bankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsBankList();
     /* if(response.status == 1){
        banks = response.aepsBankList!;
      }*/
     // bankListResponseObs.value = Resource.onSuccess(response);
    }catch(e){
      bankListResponseObs.value = Resource.onFailure(e);
    }
  }
  
}
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:spayindia/widget/common/confirm_amount_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/money_request/bank_dertail.dart';
import 'package:spayindia/model/money_request/update_detail.dart';
import 'package:spayindia/page/fund/component/bond_dialog.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:spayindia/util/picker_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../exception_page.dart';

class FundRequestController extends GetxController with TransactionHelperMixin {
  MoneyRequestRepo repo = Get.find<MoneyRequestImpl>();
  AppPreference appPreference = Get.find();

  GlobalKey<FormState> fundRequestFormKey = GlobalKey<FormState>();

  String selectedDate = DateUtil.formatter.format(DateTime.now());

  TextEditingController paymentDateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  TextEditingController uploadSlipController = TextEditingController();
  File? selectedImageFile;
  var paymentTypeObs = "".obs;
  var paymentAccountObs = "".obs;

  var bankTypeResponseObs = Resource
      .onInit(data: BankTypeDetailResponse())
      .obs;
  late BankTypeDetailResponse detail;
  late List<MoneyRequestType> typeList;
  late List<MoneyRequestBank> accountList;


  MoneyRequestUpdateResponse? updateDetail = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    paymentDateController.text = selectedDate;
    _fetchBankTypeDetails();
  }

  _fetchBankTypeDetails() async {
    try {
      bankTypeResponseObs.value = const Resource.onInit();
      var response = await repo.fetchBankType();

      if (response.code == 1) {
        detail = response;
        typeList = response.typeList!;
        accountList = response.accountList!;

        setupUpdateDetailData();
      }
      bankTypeResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      bankTypeResponseObs.value = Resource.onFailure(e);
    }
  }

  void setupUpdateDetailData() {
     if (updateDetail != null) {
      remarkController.text = updateDetail!.remark!;
      amountController.text = updateDetail!.amount!;
      uploadSlipController.text = updateDetail!.picName!;
      paymentDateController.text = updateDetail!.depositDate!;

      paymentAccountObs.value = updateDetail!.bankAccountNumber!;
      paymentTypeObs.value = updateDetail!.type!;
    }
  }

  @override
  void dispose() {
    paymentDateController.dispose();
    amountController.dispose();
    remarkController.dispose();
    uploadSlipController.dispose();

    super.dispose();
  }

  showImagePickerBottomSheetDialog() async {
    /*File? imageFile = await NativeCall.captureImage();
    selectedImageFile = imageFile;
    if (imageFile == null) {
      uploadSlipController.text = "";
    } else {
      uploadSlipController.text = path.basename(selectedImageFile!.path);
    }*/

     ImagePickerHelper.pickImageWithCrop((File? image) {
      selectedImageFile = image;
      if (image == null) {
        uploadSlipController.text = "";
      } else {
        var fileName = path.basename(selectedImageFile!.path);
        if(fileName.contains("..")){
          fileName = fileName.replaceAll("..", ".");
        }
        uploadSlipController.text =fileName ;
      }
    },(){
       selectedImageFile = null;
       uploadSlipController.text = "Uploading please wait...";
     });
  }



  onFundRequestSubmitButtonClick() async {
    bool isValid = fundRequestFormKey.currentState!.validate();
    if (!isValid) return;
    _confirmDialog();
  }

  _makeFundRequest() async {
    StatusDialog.progress();
    try {
      var formDataParam = await _moneyRequestParam();
      CommonResponse response = (updateDetail!=null)
          ? await repo.updateRequest(formDataParam)
          : await repo.makeRequest(formDataParam);

      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back(result: true));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      AppUtil.logger("error : " + e.toString());
      Get.to(() => ExceptionPage(
          error: Exception(
              "Error while making fund request, transaction may be success please "
              "check report or try with different "
              "image(capture using phone camera)")));
    }
  }

  _moneyRequestBond() async {
    StatusDialog.progress();
    try {
      BondResponse response =
          await repo.requestBond(await _moneyRequestParam());

      Get.back();

      if (response.code == 1) {
        Get.dialog(BondDialog(
          data: response.content!,
          onAccept: () {_makeFundRequest();},
          onReject: () {
            StatusDialog.failure(title: "Just you reject the bond, without accept it you can't be money request!");
          },
        ));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {

      Get.back();
      Get.to(() => ExceptionPage(error: Exception(e)));
    }
  }

  Future<dio.FormData> _moneyRequestParam() async {
    dio.MultipartFile? fileData;
    if (selectedImageFile != null) {
      fileData = await dio.MultipartFile.fromFile(selectedImageFile!.path,
          filename:
              selectedImageFile!.path.split("/").last.replaceAll("..", "."));
    }
    var param = {
      "sessionkey": appPreference.sessionKey,
      "dvckey": await AppUtil.getDeviceID(),
      "transaction_no": detail.transactionNumber!,
      "paymenttype": paymentTypeObs.value,
      "bankaccount": paymentAccountObs.value,
      "date": paymentDateController.text,
      "remark": (remarkController.text.isEmpty) ? "Transaction" : remarkController.text,
      "amount": amountController.text,
      "images ": fileData,
    };

    if(updateDetail !=null){
      var requestId = updateDetail?.requestId ?? "";
      param.addIf(true, "requestid", requestId);
    }

    return dio.FormData.fromMap(param);
  }

  _confirmDialog() {
    Get.dialog(AmountConfirmDialogWidget(
        title: "Confirm Request ?",
        amount: amountController.text.toString(),
        onConfirm: () {

          _moneyRequestBond();
        }));
  }

}
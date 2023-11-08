import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import 'package:ebazaar/util/mixin/location_helper_mixin.dart';
import 'package:ebazaar/widget/common/confirm_amount_dialog.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/data/repo/money_request_repo.dart';
import 'package:ebazaar/data/repo_impl/money_request_impl.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/money_request/bank_dertail.dart';
import 'package:ebazaar/model/money_request/update_detail.dart';
import 'package:ebazaar/page/fund/component/bond_dialog.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/app_util.dart';
import 'package:ebazaar/util/date_util.dart';
import 'package:ebazaar/util/mixin/transaction_helper_mixin.dart';
import 'package:ebazaar/util/picker_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../exception_page.dart';

class FundRequestController extends GetxController with TransactionHelperMixin, LocationHelperMixin {
  MoneyRequestRepo repo = Get.find<MoneyRequestImpl>();
  AppPreference appPreference = Get.find();

  GlobalKey<FormState> fundRequestFormKey = GlobalKey<FormState>();

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
    paymentDateController.text = DateUtil.formatter.format(DateTime.now());

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    _fetchBankTypeDetails();
    validateLocation(progress: false);
    });
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

     ImagePickerHelper.pickImageWithCrop((File? image) {
      selectedImageFile = image;
      if (image == null) {
        uploadSlipController.text = "";
      } else {
       var fileName =  selectedImageFile!.path.split("/").last;
       var fileExtension = path.extension(fileName);
        uploadSlipController.text ="spay_receipt_${DateTime.now().millisecondsSinceEpoch}"+fileExtension;
      }
    },(){
       selectedImageFile = null;
       uploadSlipController.text = "Uploading please wait...";
     });
  }



  onFundRequestSubmitButtonClick() async {
    bool isValid = fundRequestFormKey.currentState!.validate();
    if (!isValid) return;
    if (position == null) {
      await validateLocation();
      return;
    }
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
      Get.dialog(ExceptionPage(error: e));
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
      Get.dialog(ExceptionPage(error: e));
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
      "latitude": position!.latitude.toString(),
      "longitude": position!.longitude.toString(),
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
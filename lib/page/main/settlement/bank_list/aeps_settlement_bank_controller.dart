import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/picker_helper.dart';

import '../../../exception_page.dart';

class AepsSettlementBankController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();

  var bankListResponseObs =
      Resource.onInit(data: AepsSettlementBankListResponse()).obs;

  late List<AepsSettlementBank> banks;

  @override
  void onInit() {
    super.onInit();
    fetchBankList();
  }

  fetchBankList() async {
    try {
      bankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsSettlementBankList();
      if (response.status == 1) {
        banks = response.bankDetails!;
      }
      bankListResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      bankListResponseObs.value = Resource.onFailure(e);
    }
  }

  onUpload(String id) {
    ImagePickerHelper.pickImageWithCrop((file) {
      Get.dialog(AmountConfirmDialogWidget(
          title: "Confirm Upload File ?",
          description:
              "Please make sure! you are uploading correct document file.",
          onConfirm: () {
            _uploadFile(file!,id);
          }));
    });
  }

  _uploadFile(File file, String id) async {
    StatusDialog.progress();
    try {
      var response = await repo.aepsSettlementDocumentUpload(await _uploadFileParam(file,id));
      Get.back();
      if (response.status == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => fetchBankList());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(
          error: Exception(
              "Error while making fund request, transaction may be success please "
              "check report or try with different "
              "image(capture using phone camera)")));
    }
  }

  Future<dio.FormData> _uploadFileParam(File? file, String id) async {
    dio.MultipartFile multipartFile = await dio.MultipartFile.fromFile(
        file!.path,
        filename: file.path.split("/").last);

    var param = {
      "bank_document": multipartFile,
      "unique_order_id" : id
    };
    return dio.FormData.fromMap(param);
  }
}

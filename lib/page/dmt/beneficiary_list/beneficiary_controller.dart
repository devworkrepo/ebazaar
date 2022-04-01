import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/common/common_confirm_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/model/dmt/account_search.dart';
import 'package:spayindia/model/dmt/beneficiary.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/dmt_kyc_info_dialog.dart';
import 'package:spayindia/page/dmt/beneficiary_list/component/transfer_mode_dailog.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';

class BeneficiaryListController extends GetxController {
  final Map<String, dynamic> args = Get.arguments;

  Beneficiary? previousBeneficiary;

  AccountSearch? accountSearch = Get.arguments["account"];

  DmtRepo repo = Get.find<DmtRepoImpl>();

  var beneficiaryResponseObs =
      Resource.onInit(data: DmtBeneficiaryResponse()).obs;

  late List<Beneficiary> beneficiaries;

  SenderInfo? sender = Get.arguments["sender"];
  DmtType dmtType = Get.arguments["dmtType"];

  void onBeneficiaryClick(Beneficiary beneficiary) {
    if (previousBeneficiary == null) {
      beneficiary.isExpanded.value = true;
      previousBeneficiary = beneficiary;
    } else if (previousBeneficiary! == beneficiary) {
      beneficiary.isExpanded.value = !beneficiary.isExpanded.value;
      previousBeneficiary = null;
    } else {
      beneficiary.isExpanded.value = true;
      previousBeneficiary?.isExpanded.value = false;
      previousBeneficiary = beneficiary;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBeneficiary();
  }

  fetchBeneficiary() async {
    _fetchBeneficiary();
  }

  _fetchBeneficiary() async {
    try {
      beneficiaryResponseObs.value = const Resource.onInit(data: null);
      var response = await repo
          .fetchBeneficiary({"remitter_mobile": sender!.senderNumber!});

      if (accountSearch != null) {
        var data = response.beneficiaries!.firstWhere(
            (element) => element.accountNumber == accountSearch!.accountNumber);
        beneficiaries = [data];
      }
      else{
        beneficiaries = response.beneficiaries!;
      }
      beneficiaryResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      beneficiaryResponseObs.value = Resource.onFailure(e);
      Get.off(ExceptionPage(error: e));
    }
  }

  deleteBeneficiary(Beneficiary beneficiary) async {
    Get.dialog(CommonConfirmDialogWidget(
      onConfirm: () {
        _deleteBeneficiaryConfirm(beneficiary);
      },
      title: "Confirm Delete",
      description: "You are sure! want to delete beneficiary.",
    ));
  }

  void _deleteBeneficiaryConfirm(Beneficiary beneficiary) async {
    StatusDialog.progress(title: "Deleting");

    var response =
        await repo.beneficiaryDelete({"beneid": beneficiary.id.toString()});
    Get.back();

    if (response.code == 1) {
      StatusDialog.success(title: response.message)
          .then((value) => fetchBeneficiary());
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  verifyAccount(Beneficiary beneficiary) async {
    Get.dialog(CommonConfirmDialogWidget(
        title: "Verification ?",
        description: "Are you sure to verify beneficiary account number",
        onConfirm: () {
          _verify(beneficiary);
        }));
  }

  _verify(Beneficiary beneficiary) async {
    try {
      StatusDialog.progress(title: "verifying");
      var response = await repo.verifyAccount({
        "remitter_mobile": sender!.senderNumber ?? "",
        "accountno": beneficiary.accountNumber ?? "",
        "ifsc": beneficiary.ifscCode ?? "",
        "bankname": beneficiary.bankName ?? "",
      });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(
                title:
                    response.message + "\n" + (response.beneficiaryName ?? ""))
            .then((value) => fetchBeneficiary());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  RxBool showAvailableTransferLimitObs = false.obs;

  showAvailableTransferLimit() {
    showAvailableTransferLimitObs.value = true;
  }

  onSendButtonClick(Beneficiary beneficiary) {
    Get.bottomSheet(TransferModeDialog(
      isLimitView: showAvailableTransferLimitObs.value,
      senderInfo: sender!,
      beneficiary: beneficiary,
      onClick: (amount, type) {
        Get.toNamed(RouteName.dmtTransactionPage, arguments: {
          "sender": sender,
          "beneficiary": beneficiary,
          "dmtType": dmtType,
          "type": type,
          "amount": amount,
          "isView": (showAvailableTransferLimitObs.value == true) ? "1" : "0"
        });
      },
    ),isScrollControlled: true);
  }

  onNameChange() {
    Get.toNamed(RouteName.dmtChangeSenderNamePage,
        arguments: {"sender": sender})?.then((value){
          if(value != null){
            var name = value as String;
            sender?.senderName = name;
            sender?.senderNameObs.value = name;
          }
    });
  }

  onMobileChange() {
    Get.toNamed(RouteName.dmtChangeSenderMobilePage,
        arguments: {"sender": sender})?.then((value){
      if(value != null){
        var mobile = value as String;
        sender?.senderNumber = mobile;
        sender?.senderNumberObs.value = mobile;
      }
    });
  }

  addBeneficiary() {
    Get.toNamed(RouteName.dmtBeneficiaryAddPage,
        arguments: {"dmtType": dmtType, "mobile": sender!.senderNumber!})?.then((value){
          if(value){
            _fetchBeneficiary();
          }
    });
  }

  void fetchKycInfo() async {
    if(!sender!.isKycVerified!){
      showFailureSnackbar(title: "Kyc info not found", message: "Make sure that you have completed your kyc in our portal");
      return;
    }

    try {
      StatusDialog.progress(title: "Fetching...");
      var response = await repo.kycInfo({
        "mobileno": sender!.senderNumber ?? "",
      });
      Get.back();
      if (response.code == 0) {
        Get.dialog(DmtKycInfoDialog(response));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }

  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/complain_repo.dart';
import 'package:spayindia/data/repo_impl/complain_repo_impl.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class ComplainPostController extends GetxController {

  final ComplainRepo repo = Get.find<ComplainRepoImpl>();
  final formKey = GlobalKey<FormState>();
  final transactionNumberController = TextEditingController();
  final subjectController = TextEditingController();
  final noteController = TextEditingController();
  final categoryObs = "".obs;
  final complainCategoryList = [
    "Money Transfer",
    "Utility",
    "AEPS, MATM, MPOS",
    "Credit Card",
    "Aadhaar Pay",
    "Money Requests",
    "Statement",
    "Charge & Commission",
    "Other"
  ];

  postNewComplain() async {

    final isValid =formKey.currentState!.validate();
    if(!isValid) return;


    final note = noteController.text;
    final transactionNumber = transactionNumberController.text;
    final subject = subjectController.text;

    StatusDialog.progress();

    final response = await repo.postComplain({
      "cat_type" : categoryObs.value,
      "transaction_no" : transactionNumber,
      "subject_name" : subject,
      "full_desc" : note,
    });
    Get.back();
    if (response.code == 1) {
      StatusDialog.success(title: response.message)
          .then((value) => Get.back(result: true));
    } else {
      StatusDialog.failure(title: response.message);
    }
  }

  @override
  void dispose() {
    transactionNumberController.dispose();
    subjectController.dispose();
    noteController.dispose();
    super.dispose();
  }
}

import 'dart:io';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/receipt/aeps.dart';
import 'package:spayindia/model/receipt/credit_card.dart';
import 'package:spayindia/model/receipt/money.dart';
import 'package:spayindia/model/receipt/recharge.dart';
import 'package:spayindia/page/pdf_html/aeps_receipt_html.dart';
import 'package:spayindia/page/pdf_html/credit_card_receipt_html.dart';
import 'package:spayindia/page/pdf_html/dmt_receipt_html.dart';
import 'package:spayindia/page/pdf_html/recharge_receipt_html.dart';

enum ReceiptType { money, payout, recharge, aeps,aadhaarPay, matm, creditCard }

mixin ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  void printReceipt(String calcId, ReceiptType receiptType) {
    var mParamTag =
        (receiptType == ReceiptType.money || receiptType == ReceiptType.payout)
            ? "calcid"
            : "transaction_no";
    var _param = {mParamTag: calcId};
    switch (receiptType) {
      case ReceiptType.money:
        _fetchDmtReceiptData(_param, receiptType);
        break;
      case ReceiptType.payout:
        _fetchDmtReceiptData(_param, receiptType);
        break;
      case ReceiptType.recharge:
        _fetchRechargeReceiptData(_param, receiptType);
        break;
      case ReceiptType.aeps:
        _fetchAepsReceiptData(_param, receiptType);
        break;
      case ReceiptType.aadhaarPay:
        _fetchAadhaarPayReceiptData(_param, receiptType);
        break;
      case ReceiptType.matm:
        _fetchAepsReceiptData(_param, receiptType);
        break;
      case ReceiptType.creditCard:
        _fetchCreditCardReceiptData(_param, receiptType);
        break;
    }
  }

  _fetchDmtReceiptData(param, ReceiptType receiptType) async {
    var response = (receiptType == ReceiptType.money)
        ? await _fetchHelper<MoneyReceiptResponse>(
            repo.moneyTransactionReceipt(param))
        : await _fetchHelper<MoneyReceiptResponse>(
            repo.payoutTransactionReceipt(param));
    if(response == null) return;
    _printPdfData(MoneyReceiptHtmlData(response).printData());
  }

  _fetchRechargeReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<RechargeReceiptResponse>(
        repo.rechargeTransactionReceipt(param));
    if(response == null)return;
    _printPdfData(RechargeReceiptHtmlData(response).printData());
  }


  _fetchAepsReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<AepsReceiptResponse>(
        repo.aepsTransactionReceipt(param));
    if(response == null)return;

    if (receiptType == ReceiptType.matm) {
      _printPdfData(AepsReceiptHtmlData(response,"Micro-ATM").printData());
    } else {
      _printPdfData(AepsReceiptHtmlData(response,"AEPS").printData());
    }
  }
  _fetchAadhaarPayReceiptData(param,ReceiptType type) async {
    var response = await _fetchHelper<AepsReceiptResponse>(repo.aadhaarPayTransactionReceipt(param));
    if(response == null)return;
      _printPdfData(AepsReceiptHtmlData(response,"Aadhaar Pay").printData());

  }

  _fetchCreditCardReceiptData(param, ReceiptType receiptType) async {
    var response = await _fetchHelper<CreditCardReceiptResponse>(
        repo.creditCardTransactionReceipt(param));
    if (response == null) return;

    _printPdfData(CreditCardReceiptHtmlData(response).printData());
  }

  _printPdfData(String printData) async {
    try {
      var filePath = await generateReceiptDpfDocument(printData);
      OpenFile.open(filePath);
    } catch (e) {
      StatusDialog.failure(title: e.toString());
    }
  }

  Future<String> generateReceiptDpfDocument(String htmlContent) async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      final targetPath = appDocDir.path;
      const targetFileName = "spay-india-receipt-pdf";
      final generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
          htmlContent, targetPath, targetFileName);
      return generatedPdfFile.path;
    } catch (e) {
      rethrow;
    }
  }

  Future<T?> _fetchHelper<T>(Future call) async {
    try {
      StatusDialog.progress();
      dynamic response = await call;
      Get.back();
      if (response.code == 1) {
        return response as T;
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
        return null;
      }
    } catch (e) {
      Get.back();
      StatusDialog.failure(title: "Something went wrong!!");
      return null;
    }
  }
}

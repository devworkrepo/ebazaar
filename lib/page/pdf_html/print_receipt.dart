import 'dart:io';

import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';

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

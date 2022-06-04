import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/widget/common.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TestPgWebView extends StatefulWidget {
  const TestPgWebView({Key? key}) : super(key: key);

  @override
  State<TestPgWebView> createState() => _TestPgWebViewState();
}

class _TestPgWebViewState extends State<TestPgWebView> {
  late WebViewController controller;

  Future<String> localLoader() async {
    return await rootBundle.loadString('assets/html/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<String>(
              future: localLoader(),
              builder: (context, snapshot) => WebView(
                    onPageStarted: (string) {

                    },
                    onWebViewCreated: (WebViewController webViewController) {
                      controller = webViewController;
                    },
                    initialUrl: Uri.dataFromString(snapshot.data!,
                            mimeType: 'text/html')
                        .toString(),
                    onPageFinished: (url) {
                      showSuccessSnackbar(
                          title: "WebView", message: "loading finished");
                    },
                    javascriptMode: JavascriptMode.unrestricted,
                    javascriptChannels: {
                      JavascriptChannel(
                          name: 'MakeLog',
                          onMessageReceived: (JavascriptMessage message) {
                            AppUtil.logger("From WebView : " + message.message);
                          })
                    },
                  ))),
    );
  }
}

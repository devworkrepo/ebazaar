import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/exception.dart';
import 'package:spayindia/util/lottie_constant.dart';
import 'package:spayindia/widget/button.dart';

class ExceptionPage extends StatefulWidget {
  final dynamic error;
  final Map<String, dynamic>? data;

  const ExceptionPage({required this.error, this.data, Key? key})
      : super(key: key);

  @override
  State<ExceptionPage> createState() => _ExceptionPageState();
}

class _ExceptionPageState extends State<ExceptionPage> {
  final AppPreference appPreference = Get.find();

  bool isNoInternetException = false;
  bool shouldGoMainPage = false;
  bool shouldGoLoginPage = false;
  late bool isTransactionApi;

  @override
  void initState() {
    super.initState();
    isTransactionApi = appPreference.isTransactionApi;
    appPreference.setIsTransactionApi(false);
    recordException();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (shouldGoLoginPage) {
          appPreference.setIsTransactionApi(false);
          Get.offAllNamed(AppRoute.loginPage);
          return false;
        }
        if (shouldGoMainPage) {
          appPreference.setIsTransactionApi(false);
          Get.offAllNamed(AppRoute.mainPage);
          return false;
        } else {
          return  true;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 56),
          child: _buildExceptionWidget(),
        ),
      ),
    );
  }

  _buildExceptionWidget() {
    final exception = getDioException(widget.error);

    if (exception is NoInternetException) {
      isNoInternetException = true;
      return _buildLottieWidget(
          lottieType: LottieType.noInternet,
          title: "No Internet",
          message:
          "Internet connection not available! please check mobile data or wifi connection");
    } else if (exception is SocketException) {
      return _buildLottieWidget(
          lottieType: LottieType.alert,
          title: "Connection Interrupted",
          message: "Connection has been interrupted, please try again");
    } else if (exception is TimeoutException) {
      return _buildLottieWidget(
          lottieType: LottieType.timeout,
          title: "Timeout",
          message: "Connection timeout! please try again");
    } else if (exception is UnableToProcessResponseException) {
      return _buildLottieWidget(
          lottieType: LottieType.alert,
          title: "Un-Handle Response",
          message: exception.message.toString());
    } else if (exception is FormatException) {
      return _buildLottieWidget(
          lottieType: LottieType.alert,
          title: "Format Exception",
          message: exception.message.toString());
    } else if (exception is ResponseException) {
      return _buildLottieWidget(
          lottieType: LottieType.alert,
          title: "Response Exception",
          message: exception.message.toString());
    }
    else if (exception is InternalServerException) {
      return _buildLottieWidget(
          lottieType: LottieType.server,
          title: "Internal Server Exception",
          message: exception.message.toString());
    }
    else if (exception is UnauthorizedException) {
      shouldGoLoginPage = true;
      return _buildLottieWidget(
          lottieType: LottieType.server,
          title: "Unauthorized Access!",
          message: exception.message.toString());
    }
    else if (exception is BadRequestException) {
      return _buildLottieWidget(
          lottieType: LottieType.server,
          title: "Bad Request",
          message: exception.message.toString());
    }
    else if (exception is SessionExpireException) {
      shouldGoLoginPage = true;
      return _buildLottieWidget(
          showLoginButton: true,
          lottieType: LottieType.alert,
          title: "Session Expired!",
          message: exception.message.toString());
    }
    else {
      return _buildLottieWidget(
          lottieType: LottieType.alert,
          title: "Error Occurred!!",
          message: exception.message.toString());
    }
  }

  _buildLottieWidget({required String lottieType,
    required String title,
    required String message,
    bool showLoginButton = false
  }) {
    var result = getTransactionExceptionMessage();

    if (!isNoInternetException && isTransactionApi) {
      shouldGoMainPage = true;
      lottieType = LottieType.pending;
      title = result["title"];
      message = result["message"];
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              child: LottieBuilder.asset(
                lottieType,
                height: 100,
                fit: BoxFit.cover,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: Get.textTheme.headline5
                  ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: Get.textTheme.subtitle2,
              textAlign: TextAlign.center,
            ),
          ),
          (showLoginButton) ? Column(
            children: [
              const SizedBox(height: 24,),
              AppButton(text: "Login Now", onClick: (){
                Get.offAllNamed(AppRoute.loginPage);
              },width: 250,)
            ],
          ) : const SizedBox()
        ],
      ),
    );
  }

  getTransactionExceptionMessage() {
    return {
      "title": "Transaction In Pending",
      "message":
          "Transaction is completed with unknown response due to network or server interruption. Please check report manually for complete status. Thank-you"
    };
  }

  @override
  void dispose() {
    appPreference.setIsTransactionApi(false);
    super.dispose();
  }

  void recordException() async {
    var error = getDioException(widget.error);

    if (error is NoInternetException ||
        error is SessionExpireException ||
        error is SocketException ||
        error is TimeoutException ||
        error is InternalServerException ||
        error is UnauthorizedException) {
    } else {
      var exceptionType = "Other Exception";
      if (error is UnableToProcessResponseException) {
        exceptionType = "UnableToProcessResponseException";
      } else if (error is FormatException) {
        exceptionType = "FormatException";
      } else if (error is FormatException) {
        exceptionType = "BadRequestException";
      }
      
      await FirebaseCrashlytics.instance.log(
          exceptionType +
              "\n\n\n" +
              widget.error.toString() +
              "\n\n\n" +
              ((widget.data != null) ? widget.data.toString() : "")
      );

    }
  }
}

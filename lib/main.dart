/*
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ebazaar/res/color.dart';
import 'package:ebazaar/route/page_route.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/service/app_lifecycle.dart';
import 'package:ebazaar/service/binding.dart';
import 'package:ebazaar/service/local_auth.dart';
import 'package:ebazaar/service/local_notifications.dart';
import 'package:ebazaar/service/native_call.dart';
import 'package:ebazaar/test/test_credo_pay.dart';
import 'package:ebazaar/test/test_summary_header.dart';
import 'package:ebazaar/util/app_util.dart';
import 'package:ebazaar/util/hex_color.dart';
import 'package:ebazaar/util/security/app_config.dart';

import 'data/app_pref.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
bool _isBiometricAvailable = false;
bool _isDeviceRooted = true;



Widget? testPageMode() => null;

Future<void> _initBiometric() async {
  _isBiometricAvailable = await LocalAuthService.isAvailable();
}

Future<void> _iniSafeDevice() async {
  _isDeviceRooted =await NativeCall.isDeviceRooted();
  */
/*await PalTrustedDevice.check(onFail: () {  },rooted: true,devMode: false,
      emulator: true,onExtStorage: false);*//*


}

Future<void> _initOrientations() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

Future<void> backgroundFcmHandler(RemoteMessage message) async {
  AppUtil.logger(" This is message from background");
}

Future<void> _initFirebaseService() async {
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundFcmHandler);
  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LocalNotificationService.initialize();
  await _initFirebaseService();
  await _initBiometric();
  await _iniSafeDevice();
  await _initOrientations();
  await appBinding();
  debugPrint = (String? message, {int? wrapWidth}) => '';

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppPreference appPreference = Get.find();

  @override
  Widget build(BuildContext context) {
    var initialPage = _initialPage();
    if (!_isBiometricAvailable) {
      initialPage = AppRoute.deviceLockPage;
    }
    if (_isDeviceRooted) {
      initialPage = AppRoute.rootPage;
    }

    if (testPageMode() != null) {
      initialPage = AppRoute.testPage;
    }
    var backgroundColor = AppColor.backgroundColor;
    ThemeData themeData = _themeData(backgroundColor);

    return AppLifecycleManager(
      child: GetMaterialApp(
          navigatorKey: navState,
          themeMode: ThemeMode.light,
          navigatorObservers: [routeObserver],
          theme: themeData,
          initialRoute: initialPage,
          getPages: getAllPages),
    );
  }

  ThemeData _themeData(HexColor backgroundColor) {
    return ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        dividerColor: Colors.grey,
        dividerTheme:
            const DividerThemeData(space: 12, thickness: 1, indent: 10),
        fontFamily: 'ProductSans',
        colorScheme: ColorScheme.light(
            primary: HexColor("0f1c4c"),
            secondary: Colors.green,
            onSecondary: Colors.white),
        cardTheme: CardTheme(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        primaryColor: HexColor("0f1c4c"),
        primaryColorDark: HexColor("0a1233"),
        primaryColorLight: HexColor("1A3187"),
        textTheme: buildTextTheme());
  }

  String _initialPage() {
    return (appPreference.sessionKey.isEmpty ||
            appPreference.sessionKey == "na" || !appPreference.isBiometricAuthentication)
        ? AppRoute.loginPage
        : AppRoute.mainPage;
  }

  TextTheme buildTextTheme() {
    return const TextTheme(
      headline5: TextStyle(fontSize: 22.0, height: 1.3),
      headline4:
          TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, height: 1.3),
      headline3:
          TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, height: 1.3),
      headline2:
          TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, height: 1.4),
      headline1:
          TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, height: 1.4),
      subtitle1:
          TextStyle(fontSize: 17.0, fontWeight: FontWeight.w500, height: 1.2),
      headline6:
          TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, height: 1.3),
      bodyText2:
          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2),
      bodyText1:
          TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, height: 1.3),
      caption:
          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, height: 1.2),
    );
  }

  @override
  void initState() {
    super.initState();

    AppConfig.init();
  }

  @override
  void dispose() {
    super.dispose();
  }
}*/

import 'package:flutter/material.dart';
import 'package:ebazaar/home2/home_page_2.dart';
import 'package:ebazaar/login/login_new.dart';
import 'package:ebazaar/util/hex_color.dart';

void main(){
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColorDark: HexColor("9c0376"),
        colorScheme: ColorScheme.light(
            primary: HexColor("fc03be"),
            secondary: HexColor("66039c"),
            onSecondary: Colors.white),
      ),
      home: const HomePage2(),
    );
  }
}

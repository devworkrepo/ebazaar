import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spayindia/res/color.dart';
import 'package:spayindia/route/page_route.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/service/app_lifecycle.dart';
import 'package:spayindia/service/binding.dart';
import 'package:spayindia/util/hex_color.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'data/app_pref.dart';


const isTestMode = false;

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if(kDebugMode){
   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await appBinding();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

//1a3656

class _MyAppState extends State<MyApp> {







  AppPreference appPreference = Get.find();
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
      scaffoldBackgroundColor:(isTestMode && kReleaseMode) ?  Colors.red :  AppColor.backgroundColor,
     // scaffoldBackgroundColor: AppColor.backgroundColor,
      dividerColor: Colors.grey,
        dividerTheme: const DividerThemeData(space: 12,thickness: 1 ,indent: 10) ,
        fontFamily: 'ProductSans',
        colorScheme: ColorScheme.light(
          primary: HexColor("0f1c4c"),
          secondary: Colors.green,
          onSecondary: Colors.white
        ),
        cardTheme:  CardTheme(elevation: 1,shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),),
        primaryColor: HexColor("0f1c4c"),
        primaryColorDark: HexColor("0a1233"),
        primaryColorLight: HexColor("1A3187"),
        textTheme: buildTextTheme());
    return AppLifecycleManager(
      GetMaterialApp(
          navigatorObservers: [routeObserver],
          theme: themeData,
         // initialRoute: RouteName.deviceVerificationPage,
          initialRoute: (appPreference.sessionKey.isEmpty || appPreference.sessionKey == "na") ? AppRoute.loginPage : AppRoute.mainPage,
          getPages: getAllPages),
    );
  }

  TextTheme buildTextTheme() {
    return const TextTheme(
        headline5: TextStyle(fontSize: 22.0, height: 1.3),
        headline4: TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.w700, height: 1.3),
        headline3: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.w700, height: 1.3),
        headline2: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.w700, height: 1.4),
        headline1: TextStyle(
            fontSize: 26.0, fontWeight: FontWeight.w300, height: 1.4),
        subtitle1: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.w500, height: 1.2),
        headline6: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.w700, height: 1.3),
        bodyText2: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w400, height: 1.2),
        bodyText1: TextStyle(
            fontSize: 15.0, fontWeight: FontWeight.w400, height: 1.3),
        caption: TextStyle(
            fontSize: 14.0, fontWeight: FontWeight.w300, height: 1.2),
      );
  }

  @override
  void initState() {
    super.initState();

  }
}

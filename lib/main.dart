import 'dart:io';
//import 'dart:ui';

//import 'package:flutter/foundation.dart'
//import 'package:flutter/rendering.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:magictank/appdata.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import './route/route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'generated/l10n.dart';
//import 'package:camera/camera.dart';

//import 'package:video_player/video_player.dart';
//(.[\u4E00-\u9FA5]+)|([\u4E00-\u9FA5]+.)搜索中文
Locale? locales;
String host = "https://blade.2m2.tech:7777";
//List<CameraDescription> cameras = [];
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void logError(String code, String? message) {
  if (message != null) {
    ////print('Error: $code\nError Message: $message');
  } else {
    ////print('Error: $code');
  }
}

void main() async {
  // int temp = 100;
  // hexToInt(intToFormatHex(temp, 4));
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    //设置状态栏透明

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xffeeeeee),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //设置状态栏隐藏
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //设置状态栏隐藏
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.top]);

  //await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // try {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   cameras = await availableCameras();
  // } on CameraException catch (e) {
  //   logError(e.code, e.description);
  // }
  // await
  await appData.initAppData();
  // if (window.physicalSize.isEmpty) {
  //   window.onMetricsChanged = () {
  //     //在回调中，size仍然有可能是0
  //     if (!window.physicalSize.isEmpty) {
  //       window.onMetricsChanged = null;
  //       runApp(MyApp());
  //     }
  //   };
  // } else {
  //如果size非0，则直接runApp
  //runApp(const MyApp());
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvid()),
      ],
      child: const MyApp(),
    ),
  );

  //}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 640),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return SafeArea(
            top: false,
            left: true,
            right: true,
            bottom: true,
            // maintainBottomViewPadding: true,
            child: MaterialApp(
              theme: ThemeData(
                  primaryColor: const Color(0xff50c5c4),
                  scaffoldBackgroundColor: const Color(0xffeeeeee),
                  appBarTheme:
                      const AppBarTheme(backgroundColor: Color(0xffeeeeee))),
              builder: (context, widget) {
                EasyLoading.init();
                return MediaQuery(
                  ///Setting font does not change with system font size
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: widget!,
                );
              },
              // theme: ThemeData(focusColor: Colors.grey[200]),
              localizationsDelegates: const [
                // DemoLocalizationsDelegate(),
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                // GlobalWidgetsLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                locales = deviceLocale;
                debugPrint('deviceLocale: $deviceLocale');
                return null;
              },
              locale: locales,
              supportedLocales: S.delegate.supportedLocales,
              initialRoute: '/',

              onGenerateRoute: (RouteSettings settings) {
                final String? name = settings.name;
                final Function? pageContentBuilder = routes[name];

                if (pageContentBuilder != null) {
                  if (settings.arguments != null) {
                    //CupertinoPageRoute
//FadeRoute MaterialPageRoute
                    final Route route = MaterialPageRoute(
                        builder: (context) => pageContentBuilder(context,
                            arguments: settings.arguments));
                    return route;
                  } else {
                    final Route route = MaterialPageRoute(
                        builder: (context) => pageContentBuilder(context));
                    return route;
                  }
                }
                return null;
              },
              navigatorObservers: <NavigatorObserver>[routeObserver],
            ),
          );
        });
  }
}

class AppProvid with ChangeNotifier, DiagnosticableTreeMixin {
  int _keydatadownload = 0;
  int _appdownload = 0;
  int _chipdatadownload = 0;
  bool _btswitch = false;
  String _apptip = "";
  String _cnctip = "";
  String _keydatatip = "";
  String _mctip = "";
  String _chipdatatip = "";
  String _mstip = "";
  String _msdatatip = "";
  bool loginstate = false;
  Map _userinfo = {};
  int get keydatadownload => _keydatadownload;
  int get appdownload => _appdownload;
  int get chipdatadownload => _chipdatadownload;
  bool get btswitch => _btswitch;
  String get mctip => _apptip + _mctip + _chipdatatip;
  String get cnctip => _apptip + _cnctip + _keydatatip;
  String get mstip => _apptip + _mstip + _msdatatip;
  Map get userinfo => _userinfo;

  void upgradeuserinfo(Map userinfo) {
    _userinfo = userinfo;
    notifyListeners();
  }

  void appProgress(int appprogress) {
    _appdownload = appprogress;
    notifyListeners();
  }

  void upgradeTip(int model, String str) {
    switch (model) {
      case 0: //APP
        _apptip = str;
        break;
      case 1:
        _cnctip = str;
        break;
      case 2:
        _keydatatip = str;
        break;
      case 3:
        _mctip = str;
        break;
      case 4:
        _chipdatatip = str;
        break;
      case 5:
        _mstip = str;
        break;
      case 6:
        _msdatatip = str;
        break;
    }
    notifyListeners();
  }

  void btSwitch(bool btswitch) {
    _btswitch = btswitch;
    notifyListeners();
  }

  void keydataProgress(int keydataprogress) {
    _keydatadownload = keydataprogress;
    notifyListeners();
  }

  void chipdataProgress(int chipdataprogress) {
    _chipdatadownload = chipdataprogress;
    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('keydatadownload', keydatadownload));
    properties.add(IntProperty('appdownload', appdownload));
    properties.add(IntProperty('chipdatadownload', chipdatadownload));
  }
}

//${context.watch<Counter>().count} 获取数据
//context.read<Counter>().increment(), 设置数据
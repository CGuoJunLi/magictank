import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';

import 'package:flutter/widgets.dart';
import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/http/api.dart';
import 'package:magictank/magicclone/bluetooth/mcclonebt_mananger.dart';

import 'package:magictank/magicsmart/bluetooth/msclonebt_mananger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter_tts/flutter_tts.dart';

AppData appData = AppData();

class AppData {
  int machineType = 0; //设备类型 0. Eclone  1.下载器
  ///读码计算方式
  bool readmodel = true;

  ///启动APP蓝牙自动连接
  bool beginautobt = true;
  List<bool> hideProgressDialog = [
    false, //APP下载框 1
    false, //钥匙数据下载框2
    false, //芯片数据下载框3
    false, //子机数据下载框4
    false, //拷贝机升级文件下载5
    false, //子机升级文件下载6
  ]; //隐藏下载框
  bool isBLE = false; //是否是低功耗蓝牙
  //bool root = false; //超级权限用于设备激活,值为true 显示激活页面 以及选择解压文件夹
  bool errorreturn = false;

  String userInfo = "userinfo.db"; //用户信息
  String userModel = "usermodel.db"; //用户自定义模型
  String userStar = "userstar.db"; //用户收藏
  String userClient = "userclient.db"; //用户收藏
  String userKey = "userkey.db"; //用户自定义钥匙
  String userHistory = "userhistory.db"; //用户自定义钥匙
  late Database userInfodb;
  late Database userModeldb;
  late Database userStardb;
  late Database userClientdb;
  late Database userKeydb;
  late Database userHistorydb;

  ///true 视窗模式
  bool carDataListview = false;
  bool otherguide = true;
  bool cncguide = true;
  bool mcguide = true;
  bool msguide = true;

  //用户信息
  String id = ""; //账户ID
  String account = ""; //登陆账号
  String password = ""; //登陆密码
  String userphone = "";
  String cncbluetoothname = ""; //上一次数控机蓝牙连接的地址 用作自动连接

  String mcbluetoothname = ""; //上一次拷贝机蓝牙连接的地址 用作自动连接
  String smartbluetoothname = ""; //上一次子机下载器蓝牙连接的地址 用作自动连接
  String username = ""; //昵称
  String qqnumber = ""; //qq号
  String email = ""; //电子邮箱
  String address = ""; //地址
  String headimage = ""; //头像地址;
  int integral = 0; //积分
  bool autologin = false;

  ///用户权限
  int limit = 0;
  //蓝牙自动连接
  bool autoconnect = false;

//路径定义
  String rootPath = ""; //根目录
  String tankRootPath = "";
  String keyDataZipPath = ""; //钥匙数据文件路径
  String keyImagePath = ""; //钥匙图片文件路径
  String mcBinPath = ""; //eclone文件路径
  String tankBinPath = ""; //tank固件路径
  String apkPath = ""; //app下载路径
  String mcRootPath = "";
  String chipDataPath = ""; //芯片数据路径
  String chipDataZipPath = ""; //芯片压缩包路径路径
  String smartRootPath = "";
  String smartDataPath = ""; //子机数据路径
  String smartDataZipPath = ""; //子机压缩包路径路径
//本地版本
  String appversion = "0"; //APP版本
  String chipversion = "0"; //芯片数据版本
  String smartversion = "0"; //子机数据版本
  String mcVer = "0"; //eclone固件版本
  String keydataver = "0"; //钥匙数据版本
  String cncVer = "0"; //tank固件版本

  double setSpeechRate = 1.0;
  double setPitch = 1.0;

  Map useinfo = {};

//数据列表
  List pmodelList = []; //平铣模型
  List lmodelList = []; //立铣模型
  List carkeyList = []; //汽车钥匙列表
  List civilkeyList = []; //民用钥匙列表
  List motorkeyList = []; //摩托钥匙列表
  List carList = []; //汽车列表
  List civilList = []; //民用列表
  List motorList = []; //摩托列表
  List readCodeList = []; //读齿助手 文件信息
  List<Map> smartCarList = []; //汽车名称排序
  List<Map> chipIDList = []; //芯片ID排序
  List<Map> chipData = []; //芯片数据 相当于tank3
  List<Map> chipCarList = []; //汽车名称排序
  List<Map> diykeydata = []; //钥匙数据
  List<Map> diykeymodel = []; //模型数据
  //校准数据
  int xDX = 0; //
  int xDY = 0; //
  //网络信息
  Map netkeydata = {}; //网络钥匙数据包 信息
  Map netapp = {}; //网络APP信息
  Map nettank = {}; //网络数控机信息
  Map netlcd = {}; //网络数控机信息
  Map netchipdata = {}; //网络芯片数据信息
  Map netsmartdata = {}; //网络芯片数据信息
  Map netmc = {}; //网络固件信息
  //其它
  bool getdata = false;
  bool loginstate = false;

  bool welcomepage = true;
  bool agreeprivcy = false;

  ///初始化进入主页标志  当开启自动连接时 连接蓝牙后为true 否则运行完广告页为true
  bool inmainpage = false;
  late FlutterTts flutterTts;
  SharedPreferences? sharedPreferences;
  int lastPage = 0; //退出时停留的页面ID
  List<String> hidePage = ["true", "false", "false"];
  List<String> keysyssele = ["true", "false", "false", "false"];
  List<String> isactivation = [""];
  int powerstate = 0;
  Future<void> initAppData() async {
    flutterTts = FlutterTts();
    rootPath = (await _findLocalPath()); //获取文件路径
    if (rootPath != "") {
      //app路径
      apkPath = rootPath + "/tank.apk";
      //tank数据包相关路径
      tankRootPath = rootPath + "/tank";
      Directory tankfile = Directory(rootPath + "/tank/");
      bool tankfilecreat = await tankfile.exists();
      if (!tankfilecreat) {
        debugPrint("创建文件夹");
        await tankfile.create(recursive: true);
      }
      keyDataZipPath = tankRootPath + "/keydata.zip";
      tankBinPath = tankRootPath + "/tankbin";
      keyImagePath = tankRootPath + "/image";
      //eclone数据包相关路径
      mcRootPath = rootPath + "/mcclone";
      mcBinPath = mcRootPath;
      chipDataZipPath = mcRootPath + "/chipdata.zip";
      chipDataPath = mcRootPath;
      //子机数据包相关路径
      smartRootPath = rootPath + "/smart";
      smartDataPath = smartRootPath;
      smartDataZipPath = smartRootPath + "/smartdata.zip";
    }

    await getAllCarName();
    await getAllCarKeyData();
    await getAllCivilName();
    await getAllCivilKeyData();
    await getAllMotorName();
    await getAllMotorKeyData();
    await getReadCodeData();
    await pModelData();
    await lModelData();
    await initHistory();
    await initUserStar();
    await initUserKey();
    await initUserModel();
    await initClient();

    await getChipIdList();
    await getChipCarList();
    await getChipDataList();
    await getSmartDataList();

    PackageInfo packageInfo = await PackageInfo.fromPlatform(); //获取版本信息

    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    appversion = packageInfo.version.replaceAll('.', "");
    sharedPreferences = await SharedPreferences.getInstance();
    //获取本地激活信息
    if (sharedPreferences!.getStringList('isactivation') != null) {
      isactivation = sharedPreferences!.getStringList('isactivation')!;
    }
    if (sharedPreferences!.getBool('agreeprivcy') != null) {
      agreeprivcy = sharedPreferences!.getBool('agreeprivcy')!;
    }
    if (sharedPreferences!.getBool('welcomepage') != null) {
      welcomepage = sharedPreferences!.getBool('welcomepage')!;
    }
    if (sharedPreferences!.getBool('otherguide') != null) {
      otherguide = sharedPreferences!.getBool('otherguide')!;
    }
    if (sharedPreferences!.getBool('readmodel') != null) {
      readmodel = sharedPreferences!.getBool('readmodel')!;
    }
    if (sharedPreferences!.getBool('beginautobt') != null) {
      beginautobt = sharedPreferences!.getBool('beginautobt')!;
    }
    if (sharedPreferences!.getBool('mcguide') != null) {
      mcguide = sharedPreferences!.getBool('mcguide')!;
    }

    if (sharedPreferences!.getBool('msguide') != null) {
      msguide = sharedPreferences!.getBool('msguide')!;
    }
    if (sharedPreferences!.getBool('cncguide') != null) {
      cncguide = sharedPreferences!.getBool('cncguide')!;
    }

    if (sharedPreferences!.getString('keydataver') != null) {
      keydataver = sharedPreferences!.getString('keydataver')!;
    }
    if (sharedPreferences!.getString('chipversion') != null) {
      chipversion = sharedPreferences!.getString('chipversion')!;
    }
    if (sharedPreferences!.getString('smartversion') != null) {
      smartversion = sharedPreferences!.getString('smartversion')!;
    }
    if (sharedPreferences!.getInt('lastpage') != null) {
      // print(sharedPreferences!.getInt('lastpage'));
      lastPage = sharedPreferences!.getInt('lastpage')!;
    }
    if (sharedPreferences!.getStringList('hidepage') != null) {
      hidePage = List.from(sharedPreferences!.getStringList('hidepage')!);
    }
    if (sharedPreferences!.getStringList('keysyssele') != null) {
      keysyssele = List.from(sharedPreferences!.getStringList('keysyssele')!);
    }
    if (sharedPreferences!.getBool('isble') != null) {
      isBLE = sharedPreferences!.getBool('isble')!;
      if (Platform.isIOS) {
        isBLE = true;
      }
      if (isBLE) {
        mcbtmodel.init();
        msinitBle();
        cncbt4model.init();
      }
      // if (isBLE) {
      //   lastPage = 2;
      // } else {
      //   lastPage = 1;
      // }
    }
    if (sharedPreferences!.getBool('autologin') == true) {
      loginstate = true;
      id = sharedPreferences!.getString('id')!;
      account = sharedPreferences!.getString('account')!;
      password = sharedPreferences!.getString('password')!;
      userphone = sharedPreferences!.getString('userphone')!;
      username = sharedPreferences!.getString('username')!;
      //qqnumber = sharedPreferences!.getString('qqnumber')!;
      address = sharedPreferences!.getString('address')!;
      headimage = sharedPreferences!.getString('headimage')!;
      email = sharedPreferences!.getString('email')!;
      autologin = sharedPreferences!.getBool('autologin')!;
      integral = sharedPreferences!.getInt('integral')!;
      try {
        var temp = await Api.getuserinfo({"account": account, "pwd": password});
        print(temp);
        if (temp["state"]) {
          limit = temp["limit"];
          integral = temp["integral"];
          await sharedPreferences!.setInt('integral', integral);
        }
      } catch (e) {
        limit = 0;
      }
    }
    if (sharedPreferences!.getBool('autoconnect') != null) {
      autoconnect = sharedPreferences!.getBool('autoconnect')!;
    }
    if (sharedPreferences!.getString('cncbluetoothname') == null) {
      //autologin = false;
      //  autoconnect = false;
    } else {
      cncbluetoothname = sharedPreferences!.getString('cncbluetoothname')!;
    }

    if (sharedPreferences!.getString('mcbluetoothname') == null) {
      //autologin = false;
      //  autoconnect = false;
    } else {
      mcbluetoothname = sharedPreferences!.getString('mcbluetoothname')!;
    }

    if (sharedPreferences!.getBool('carDataListview') == null) {
      //autologin = false;
      //  autoconnect = false;
    } else {
      carDataListview = sharedPreferences!.getBool('carDataListview')!;
    }
    if (sharedPreferences!.getString('smartbluetoothname') == null) {
      //autologin = false;
      //  autoconnect = false;
    } else {
      smartbluetoothname = sharedPreferences!.getString('smartbluetoothname')!;
    }
  }

  Future<String> _findLocalPath() async {
    String externalStorageDirPath;
    var directory = await getApplicationDocumentsDirectory();
    externalStorageDirPath = directory.path;

    return externalStorageDirPath;
  }

  Future<void> upgradeAppData(var data) async {
    //更新APP缓存数据
    if (data["loginstate"] != null) {
      loginstate = data["loginstate"];
    }
    if (data["name"] != null) {
      username = data["name"];
      await sharedPreferences!.setString("username", username);
    }
    if (data["pwd"] != null) {
      password = data["pwd"];
      await sharedPreferences!.setString("pwd", password);
    }
    if (data["pic"] != null) {
      headimage = data["pic"];
      await sharedPreferences!.setString("pic", headimage);
    }
    if (data["id"] != null) {
      id = data["id"].toString();
      await sharedPreferences!.setString("id", id);
    }
    if (data["autoconnect"] != null) {
      autoconnect = data["autoconnect"];
      await sharedPreferences!.setBool("autoconnect", autoconnect);
    }
    if (data["autologin"] != null) {
      autologin = data["autologin"];
      await sharedPreferences!.setBool("autologin", autologin);
    }
    if (data["account"] != null) {
      account = data["account"];
      await sharedPreferences!.setString('account', data["account"]);
    }
    if (data["pwd"] != null) {
      password = data["pwd"];
      await sharedPreferences!.setString('password', data["pwd"]);
    }
    if (data["phone"] != null) {
      userphone = data["phone"];
      await sharedPreferences!.setString('userphone', data["phone"]);
    }
    if (data["cncbluetoothname"] != null) {
      cncbluetoothname = data["cncbluetoothname"];
      await sharedPreferences!
          .setString('cncbluetoothname', data["cncbluetoothname"]);
    }
    if (data["mcbluetoothname"] != null) {
      mcbluetoothname = data["mcbluetoothname"];
      await sharedPreferences!
          .setString('mcbluetoothname', data["mcbluetoothname"]);
    }
    if (data["smartbluetoothname"] != null) {
      smartbluetoothname = data["smartbluetoothname"];
      await sharedPreferences!
          .setString('smartbluetoothname', data["smartbluetoothname"]);
    }
    if (data["name"] != null) {
      username = data["name"];
      await sharedPreferences!.setString('username', data["name"]);
    }
    if (data["qqnumber"] != null) {
      qqnumber = data["qqnumber"];
      await sharedPreferences!.setString('qqnumber', data["qqnumber"]);
    }
    if (data["address"] != null) {
      address = data["address"];
      await sharedPreferences!.setString('address', data["address"]);
    }
    if (data["pic"] != null) {
      headimage = data["pic"];
      await sharedPreferences!.setString('headimage', data["pic"]);
    }
    if (data["email"] != null) {
      email = data["email"];
      await sharedPreferences!.setString('email', data["email"]);
    }
    if (data["keydataver"] != null) {
      keydataver = data["keydataver"];
      await sharedPreferences!.setString('keydataver', data["keydataver"]!);
    }
    if (data["chipversion"] != null) {
      chipversion = data["chipversion"];
      await sharedPreferences!.setString('chipversion', data["chipversion"]!);
    }
    if (data["smartversion"] != null) {
      smartversion = data["smartversion"];
      await sharedPreferences!.setString('smartversion', data["smartversion"]!);
    }
    if (data["integral"] != null) {
      integral = data["integral"];
      await sharedPreferences!.setInt('integral', data["integral"]);
    }
    if (data["welcomepage"] != null) {
      welcomepage = data["welcomepage"];
      await sharedPreferences!.setBool('welcomepage', data["welcomepage"]);
    }
    if (data["lastpage"] != null) {
      lastPage = data["lastpage"];
      // print(data);
      await sharedPreferences!.setInt('lastpage', data["lastpage"]);
    }
    if (data["hidepage"] != null) {
      hidePage = List.from(data["hidepage"]);
      await sharedPreferences!.setStringList('hidepage', data["hidepage"]);
    }
    if (data["keysyssele"] != null) {
      keysyssele = List.from(data["keysyssele"]);
      await sharedPreferences!.setStringList('keysyssele', data["keysyssele"]);
    }
    if (data["isactivation"] != null) {
      isactivation.add(data["isactivation"]);
      await sharedPreferences!.setStringList('isactivation', isactivation);
    }
    if (data["isble"] != null) {
      isBLE = data["isble"];
      await sharedPreferences!.setBool('isble', data["isble"]);
    }
    if (data["otherguide"] != null) {
      otherguide = data["otherguide"];
      await sharedPreferences!.setBool('otherguide', data["otherguide"]);
    }
    if (data["cncguide"] != null) {
      cncguide = data["cncguide"];
      await sharedPreferences!.setBool('cncguide', data["cncguide"]);
    }
    if (data["mcguide"] != null) {
      mcguide = data["mcguide"];
      await sharedPreferences!.setBool('mcguide', data["mcguide"]);
    }
    if (data["msguide"] != null) {
      msguide = data["msguide"];
      await sharedPreferences!.setBool('msguide', data["msguide"]);
    }
    if (data["carDataListview"] != null) {
      carDataListview = data["carDataListview"];
      await sharedPreferences!
          .setBool('carDataListview', data["carDataListview"]);
    }
    if (data["readmodel"] != null) {
      readmodel = data["readmodel"];
      await sharedPreferences!.setBool("readmodel", readmodel);
    }
    if (data["beginautobt"] != null) {
      beginautobt = data["beginautobt"];
      await sharedPreferences!.setBool("beginautobt", beginautobt);
    }
    if (data["agreeprivcy"] != null) {
      agreeprivcy = data["agreeprivcy"];
      await sharedPreferences!.setBool("agreeprivcy", beginautobt);
    }

    if (data["limit"] != null) {
      limit = data["limit"];
    }
  }

  //加载tank1文件
  Future<void> getAllCarName() async {
    File file = File(appData.tankRootPath + "/tank1.json");
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        carList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  //加载摩托tank1文件
  Future<void> getAllMotorName() async {
    File file = File(appData.tankRootPath + "/tank1_1.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);

        motorList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  //加载民用tank1文件
  Future<void> getAllCivilName() async {
    File file = File(appData.tankRootPath + "/tank1_2.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);

        civilList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

//加载tank3 钥匙数据文件
  Future<void> getAllCarKeyData() async {
    File file = File(appData.tankRootPath + "/tank3.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);

        carkeyList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  //加载摩托 钥匙数据文件
  Future<void> getAllMotorKeyData() async {
    File file = File(appData.tankRootPath + "/tank3_1.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        motorkeyList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  //加载tank3 钥匙数据文件
  Future<void> getAllCivilKeyData() async {
    File file = File(appData.tankRootPath + "/tank3_2.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        civilkeyList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

//加载平铣模型文件
  Future<void> pModelData() async {
    File file = File(appData.tankRootPath + "/models.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      ////print(lines);
      try {
        var temps = json.decode(lines);
        pmodelList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

//加载立铣模型文件
  Future<void> lModelData() async {
    File file = File(appData.tankRootPath + "/model.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        lmodelList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

//加载读齿助手数据
  Future<void> getReadCodeData() async {
    File file = File(appData.tankRootPath + "/readcode.json");
    //var lines = await rootBundle.loadString('json/tank3.json');
    if (file.existsSync()) {
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        readCodeList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    } else {
      debugPrint("readcode 不存在");
    }
  }

//获取按照车型排序的 列表
  Future<void> getChipCarList() async {
    File file = File(appData.mcRootPath + "/chipcar.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      // print("文件存在");
      try {
        var lines = await file.readAsString();
        var temps = json.decode(lines);
        chipCarList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    }
    file = File(appData.mcRootPath + "/chipid.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        chipIDList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    } else {}
    //  List<Map> sub = [];
    List<Map> content = [];
    // Map title = {};
    for (var i = 0; i < chipCarList.length; i++) {
      // sub = [];
      // title = {};
      content = [];
      for (var j = 0; j < chipCarList[i]["sub"][0]["content"].length; j++) {
        content.add(chipCarList[i]["sub"][0]["content"][j]);

        var length =
            chipIDList[chipCarList[i]["sub"][0]["content"][j]["chipid"] - 1]
                    ["sub"]
                .length;
        var id = chipCarList[i]["sub"][0]["content"][j]["chipid"] - 1;
        if (chipIDList[id]["sub"][length - 1]["title"] !=
            chipCarList[i]["master"]) {
          chipIDList[id]["sub"]
              .add({"title": chipCarList[i]["master"], "content": content});
        } else {
          chipIDList[id]["sub"][length - 1]["content"].addAll(content);
        }

        content = [];
      }
    }

    for (var i = 0; i < chipIDList.length; i++) {
      chipIDList[i]["sub"] = chipIDList[i]["sub"].toSet().toList();
    }
  }

  // 获取按照ID排序的 列表
  Future<void> getChipIdList() async {
    //加载tank1文件

    // File file = new File(appData.rootPath + "/chipid.json");
    // if (file.existsSync()) {
    //   //var lines = await rootBundle.loadString('json/tank1.json');
    //   var lines = await file.readAsString();
    //   var temps = json.decode(lines);

    //   this.ChipIDList = List.from(temps);
    // }
  }

  Future<void> getChipDataList() async {
    //加载tank1文件

    File file = File(appData.mcRootPath + "/chipdata.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        chipData = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    } else {
      debugPrint("chipdata 未找到文件");
    }
  }

  Future<void> getSmartDataList() async {
    //加载tank1文件

    File file = File(smartRootPath + "/smart.json");
    // File file = File("/image/smartdata/smart.json");
    if (file.existsSync()) {
      //var lines = await rootBundle.loadString('json/tank1.json');
      var lines = await file.readAsString();
      try {
        var temps = json.decode(lines);
        smartCarList = List.from(temps);
      } catch (e) {
        debugPrint("$e");
      }
    } else {
      debugPrint("smart.json 未找到文件");
    }
  }

  //用户信息
  //name 昵称
  //account 账户
  //phone 电话
  //pwd 密码
  //bluetooth_address 蓝牙地址 用于自动给连接
  //is_release 账户状态 DUBUG or RELEASE
  //welcome_is_open 欢迎页
  //text_speech_is_open 语音播报
  //pic  头像地址
  //addresss 收获地址
  //email 邮箱地址
  //qqnumber qq号
  //INTEGER 积分
  Future<void> initUserInfo() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userInfo);
    debugPrint("创建用户信息");
    userInfodb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE userhisotry (id INTEGER PRIMARY KEY, name TEXT,account TEXT,phone TEXT,pwd TEXT,bluetooth_address TEXT,is_release TEXT,welcome_is_open TEXT,text_speech_is_open TEXT,pic TEXT,address TEXT,email TEXT,integral INTEGER)');
    });
  }

  //获取用户信息
  Future<void> getUserInfo(String account, String pwd) async {
    //  String sql = "UPDATE userinfo SET pwd = ? WHERE id = ?";
    var temp = await userInfodb
        .rawQuery('SELECT * FROM userinfo WHERE account=?', [account]);
    if (temp.isNotEmpty) {}
  }

  //插入用户信息
  Future<void> insertUserInfo(Map data) async {
    DateTime nowtime = DateTime.now();
    data["time"] = nowtime.toString().substring(0, 19);
    await userInfodb.insert("userinfo", Map.from(data));
  }

  //修改用户信息
  Future<void> changeUserInfo(Map data) async {
    // String sql = "UPDATE userinfo SET pwd = ? WHERE id = ?";
    // int count = await userInfodb.rawUpdate(sql, ["654321", '1']);

    // DateTime nowtime = DateTime.now();
    // data["time"] = nowtime.toString().substring(0, 19);
    // await userInfodb.insert("userinfo", Map.from(data));
  }

  //历史记录
  Future<void> initHistory() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userHistory);
    debugPrint("创建历史记录");

    userHistorydb = await openDatabase(path);
    // userHistorydb = await openDatabase(path, version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute(
    //       'CREATE TABLE userhisotry (id INTEGER PRIMARY KEY,userid TEXT, timer TEXT,keyid INTEGER,bitting TEXT,type INTEGER,state INTEGER,keydata TEXT)');
    //   //await db.execute("ALTER TABLE userhisotry ADD COLUMN keydata TEXT;");
    // });
    int version = await userHistorydb.getVersion();

    if (version == 0) {
      await userHistorydb.execute(
          'CREATE TABLE userhisotry (id INTEGER PRIMARY KEY,userid TEXT, timer TEXT,keyid INTEGER,bitting TEXT,type INTEGER,state INTEGER,keydata TEXT)');
      await userHistorydb.setVersion(2);
    } else if (version == 1) {
      await userHistorydb
          .execute("ALTER TABLE userhisotry ADD COLUMN keydata TEXT;");
      await userHistorydb.setVersion(2);
    }
    version = await userHistorydb.getVersion();

    //ALTER TABLE database_name.table_name ADD COLUMN column_def...；
  }

  //获取本地历史记录
  Future<List<Map>> getHistory() async {
    return await userHistorydb
        .rawQuery('SELECT * FROM userhisotry WHERE userid=$id');
  }

  //插入历史记录
  Future<void> insertHistory(Map data) async {
    // DateTime nowtime = DateTime.now();
    // data["time"] = nowtime.toString().substring(0, 19);
    await userHistorydb.insert("userhisotry", Map.from(data));
  }

  Future<void> updateHistory(Map data) async {
    String sql = "UPDATE userhisotry SET state = ? WHERE id = ?";
    int count = await userHistorydb.rawUpdate(sql, [data["state"], data["id"]]);

    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //删除历史记录
  Future<void> deleHistory(Map data) async {
    int count = await userHistorydb
        .rawDelete("DELETE FROM userhisotry WHERE id = ?", [data["id"]]);
    if (count == 1) {
      debugPrint("删除成功");
    }
  }

  //我的模型
  Future<void> initUserModel() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userModel);
    userModeldb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE usermodel (id INTEGER PRIMARY KEY,userid TEXT, timer TEXT,data TEXT,state INTEGER,shared TEXT,use TEXT)');
    });
  }

  //获取我的模型
  Future<List> getUserModel() async {
    return await userModeldb
        .rawQuery('SELECT * FROM usermodel WHERE userid=$id');
  }

  //插入我的模型
  Future<void> insertUserModel(Map data) async {
    await userModeldb.insert("usermodel", Map.from(data));
  }

  //删除我的模型
  Future<void> deleUserModel(String id) async {
    int count =
        await userModeldb.rawDelete("DELETE FROM usermodel WHERE id = ?", [id]);
    if (count == 1) {
      debugPrint("删除成功");
    }
  }

  Future<void> updateUserModel(String id, int state) async {
    String sql = "UPDATE usermodel SET state = ? WHERE id = ?";
    int count = await userModeldb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  Future<void> sharedUserModel(String id, String state) async {
    String sql = "UPDATE usermodel SET shared = ? WHERE id = ?";
    int count = await userModeldb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //我的钥匙
  //用户ID
  //钥匙数据
  //时间
  //同步状态
  //共享状态
  //使用状态
  Future<void> initUserKey() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userKey);
    userKeydb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE userkey (id INTEGER PRIMARY KEY,userid TEXT, timer TEXT,data TEXT,state INTEGER,shared TEXT,use TEXT)');
    });
  }

  //获取我的钥匙
  Future<List> getUserKey() async {
    return await userKeydb.rawQuery('SELECT * FROM userkey WHERE userid=$id');
  }

  //插入我的钥匙
  Future<void> insertUserKey(Map data) async {
    await userKeydb.insert("userkey", Map.from(data));
  }

  //删除我的钥匙
  Future<void> deleUserKey(String id) async {
    int count =
        await userKeydb.rawDelete("DELETE FROM userkey WHERE id = ?", [id]);
    if (count == 1) {
      debugPrint("删除成功");
    }
  }

  Future<void> updateUserKey(String id, int state) async {
    String sql = "UPDATE userkey SET state = ? WHERE id = ?";
    int count = await userKeydb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //共享状态
  Future<void> sharedUserKey(String id, String state) async {
    String sql = "UPDATE userkey SET shared = ? WHERE id = ?";
    int count = await userKeydb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

//更新使用状态
  Future<void> useUserKey(String id, String state) async {
    String sql = "UPDATE userkey SET use = ? WHERE id = ?";
    int count = await userKeydb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //我的收藏
  Future<void> initUserStar() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userStar);
    userStardb = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      //字段
      //id  自增
      //userid  用户ID
      //timer  时间
      //keyid  钥匙ID
      //type   类型
      //state  同步状态
      await db.execute(
          'CREATE TABLE userstar (id INTEGER PRIMARY KEY,userid TEXT, timer TEXT,keyid INTEGER,type INTEGER,state INTEGER)');
    });
  }

  //获取我的收藏
  Future<List> getUserStar() async {
    return await userStardb.rawQuery('SELECT * FROM userstar WHERE userid=$id');
  }

  //插入我的收藏 返回一个 本地的ID
  Future<int> insertUserStar(Map data) async {
    //DateTime nowtime = DateTime.now();
    // data["time"] = nowtime.toString().substring(0, 19);
    // data["userid"] = id;
    //先查找是否存在值
    List? result = await userStardb.rawQuery(
        'SELECT * FROM userstar WHERE userid=$id&keyid=${data["keyid"]}');
    //如果存在则更新
    if (result.isNotEmpty) {
      String sql = "UPDATE userstar SET  timer= ? WHERE id = ?";
      //int count =
      await userStardb.rawUpdate(sql, [data["timer"], result[0]["id"]]);
      return result[0]["id"];
    } else {
      //否则插入数据
      await userStardb.insert("userstar", Map.from(data));
      var temp = await getUserStar();
      return temp[temp.length - 1]["id"];
    }
  }

  //删除我的收藏
  Future<void> deleUserStar(Map data) async {
    ////print(id);
    int count = await userStardb
        .rawDelete("DELETE FROM userstar WHERE id = ?", [data["id"]]);
    ////print(count);
    if (count == 1) {
      debugPrint("删除成功");
    }
  }

  Future<void> updateUserStar(String id, int state) async {
    String sql = "UPDATE userstar SET state = ? WHERE id = ?";
    int count = await userStardb.rawUpdate(sql, [state, id]);
    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //我的

  // var databasesPath = await getDatabasesPath();
  // String path = join(databasesPath, userMyModel);
  // userMyModeldb = await openDatabase(path, version: 1,
  //     onCreate: (Database db, int version) async {
  //   // When creating the db, create the table
  //   await db.execute(
  //       'CREATE TABLE userhisotry (id INTEGER PRIMARY KEY, name TEXT,account TEXT,phone TEXT,pwd TEXT,bluetooth_name TEXT,bluetooth_address TEXT,ver_code TEXT,is_release TEXT,welcome_is_open TEXT,text_speech_is_open TEXT,pic TEXT,address TEXT,email TEXT,integral INTEGER)');
  // });
  //客户资料
  Future<void> initClient() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, userClient);
    debugPrint("创建客户资料");
    userClientdb = await openDatabase(path);
    int version = await userClientdb.getVersion();
    // userClientdb = await openDatabase(path, version: 1,
    //     onCreate: (Database db, int version) async {
    //   // When creating the db, create the table
    //   await db.execute(
    //       'CREATE TABLE userclient (id INTEGER PRIMARY KEY,userid TEXT, name TEXT,phone TEXT,carnum TEXT,timer TEXT,keyid INTEGER,bitting TEXT,type INTEGER,state INTEGER)');
    // });
    if (version == 0) {
      await userClientdb.execute(
          'CREATE TABLE userclient (id INTEGER PRIMARY KEY,userid TEXT, name TEXT,phone TEXT,carnum TEXT,timer TEXT,keyid INTEGER,bitting TEXT,type INTEGER,keydata TEXT,state INTEGER)');
      await userClientdb.setVersion(2);
    } else if (version == 1) {
      await userClientdb
          .execute("ALTER TABLE userclient ADD COLUMN keydata TEXT;");
      await userClientdb.setVersion(2);
    }
  }

  //获取本地客户资料
  Future<List> getClient() async {
    return await userClientdb
        .rawQuery('SELECT * FROM userclient WHERE userid=$id');
  }

  //插入客户资料
  Future<void> insertClient(Map data) async {
    // DateTime nowtime = DateTime.now();
    // data["time"] = nowtime.toString().substring(0, 19);
    await userClientdb.insert("userclient", Map.from(data));
  }

//更新客户资料
  Future<void> updateClient(Map<String, dynamic> data) async {
    String sql = "UPDATE userclient SET state = ? WHERE id = ?";

    int count = await userClientdb.rawUpdate(sql, [data["state"], data["id"]]);

    if (count == 1) {
      debugPrint("修改成功");
    } else {
      debugPrint("修改失败");
    }
  }

  //删除客户资料
  Future<void> deleClient(Map<String, dynamic> data) async {
    int count = await userClientdb
        .rawDelete("DELETE FROM userclient WHERE id = ?", [data["id"]]);
    if (count == 1) {
      debugPrint("删除成功");
    }
  }

  Future<void> speakText(String text) async {
    if (text != "") {
      await flutterTts.speak(text);
    }
  }

  Future<void> geizipfile(String filepath, String filehomepath,
      {bool needpwd = false}) async {
    final inputStream = InputFileStream(filepath);

    // Decode the zip from the InputFileStream. The archive will have the contents of the
    // zip, without having stored the data in memory.
    final archive = ZipDecoder().decodeBuffer(inputStream, verify: true);
    // For all of the entries in the archive

    for (var file in archive.files) {
      // If it's a file and not a directory
      if (file.isFile) {
        // Write the file content to a directory called 'out'.
        // In practice, you should make sure file.name doesn't include '..' paths
        // that would put it outside of the extraction directory.
        // An OutputFileStream will write the data to disk.
        final outputStream = OutputFileStream(filehomepath + "/" + file.name);
        // The writeContent method will decompress the file content directly to disk without
        // storing the decompressed data in memory.
        file.writeContent(outputStream);
        // Make sure to close the output stream so the File is closed.
        outputStream.close();
      }
    }
    try {
      var file = File(filepath);

      if (await file.exists()) {
        // file exits, it is safe to call delete on it
        await file.delete();
      }
    } catch (e) {
      debugPrint("$e");
      // error in getting access to the file
    }
  }
}

List<String> supportphone = [
  "86",
  "93",
  "355",
  "213",
  "1684",
  "376",
  "244",
  "1264",
  "1268",
  "54",
  "374",
  "297",
  "61",
  "43",
  "994",
  "1242",
  "973",
  "880",
  "1246",
  "375",
  "32",
  "501",
  "229",
  "1441",
  "975",
  "591",
  "387",
  "267",
  "55",
  "673",
  "359",
  "226",
  "257",
  "855",
  "237",
  "1",
  "238",
  "1345",
  "238",
  "236",
  "235",
  "56",
  "57",
  "269",
  "682",
  "225",
  "506",
  "385",
  "599",
  "357",
  "420",
  "45",
  "253",
  "1767",
  "1809",
  "593",
  "20",
  "503",
  "240",
  "291",
  "372",
  "251",
  "298",
  "679",
  "358",
  "33",
  "594",
  "689",
  "241",
  "220",
  "995",
  "49",
  "233",
  "350",
  "30",
  "299",
  "1473",
  "590",
  "1671",
  "502",
  "224",
  "245",
  "592",
  "509",
  "504",
  "852",
  "36",
  "354",
  "91",
  "62",
  "964",
  "353",
  "972",
  "39",
  "225",
  "1876",
  "81",
  "962",
  "7",
  "254",
  "686",
  "965",
  "996",
  "856",
  "371",
  "961",
  "266",
  "231",
  "218",
  "423",
  "370",
  "352",
  "853",
  "389",
  "261",
  "265",
  "60",
  "960",
  "223",
  "356",
  "596",
  "1670",
  "222",
  "230",
  "269",
  "52",
  "373",
  "377",
  "976",
  "382",
  "1664",
  "212",
  "258",
  "95",
  "264",
  "977",
  "31",
  "599",
  "687",
  "64",
  "505",
  "227",
  "234",
  "47",
  "968",
  "92",
  "680",
  "970",
  "507",
  "675",
  "595",
  "51",
  "63",
  "48",
  "351",
  "1787",
  "974",
  "242",
  "262",
  "40",
  "7",
  "250",
  "1869",
  "1758",
  "508",
  "1784",
  "1869",
  "685",
  "378",
  "239",
  "966",
  "221",
  "381",
  "248",
  "232",
  "65",
  "1721",
  "421",
  "386",
  "677",
  "252",
  "27",
  "82",
  "34",
  "94",
  "597",
  "268",
  "46",
  "41",
  "886",
  "992",
  "255",
  "66",
  "670",
  "228",
  "676",
  "1868",
  "216",
  "90",
  "993",
  "1649",
  "256",
  "971",
  "44",
  "1",
  "598",
  "998",
  "678",
  "58",
  "84",
  "1340",
  "1284",
  "967",
  "260",
  "263",
  "380"
];

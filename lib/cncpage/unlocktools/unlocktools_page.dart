import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/basekey.dart';
import 'package:magictank/convers/convers.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
//import 'package:magictank/cncpage/createkeytoolsdata.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/userappbar.dart';

//开锁工具页面 RotatedBox 旋转小部件
class UnlockTools extends StatefulWidget {
  final Map arguments;
  const UnlockTools(this.arguments, {Key? key}) : super(key: key);

  @override
  State<UnlockTools> createState() => _UnlockToolsState();
}

class _UnlockToolsState extends State<UnlockTools> {
  Map keytoolsdata = {};
  Map keydata = {};
  int seletooth = 0;
  int seleb = 0;
  int tooth = 0; //齿数
  late List<String> ahNums;
  late List<String> bhNums = [];
  late List<int> aAngle;
  late List<int> bAngle;
  late List<String> chNums;
  bool dir = false;
  bool toothcover = false;
  int currenttooth = -1;
  late double ws; //屏幕宽
  late double hs; //屏幕高
  static double wss = 640; //原设计尺寸
  static double hss = 360; //原设计尺寸
  bool loadestate = false;
  int inputmode = 1; //输入模式 0:从钥匙头部开始输入 1从钥匙尾部开始输入
  @override
  void initState() {
    //  WidgetsFlutterBinding.ensureInitialized();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    hs = WidgetsBinding.instance.window.physicalSize.width /
        WidgetsBinding.instance.window.devicePixelRatio;
    ws = WidgetsBinding.instance.window.physicalSize.height /
        WidgetsBinding.instance.window.devicePixelRatio;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // print("加载完成");
    });
    //print(WidgetsBinding.instance.window.physicalSize.width);
    //print(WidgetsBinding.instance.window.physicalSize.height);
    //print(ws);
    //print(hs);
    //print(ScreenUtil().screenWidth);
    //print(ScreenUtil().screenHeight);
    keytoolsdata = Map.from(widget.arguments);

    getkeydata();
//printkeytoolsdata);
    tooth = keytoolsdata["toothsa"].length;
    if (keytoolsdata["side"] == 2 && keydata["class"] != 0) {
      if (inputmode == 1) {
        seletooth = tooth * 2 - 1;
      }
      ahNums = List.filled(tooth * 2, "?");
    } else {
      ahNums = List.filled(tooth, "?");
      if (inputmode == 1) {
        seletooth = tooth - 1;
      }
      //ahNums = List.filled(tooth * 2, "?");
    }
    if (keytoolsdata["keyid"] == 158) {
      seletooth = 5;
      ahNums = List.filled(tooth, "0");
      aAngle = List.filled(6, 0);
      bhNums = List.filled(3, "0");
      chNums = List.filled(3, "0");
    }
    if (keytoolsdata["keyid"] == 159) {
      seletooth = 5;
      ahNums = List.filled(tooth, "0");
      aAngle = List.filled(8, 0);
      bhNums = List.filled(4, "0");
      chNums = List.filled(4, "0");
    }
    // SystemChrome.setPreferredOrientations([
    //   // DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight
    // ]);

    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  double getw(double w) {
    return w * (ws / wss);
    // return w / wss * ws;
  }

  double geth(double h) {
    // return h / hss * hs;
    return h * (hs / hss);
  }

  getkeydata() {
    for (var i = 0; i < appData.carkeyList.length; i++) {
      if (keytoolsdata["keyid"] == appData.carkeyList[i]["id"]) {
        keydata = Map.from(appData.carkeyList[i]);
      }
    }
  }

  bool _checkdata(int lessnum) {
    int num = 0;
//printahNums);
    ////print(bhNums);

    for (var element in ahNums) {
      if (element == "?") {
        num++;
      }
    }
    if (num > lessnum) {
      return false;
    }

    return true;
  }

//获取齿号
  String getahnums() {
//printahNums);
//printbhNums);
//printchNums);
    //print(keytoolsdata["side"]);
    if (keytoolsdata["side"] == 2) {
      print(ahNums);
      //print(listStringToString(
      //     List.from((ahNums.sublist(0, ahNums.length ~/ 2)))) +
      //    "-" +
      //     listStringToString(List.from((ahNums.sublist(ahNums.length ~/ 2)))));

      return listStringToString(
              List.from((ahNums.sublist(0, ahNums.length ~/ 2)).reversed)) +
          "-" +
          listStringToString(
              List.from((ahNums.sublist(ahNums.length ~/ 2)).reversed));
    } else {
      if (keytoolsdata["keyid"] == 158 || keytoolsdata["keyid"] == 159) {
        return listStringToString(List.from(ahNums.reversed)) +
            "-" +
            listStringToString(List.from(bhNums.reversed)) +
            "-" +
            listStringToString(List.from(chNums.reversed));
      } else {
        return listStringToString(List.from(ahNums.reversed));
      }
    }
  }

  @override
  void dispose() {
    //设置横屏
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    //设置状态栏隐藏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.dispose();
  }

  List<Widget> _keyboard() {
    List<Widget> temp = [];
    List<Widget> temp1 = [];
    int count = keytoolsdata["toothstr"].length;
    //print(count);

    for (var j = 0; j < (count + 5) ~/ 6; j++) {
      //print(j);
      for (var i = 0; i < (count <= 6 ? count : 6); i++) {
        temp1.add(Container(
          width: getw(28),
          height: geth(43),
          decoration: BoxDecoration(
              color: currenttooth == j * 6 + i
                  ? const Color(0xff384c70)
                  : Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(4.0)),
          child: GestureDetector(
            child: Center(
              child: Text(
                keytoolsdata["toothstr"][j * 6 + i],
                style: TextStyle(
                    color:
                        currenttooth == j * 6 + i ? Colors.white : Colors.black,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onTapDown: (t) {
              currenttooth = j * 6 + i;
              ahNums[seletooth] = keytoolsdata["toothstr"][j * 6 + i];
              if (inputmode == 1) {
                seletooth--;

                if (seletooth < 0) {
                  if (keytoolsdata["keyid"] == 158 ||
                      keytoolsdata["keyid"] == 159) {
                    seletooth = 5;
                  } else {
                    if (keytoolsdata["side"] == 2) {
                      seletooth = tooth * 2 - 1;
                    } else {
                      seletooth = tooth - 1;
                    }
                  }
                }
              } else {
                seletooth++;
                if (keytoolsdata["keyid"] == 158 ||
                    keytoolsdata["keyid"] == 159) {
                  if (seletooth > 5) {
                    seletooth = 0;
                  }
                } else {
                  if (keytoolsdata["side"] == 2) {
                    if (seletooth > tooth * 2 - 1) {
                      seletooth = 0;
                    }
                  } else {
                    if (seletooth > tooth - 1) {
                      seletooth = 0;
                    }
                  }
                }
              }

              setState(() {});
            },
          ),
        ));
      }
      temp.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: temp1,
      ));
    }
    return temp;
  }

  List<Widget> _uppic() {
    List<Widget> temp = [];
    for (var i = 0; i < keytoolsdata["uppic"].length; i++) {
      temp.add(
        Expanded(
          child: SizedBox(
            //padding:const EdgeInsets.all(20.r),
            //color: Colors.red,
            // child: Image.file(
            //   File(appData.keyImagePath +
            //       "/readtools/" +
            //       keytoolsdata["uppic"][i]),
            //   //  fit: BoxFit.cover,
            // ),
            child:
                Image.asset("image/tank/readtools/" + keytoolsdata["uppic"][i]),
          ),
        ),
      );
    }
    return temp;
  }

//162t 计算齿号
  _getTooth() {
    if (keytoolsdata["keyid"] == 158) {
      //162t9齿
      //print(aAngle);
      if (aAngle[3] == 30) {
        chNums[0] = ((aAngle[0] - aAngle[3]) ~/ 30).toString();
        bhNums[0] = (5 - ((aAngle[0] - aAngle[3]) ~/ 30)).toString();
      }
      if (aAngle[3] == 60) {
        chNums[0] = ((aAngle[0] - aAngle[3]) ~/ 30 + 3).toString();
        bhNums[0] = (5 - ((aAngle[0] - aAngle[3]) ~/ 30 + 3)).toString();
      }
      if (aAngle[4] == 30) {
        chNums[1] = ((aAngle[1] - aAngle[4]) ~/ 30).toString();
        bhNums[1] = (5 - ((aAngle[1] - aAngle[4]) ~/ 30)).toString();
      }
      if (aAngle[4] == 60) {
        chNums[1] = ((aAngle[1] - aAngle[4]) ~/ 30 + 3).toString();
        bhNums[1] = (5 - ((aAngle[1] - aAngle[4]) ~/ 30 + 3)).toString();
      }
      if (aAngle[5] == 30) {
        bhNums[2] = ((aAngle[2] - aAngle[5]) ~/ 30).toString();
        chNums[2] = (5 - ((aAngle[2] - aAngle[5]) ~/ 30)).toString();
      }
      if (aAngle[5] == 60) {
        bhNums[2] = ((aAngle[2] - aAngle[5]) ~/ 30 + 3).toString();
        chNums[2] = (5 - ((aAngle[2] - aAngle[5]) ~/ 30 + 3)).toString();
      }
      //print(bhNums);
      ahNums[6] = (6 - int.parse(bhNums[0])).toString();
      ahNums[7] = (6 - int.parse(bhNums[1])).toString();
      ahNums[8] = (6 - int.parse(bhNums[2])).toString();
    }
    print(aAngle);

    if (keytoolsdata["keyid"] == 159) {
      if (aAngle[4] == 30) {
        bhNums[0] = ((aAngle[0] - aAngle[4]) ~/ 30).toString();
        chNums[0] = (5 - (5 - (aAngle[0] - aAngle[4]) ~/ 30)).toString();
      }
      if (aAngle[4] == 60) {
        bhNums[0] = ((aAngle[0] - aAngle[4]) ~/ 30 + 3).toString();
        chNums[0] = (5 - ((aAngle[0] - aAngle[4]) ~/ 30 + 3)).toString();
      }
      if (aAngle[5] == 30) {
        bhNums[1] = ((aAngle[1] - aAngle[5]) ~/ 30).toString();
        chNums[1] = (5 - ((aAngle[1] - aAngle[5]) ~/ 30)).toString();
      }
      if (aAngle[5] == 60) {
        bhNums[1] = ((aAngle[1] - aAngle[5]) ~/ 30 + 3).toString();
        chNums[1] = (5 - ((aAngle[1] - aAngle[5]) ~/ 30 + 3)).toString();
      }
      if (aAngle[6] == 30) {
        bhNums[2] = (5 - ((aAngle[2] - aAngle[6]) ~/ 30)).toString();
        chNums[2] = (5 - int.parse(bhNums[2])).toString();
      }
      if (aAngle[6] == 60) {
        bhNums[2] = (5 - ((aAngle[2] - aAngle[6]) ~/ 30 + 3)).toString();
        chNums[2] = (5 - int.parse(bhNums[2])).toString();
      }

      if (aAngle[7] == 30) {
        bhNums[3] = (5 - ((aAngle[3] - aAngle[7]) ~/ 30)).toString();
        chNums[3] = (5 - int.parse(bhNums[3])).toString();
      }
      if (aAngle[7] == 60) {
        bhNums[3] = (5 - ((aAngle[3] - aAngle[7]) ~/ 30 + 3)).toString();
        chNums[3] = (5 - int.parse(bhNums[3])).toString();
      }

      ahNums[6] = (6 - int.parse(bhNums[0])).toString();
      ahNums[7] = (6 - int.parse(bhNums[1])).toString();
      ahNums[8] = (6 - int.parse(bhNums[2])).toString();
      ahNums[9] = (6 - int.parse(bhNums[3])).toString();
    }
  }

//162t B边的齿号显示
  List<Widget> bTooth() {
    // List<int> atemp = [];

    List<Widget> temp = [];
    int btooth = 0;
    if (keytoolsdata["keyid"] == 158) {
      btooth = 3;
    }
    if (keytoolsdata["keyid"] == 159) {
      btooth = 4;
    }
    for (var i = 0; i < btooth; i++) {
      temp.add(Container(
        width: getw(20),
        height: geth(30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("image/tank/readtools/icon/reade_code_sp.png"))),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: Text(
            bhNums[i],
            textAlign: TextAlign.center,
          ),
          onPressed: () {},
        ),
      ));
    }
    temp = List.from(temp.reversed);
    return temp;
  }

//162t C边的齿号显示
  List<Widget> cTooth() {
    // List<int> atemp = [];

    List<Widget> temp = [];
    int btooth = 0;
    if (keytoolsdata["keyid"] == 158) {
      btooth = 3;
    }
    if (keytoolsdata["keyid"] == 159) {
      btooth = 4;
    }
    for (var i = 0; i < btooth; i++) {
      temp.add(Container(
        width: getw(20),
        height: geth(30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("image/tank/readtools/icon/reade_code_sp.png"))),
        child: TextButton(
          style: ButtonStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          child: Text(
            chNums[i],
            textAlign: TextAlign.center,
          ),
          onPressed: () {},
        ),
      ));
    }
    temp = List.from(temp.reversed);
    return temp;
  }

//开启前上下齿号
  List<Widget> aupTooth() {
    List<int> atemp = [];
    if (keytoolsdata["keyid"] == 158) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
    }
    if (keytoolsdata["keyid"] == 159) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
      atemp.add(0);
    }
    List<Widget> temp = [];
    for (var i = 0; i < atemp.length; i++) {
      if (atemp[i] == 0) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seleb == i
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              aAngle[i].toString(),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              seleb = i;
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(20),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

  List<Widget> adownTooth() {
    List<int> atemp = [];
    if (keytoolsdata["keyid"] == 158) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
    }
    if (keytoolsdata["keyid"] == 159) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
      atemp.add(0);
    }
    List<Widget> temp = [];
    for (var i = 0; i < atemp.length; i++) {
      if (atemp[i] == 1) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seleb == i
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              aAngle[i].toString(),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              seleb = i;
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(20),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

//开启后上下齿号
  List<Widget> bupTooth() {
    List<Widget> temp = [];
    List<int> atemp = [];
    if (keytoolsdata["keyid"] == 158) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
    }
    if (keytoolsdata["keyid"] == 159) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
      atemp.add(0);
    }
    for (var i = 0; i < atemp.length; i++) {
      if (atemp[i] == 0) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seleb == i + atemp.length
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              aAngle[i + atemp.length].toString(),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              seleb = atemp.length + i;
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(20),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

  List<Widget> bdownTooth() {
    List<Widget> temp = [];
    List<int> atemp = [];
    if (keytoolsdata["keyid"] == 158) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
    }
    if (keytoolsdata["keyid"] == 159) {
      atemp.add(1);
      atemp.add(1);
      atemp.add(0);
      atemp.add(0);
    }
    for (var i = 0; i < atemp.length; i++) {
      if (atemp[i] == 1) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seleb == i + atemp.length
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              aAngle[i + atemp.length].toString(),
              textAlign: TextAlign.center,
            ),
            onPressed: () {
              seleb = i + atemp.length;
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(20),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

//钥匙上下齿号的显示

  List<Widget> upTooth() {
    List<Widget> temp = [];
    if (keytoolsdata["side"] == 2) {
      for (var i = 0; i < keytoolsdata["toothsa"].length; i++) {
        keytoolsdata["toothsa"][i] = 0;
      }
    }

    int temptooth = keytoolsdata["toothsa"].length;
    for (var i = 0; i < temptooth; i++) {
      if (keytoolsdata["toothsa"][i] == 0) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seletooth == i
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              ahNums[i],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (keytoolsdata["keyid"] == 158 ||
                  keytoolsdata["keyid"] == 159) {
                if (i < 6) {
                  seletooth = i;
                }
              } else {
                seletooth = i;
              }
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

  List<Widget> downTooth() {
    List<Widget> temp = [];
    int sidediff = 0;
    if (keytoolsdata["side"] == 2) {
      for (var i = 0; i < keytoolsdata["toothsa"].length; i++) {
        keytoolsdata["toothsa"][i] = 1;
      }
      sidediff = tooth;
    }
    for (var i = 0; i < keytoolsdata["toothsa"].length; i++) {
      if (keytoolsdata["toothsa"][i] == 1) {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(seletooth == i + sidediff
                      ? "image/tank/readtools/icon/reade_code_sp1.png"
                      : "image/tank/readtools/icon/reade_code_sp.png"))),
          child: TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
            ),
            child: Text(
              ahNums[i + sidediff],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: () {
              if (keytoolsdata["keyid"] == 158 ||
                  keytoolsdata["keyid"] == 159) {
                if (i < 6) {
                  seletooth = i;
                }
              } else {
                seletooth = i + sidediff;
              }
              setState(() {});
            },
          ),
        ));
      } else {
        temp.add(Container(
          width: getw(20),
          height: geth(30),
          margin: const EdgeInsets.all(2),
        ));
      }
    }
    temp = List.from(temp.reversed);
    return temp;
  }

  List<Widget> _downpic() {
    List<Widget> temp = [];
    for (var i = 0; i < keytoolsdata["downpic"].length; i++) {
      temp.add(
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: upTooth(),
            ),
            Expanded(
                child: Image.asset(
              "image/tank/readtools/" + keytoolsdata["downpic"][i],
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: downTooth(),
            ),
          ],
        )),
      );
    }
    temp.add(Expanded(
        child: SizedBox(
      child: Row(
        children: [
          Expanded(
              child: SizedBox(
            child: Column(
              children: [
                Expanded(
                    child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: _keyboard(),
                  ),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: getw(30),
                      height: geth(30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        child: Image.asset(
                          "image/tank/readtools/icon/reade_code_lock.png",
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          ahNums[seletooth] = "?";
                          if (inputmode == 1) {
                            seletooth--;

                            if (seletooth < 0) {
                              if (keytoolsdata["keyid"] == 158 ||
                                  keytoolsdata["keyid"] == 159) {
                                seletooth = 5;
                              } else {
                                if (keytoolsdata["side"] == 2) {
                                  seletooth = tooth * 2 - 1;
                                } else {
                                  seletooth = tooth - 1;
                                }
                              }
                            }
                          } else {
                            seletooth++;
                            if (keytoolsdata["keyid"] == 158 ||
                                keytoolsdata["keyid"] == 159) {
                              if (seletooth > 5) {
                                seletooth = 0;
                              }
                            } else {
                              if (keytoolsdata["side"] == 2) {
                                if (seletooth > tooth * 2 - 1) {
                                  seletooth = 0;
                                }
                              } else {
                                if (seletooth > tooth - 1) {
                                  seletooth = 0;
                                }
                              }
                            }
                          }

                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: getw(30),
                      height: geth(30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        child: Image.asset(
                          "image/tank/readtools/icon/reade_code_left.png",
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          seletooth++;
                          if (keytoolsdata["side"] == 2) {
                            if (seletooth > tooth * 2 - 1) {
                              seletooth = 0;
                            }
                          } else {
                            if (seletooth > tooth - 1) {
                              seletooth = 0;
                            }
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: getw(30),
                      height: geth(30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        // child: Image.file(
                        //   File(appData.keyImagePath +
                        //       "/readtools/icon/reade_code_right.png"),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image.asset(
                          "image/tank/readtools/icon/reade_code_right.png",
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          seletooth--;
                          if (seletooth < 0) {
                            seletooth = tooth - 1;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    Container(
                      width: getw(30),
                      height: geth(30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        // child: Image.file(
                        //   File(appData.keyImagePath +
                        //       "/readtools/icon/reade_code_up.png"),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image.asset(
                          "image/tank/readtools/icon/reade_code_up.png",
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Container(
                      width: getw(30),
                      height: geth(30),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: TextButton(
                        style: ButtonStyle(
                            padding:
                                MaterialStateProperty.all(EdgeInsets.zero)),
                        // child: Image.file(
                        //   File(appData.keyImagePath +
                        //       "/readtools/icon/reade_code_down.png"),
                        //   fit: BoxFit.cover,
                        // ),
                        child: Image.asset(
                          "image/tank/readtools/icon/reade_code_down.png",
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: geth(10),
                ),
              ],
            ),
          )),
          SizedBox(
            width: getw(10),
          ),
          Column(
            children: [
              // keytoolsdata["keyid"] == 242
              //     ? ElevatedButton(
              //         onPressed: () {
              //           ahNums[1] = (6 - (int.parse(ahNums[1]))).toString();
              //           ahNums[3] = (6 - (int.parse(ahNums[3]))).toString();
              //           ahNums[4] = (6 - (int.parse(ahNums[4]))).toString();
              //           ahNums[6] = (6 - (int.parse(ahNums[6]))).toString();
              //           setState(() {});
              //         },
              //         child: Text(toothcover ? "还原齿号" : "齿号转换"))
              //     : const SizedBox(),

              Expanded(
                child: SizedBox(
                  width: getw(68),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff384c70)),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () async {
                      //如果有数据库 缺3齿可查询 否则不能查询需要输入全部齿号
                      if ((_checkdata(3) && keytoolsdata["isn"] != 0) ||
                          _checkdata(0)) {
                        //print(getahnums());

                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.landscapeRight,
                        ]);
                        //设置状态栏隐藏
                        // await SystemChrome.setEnabledSystemUIMode(
                        //     SystemUiMode.manual,
                        //     overlays: [
                        //       SystemUiOverlay.top,
                        //       SystemUiOverlay.bottom
                        //     ]);

                        baseKey.initdata(keydata);

                        Navigator.pushNamed(context, '/openclamp', arguments: {
                          "state": 0,
                          "bitting": getahnums(),
                          "dir": true
                        });
                      } else {
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("缺齿太多,请再多输入几个");
                            });
                      }
                    },
                    child: Text("加\r\n工\r\n钥\r\n匙",
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: getw(10),
          ),
        ],
      ),
    )));
    return temp;
  }

  Widget getShowWidget() {
    //根据钥匙ID显示页面布局
    switch (keytoolsdata["keyid"]) {
      case 159: //162t 10 齿
      case 158: //162t 9 齿
        //print(seleb);
        //    //print(appData.rootpath + "/image/readtools/" + keytoolsdata["uppic"][0]);
        //   //print(appData.rootpath + "/image/readtools/" + keytoolsdata["downpic"][0]);
        return SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: Row(
            children: [
              Expanded(
                child: Container(
                    margin: EdgeInsets.only(left: getw(10), bottom: geth(10)),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(geth(10))),
                    child: Column(
                      children: [
                        Expanded(
                          child: SizedBox(
                            // child: Image.file(
                            //   File(appData.keyImagePath +
                            //       "/readtools/" +
                            //       keytoolsdata["uppic"][0]),

                            // ),
                            child: Image.asset(
                              "image/tank/readtools/" +
                                  keytoolsdata["uppic"][0],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: upTooth(),
                        ),
                        SizedBox(
                            width: double.maxFinite,
                            child: Image.asset("image/tank/readtools/" +
                                keytoolsdata["downpic"][0])),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: downTooth(),
                        ),
                        //B边齿号
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: bTooth(),
                        ),
                        // Image.file(File(appData.keyImagePath +
                        //     "/readtools/read_code_162_b.png")),
                        // Image.file(File(appData.keyImagePath +
                        //     "/readtools/read_code_162_c.png")),
                        Image.asset("image/tank/readtools/read_code_162_b.png"),
                        Image.asset("image/tank/readtools/read_code_162_c.png"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: cTooth(),
                        ),
                      ],
                    )),
              ),
              //  Divider(),
              // Expanded(child: SizedBox()),
              SizedBox(
                width: getw(10),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: geth(172),
                      width: getw(305),
                      margin: EdgeInsets.only(right: getw(10), bottom: geth(5)),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(getw(10))),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: aupTooth()),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      // child: Image.file(File(appData.keyImagePath +
                                                      //     "/readtools/read_code_hu162t_open.png")),
                                                      child: Image.asset(
                                                          "image/tank/readtools/read_code_162_b.png"),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: adownTooth()),
                                              ],
                                            ),
                                          ),
                                          const Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text("开启前"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: bupTooth()),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      // child: Image.file(File(appData.keyImagePath +
                                                      //     "/readtools/read_code_hu162t_open.png")
                                                      child: Image.asset(
                                                          "image/tank/readtools/read_code_162_c.png"),
                                                    ),
                                                    //  const Text("开启后")
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: bdownTooth()),
                                              ],
                                            ),
                                          ),
                                          const Align(
                                            alignment: Alignment.bottomLeft,
                                            child: Text("开启后"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              )),
                          Expanded(
                              flex: 3,
                              child: Image.asset(
                                  "image/tank/readtools/read_code_hu162_d.png")),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: getw(305),
                        margin:
                            EdgeInsets.only(right: getw(10), bottom: geth(10)),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(children: [
                                _keyboard()[0],
                                const Expanded(child: SizedBox()),
                                SizedBox(
                                  height: geth(61),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: getw(60),
                                        height: getw(60),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          // child: Image.file(File(appData
                                          //         .keyImagePath +
                                          //     "/readtools/icon/read_code_30.png")),
                                          child: Image.asset(
                                              "image/tank/readtools/icon/read_code_30.png"),
                                          onPressed: () {
                                            if (keytoolsdata["keyid"] == 158) {
                                              if (seleb < 3) {
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return RotatedBox(
                                                          quarterTurns: 1,
                                                          child: MyTextDialog(S
                                                              .of(context)
                                                              .readtoolsno30));
                                                    });
                                                // Fluttertoast.showToast(
                                                //     msg: S
                                                //         .of(context)
                                                //         .readtoolsno90);
                                              } else {
                                                aAngle[seleb] = 30;
                                              }
                                            }
                                            if (keytoolsdata["keyid"] == 159) {
                                              if (seleb < 4) {
                                                // Fluttertoast.showToast(
                                                //     msg: S
                                                //         .of(context)
                                                //         .readtoolsno30);
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return RotatedBox(
                                                          quarterTurns: 1,
                                                          child: MyTextDialog(S
                                                              .of(context)
                                                              .readtoolsno30));
                                                    });
                                              } else {
                                                aAngle[seleb] = 30;
                                              }
                                            }
                                            _getTooth();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: getw(60),
                                        height: getw(60),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          // child: Image.file(File(appData
                                          //         .keyImagePath +
                                          //     "/readtools/icon/read_code_60.png")),
                                          child: Image.asset(
                                              "image/tank/readtools/icon/read_code_60.png"),
                                          onPressed: () {
                                            aAngle[seleb] = 60;
                                            _getTooth();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: getw(60),
                                        height: getw(60),
                                        child: TextButton(
                                          style: ButtonStyle(
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.zero)),
                                          // child: Image.file(File(appData
                                          //         .keyImagePath +
                                          //     "/readtools/icon/read_code_90.png")),
                                          child: Image.asset(
                                              "image/tank/readtools/icon/read_code_90.png"),
                                          onPressed: () {
                                            if (keytoolsdata["keyid"] == 158) {
                                              if (seleb > 2) {
                                                // Fluttertoast.showToast(
                                                //     msg: S
                                                //         .of(context)
                                                //         .readtoolsno30);
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return RotatedBox(
                                                          quarterTurns: 1,
                                                          child: MyTextDialog(S
                                                              .of(context)
                                                              .readtoolsno90));
                                                    });
                                              } else {
                                                aAngle[seleb] = 90;
                                              }
                                            } else {
                                              if (seleb > 3) {
                                                // Fluttertoast.showToast(
                                                //     msg: S
                                                //         .of(context)
                                                //         .readtoolsno90);
                                                showDialog(
                                                    context: context,
                                                    builder: (c) {
                                                      return RotatedBox(
                                                          quarterTurns: 1,
                                                          child: MyTextDialog(S
                                                              .of(context)
                                                              .readtoolsno90));
                                                    });
                                              } else {
                                                aAngle[seleb] = 90;
                                              }
                                            }
                                            _getTooth();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ]),
                            ),
                            Column(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              EdgeInsets.zero),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  const Color(0xff384c70))),
                                      onPressed: () {
                                        if (keytoolsdata["keyid"] == 158) {
                                          ahNums[1] = (6 - int.parse(ahNums[1]))
                                              .toString();
                                          ahNums[3] = (6 - int.parse(ahNums[3]))
                                              .toString();
                                          ahNums[4] = (6 - int.parse(ahNums[4]))
                                              .toString();
                                        }
                                        if (keytoolsdata["keyid"] == 159) {
                                          ahNums[1] = (6 - int.parse(ahNums[1]))
                                              .toString();
                                          ahNums[2] = (6 - int.parse(ahNums[2]))
                                              .toString();
                                          ahNums[4] = (6 - int.parse(ahNums[4]))
                                              .toString();
                                        }
                                        setState(() {});
                                        toothcover = !toothcover;
                                      },
                                      child:
                                          Text(toothcover ? "还原齿号" : "齿号转换")),
                                ),
                                SizedBox(
                                  height: geth(5),
                                ),
                                Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                EdgeInsets.zero),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    const Color(0xff384c70))),
                                        onPressed: () {
                                          bool readycut = true;
                                          if (keytoolsdata["keyid"] == 159) {
                                            for (var i = 0; i < tooth; i++) {
                                              if (ahNums[i] == "0" ||
                                                  ahNums[i] == "6" ||
                                                  ahNums[i] == "?") {
                                                readycut = false;
                                                break;
                                              }
                                            }
                                            for (var i = 0; i < 4; i++) {
                                              if (bhNums[i] == "0") {
                                                readycut = false;
                                                break;
                                              }
                                              if (ahNums[i] == "0") {
                                                readycut = false;
                                                break;
                                              }
                                            }
                                          }
                                          if (readycut) {
                                            if (toothcover) {
                                              baseKey.initdata(keydata);
                                              // SystemChrome
                                              //     .setPreferredOrientations([
                                              //   DeviceOrientation.portraitUp,
                                              //   DeviceOrientation.portraitDown
                                              // ]);
                                              // //设置状态栏隐藏
                                              // SystemChrome
                                              //     .setEnabledSystemUIMode(
                                              //         SystemUiMode.manual,
                                              //         overlays: [
                                              //       SystemUiOverlay.top,
                                              //       SystemUiOverlay.bottom
                                              //     ]);
                                              Navigator.pushNamed(
                                                  context, '/openclamp',
                                                  arguments: {
                                                    "keydata": keydata,
                                                    "state": 0,
                                                    "bitting": getahnums(),
                                                    "dir": true
                                                  });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "请先转换齿号");
                                            }
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder: (c) {
                                                  return const RotatedBox(
                                                      quarterTurns: 1,
                                                      child: MyTextDialog(
                                                          "缺齿太多,请再多输入几个"));
                                                });
                                          }
                                        },
                                        child: const Text(
                                          "加工钥匙",
                                        ))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return SizedBox(
          child: Column(
            children: [
              //SizedBox(height: geth(30)),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(
                    left: getw(10), right: getw(10), bottom: geth(10)),
                child: Row(
                  children: _uppic(),
                ),
              )),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(
                      left: getw(10), right: getw(10), bottom: geth(10)),
                  child: Row(
                    children: _downpic(),
                  ),
                ),
              ),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RotatedBox(
        quarterTurns: 1,
        child: Scaffold(
          backgroundColor: const Color(0xffeeeeee),
          appBar: userTankBar(context),
          body: getShowWidget(),
        ),
      ),
    );
  }
}

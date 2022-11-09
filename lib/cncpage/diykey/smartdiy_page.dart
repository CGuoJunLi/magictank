import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:magictank/cncpage/bluecmd/cmd.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/share_manganger.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/cncpage/mycontainer.dart';
import 'package:magictank/dialogshow/dialogpage.dart';
import 'package:magictank/generated/l10n.dart';

import 'package:magictank/home4_page.dart';
import 'package:magictank/swiper/flutter_swiper_null_safety.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../../alleventbus.dart';

import '../../appdata.dart';
//import '../copykey/copykeypreview_page.dart';
import '../cutkey/canvas.dart';

import 'diykeypreview.dart';
import 'package:magictank/http/api.dart';

class SmartDiyPage extends StatefulWidget {
  const SmartDiyPage({
    Key? key,
  }) : super(key: key);
  @override
  _SmartDiyPageState createState() => _SmartDiyPageState();
}

class _SmartDiyPageState extends State<SmartDiyPage>
    with TickerProviderStateMixin {
  String keytitle = "";
  bool previewstate = false;
  late ProgressDialog pd;
  int currentnum = 0;
  int allnum = 0;
  int tooth = 0;
  List<bool> buttonState = [true, false, false];
  List<int> ahNum = []; //标准齿深
  List<int> bhNum = []; //标准齿深
  List<int> sAhNum = []; //A边实际的齿深
  List<int> sBhNum = []; //B边实际的齿深
  List<String> ahNums = []; //A边齿号
  List<String> bhNums = []; //B边齿号
  bool advancedBt = false;
  Offset touchoffect = const Offset(0, 0);
  int diykeystep = 1;
  bool readHNum = false;
  // Map fineTuning = {"index": 0, "data": 1};
  int diff = 1;
  late StreamSubscription eventBusF;
  bool gesture = true; //手势调整
  late StreamSubscription btstatet;
  int cutsindex = 0;
  String currentkeypic = "";
  String currentfixturepic = "";
  int seleside = 0;
  RegExp onlynum = RegExp(r'[0-9]+'); //数字和和字母组成
  ///控制tab显示
  int currentTab = 0;
  Map keydata = {
    "carname": "",
    "carmodel": "",
    "carmodeltime": "",
    "hide": false,
    "cnname": "",
    "enname": "",
    "picname": "",
    "indexes": "",
    "id": 0,
    "smart": false,
    "nonconductive": false,
    "fixture": [5],
    "class": 0,
    "locat": 0,
    "side": 0,
    "wide": 0,
    "thickness": 0,
    "length": 0,
    "depth": 0,
    "groove": 0,
    "A": 0,
    "AX": 0,
    "B": 0,
    "BX": 0,
    "headAx": 0,
    "headAy": 0,
    "headBx": 0,
    "headBy": 0,
    "headCx": 0,
    "headCy": 0,
    "headDx": 0,
    "headDy": 0,
    "toothDepth": [],
    "toothDepthName": [],
    "toothSA": [],
    "toothWideA": [],
    "toothSB": [],
    "toothWideB": [],
    "keynumbet": "",
    "chnote": "无",
    "ennote": "NULL",
    "moreside": [],
  };
  List<Map> keyclasslist = [
    {
      "name": S.current.keyclass0,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass0.png"
    },
    {
      "name": S.current.keyclass1,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass1.png"
    },
    {
      "name": S.current.keyclass2,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass2.png"
    },
    {
      "name": S.current.keyclass5,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass5.png"
    },
    {
      "name": S.current.keyclass3,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass3.png"
    },
    {
      "name": S.current.keyclass4,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass4.png"
    },
    {
      "name": S.current.keyclass6,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass31.png"
    },
    {
      "name": S.current.keyclass7,
      "pic": appData.keyImagePath + "/fixture/diykey/keyclass11.png"
    },
  ];
  List<Map> keylocatelist = [
    {
      "name": S.current.keylocat1,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_head.png"
    },
    {
      "name": S.current.keylocat0,
      "pic": appData.keyImagePath + "/fixture/diykey/locat_shoulder.png"
    },
  ];

  List<String> keyfixturelist = [
    S.current.keyside5,
    S.current.keyside6,
  ];
  List<String> keyfixturelis5 = [
    S.current.keyside6,
  ];
  List<String> keyfixturelist3 = [
    S.current.keyside0,
    S.current.keyside1,
    S.current.keyside3,
    S.current.keyside4,
  ];

  _autoConnectBT() {
    btstatet = eventBus.on<CNCConnectEvent>().listen((event) {
      if (event.state) {
        ////print(pd.isOpen());
        btstatet.cancel();
        pd.close();
      } else {
        pd.close();
        btstatet.cancel();
        showDialog(
            context: context,
            builder: (c) {
              return const MyTextDialog("连接失败,是否进入手动连接？");
            }).then((value) {
          if (value) {
            btstatet.cancel();
            Navigator.pushNamed(context, '/selecnc', arguments: 3);
          }
        });
      }
      setState(() {});
    });
    if (cncbtmodel.blSwitch) {
      if (appData.autoconnect && appData.cncbluetoothname != "") {
        pd.show(max: 100, msg: "连接中...");

        cncbt4model.autoConnect();
      } else {
        Navigator.pushNamed(context, '/selecnc', arguments: 3);
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return const MyTextDialog("请先打开蓝牙");
          });
    }
  }

  @override
  void initState() {
    diykeystep = 1;

    pd = ProgressDialog(context: context);
    baseKey.readstate == false;
    //initdata(keydata);
    //print("开始监听");
    //监听预览数据
    eventBusF = eventBus.on<PreViewEvent>().listen((event) {
      {
        currentnum = currentnum + event.toothdepth.length;
        if (keydata["side"] == 3 ||
            keydata["class"] == 5 ||
            keydata["class"] == 4 ||
            keydata["class"] == 0 ||
            keydata["class"] == 2) {
          allnum = event.tooth * 2;
        } else {
          allnum = event.tooth;
        }
        ////print(((currentnum / allnum) * 100).toInt());
        if (event.side == 0) {
          sAhNum.addAll(event.toothdepth);
        } else {
          sBhNum.addAll(event.toothdepth);
        }

        pd.update(value: ((currentnum / allnum) * 100).toInt());
        if (((currentnum / allnum) * 100).toInt() == 100) {
          keydata["wide"] = event.wide;
          keydata["thickness"] = event.thickness;
          keydata["length"] = event.length;
          keydata["depth"] = event.depth;
          print("keydepth:${keydata["depth"]}_${event.depth}");
          if (sBhNum.isEmpty) {
            sBhNum = List.from(sAhNum);
          }
          if (sAhNum.isEmpty) {
            sAhNum = List.from(sBhNum);
          }
          calculationKeyToothS();
          previewstate = true;
          if (pd.isOpen()) {
            pd.close();
          }
          diykeystep = 5;
          setState(() {});
        }

        // if (currentnum == allnum) {
        //   if (pd.isOpen()) {
        //     pd.close();
        //     previewstate = true;
        //     setState(() {});
        //   }
        // }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    //print("取消监听");
    eventBusF.cancel();
    super.dispose();
  }

  // void creatTooth() {
  //   //创建齿深
  //   int currentTooth = 0;
  //   int beginTooth = 0;
  //   int endTooth = 0;
  //   bool begin = false;
  //   List<int> toothSA = [];
  //   List<int> toothSAH = [];
  //   //print(List.from(ahNum.reversed));
  //   //print(bhNum);
  //   List<int> tempA = List.from(ahNum.reversed);
  //   for (var i = 0; i < tempA.length - 1; i++) {
  //     if ((tempA[i] == tempA[i + 1]) && !begin && tempA[i] != 0) {
  //       beginTooth = i;
  //       begin = true;
  //     }
  //     if ((begin && (tempA[i] != tempA[i + 1])) || (i == tempA.length - 1)) {
  //       endTooth = i;
  //       toothSA.add(endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 2);
  //       begin = false;
  //       toothSAH.add(tempA[i]);
  //     }
  //   }

  //   //print(toothSA.reversed);
  //   //print(toothSAH.reversed);
  // }

  void getToothNumStr() {} //获取齿号
//计算齿深
  void calculationKeyToothH() {
    List<int> toothDepthT = [];
    keydata["toothDepthName"] = []; //清空齿号数据
    keydata["toothDepth"] = []; //清空齿深数据
    //读码后获取的数据
    //print("处理数据");

    toothDepthT.addAll(baseKey.sAhNum);
    toothDepthT.addAll(baseKey.sBhNum);
    //print(toothDepthT);
    toothDepthT = toothDepthT.toSet().toList();
    //print(toothDepthT);
    for (var j = 0; j < keydata["toothSA"].length; j++) {
      toothDepthT.sort((left, right) => left.compareTo(right));
      for (var i = 0; i < toothDepthT.length - 1; i++) {
        if (toothDepthT[i] == 0) toothDepthT.remove(toothDepthT[i]);
        if ((toothDepthT[i] - toothDepthT[i + 1]).abs() < 20) {
          toothDepthT.remove(toothDepthT[i + 1]);
        }
      }
      //print("$j:$toothDepthT");
    }
    toothDepthT.sort((left, right) => right.compareTo(left));

    for (var i = 0; i < toothDepthT.length; i++) {
      keydata["toothDepthName"].add("${i + 1}");
    }
    keydata["toothDepth"] = List.from(toothDepthT);

    //print(keydata["toothDepthName"]);
    //print(keydata["toothDepth"]);

    baseKey.toothDepth = [];
    baseKey.toothDepthName = [];
    baseKey.toothDepth = List.from(keydata["toothDepth"]);
    baseKey.toothDepthName = List.from(keydata["toothDepthName"]);

    baseKey.asynctooth(); //显示齿号
  }

//计算钥匙齿位
  void calculationKeyToothS() {
    int beginTooth = 0;
    int endTooth = 0;
    bool begin = false;
    List<int> toothSA = []; //A边齿位
    List<int> toothSAH = []; //A边齿深
    List<int> toothSB = []; //B边齿位
    List<int> toothSBH = []; //B边齿深

    bool groove = true;
    //print("wide:${keydata["wide"]}");
    if (keydata["class"] == 0) {
      //平铣双边确定宽度确定方法,获得最大齿深
      List<int> wideTemp = [];
      wideTemp = List.from(sAhNum.reversed);
      wideTemp.sort((left, right) => right.compareTo(left));
      keydata["wide"] = wideTemp[0] * 2;
      keydata["side"] = 2;
      //print("wide:${keydata["wide"]}");
    }

    //print(List.from(sAhNum.reversed));
    //print(List.from(sBhNum.reversed));
    List<int> tempA = List.from(sAhNum.reversed);
    List<int> tempB = List.from(sBhNum.reversed);
    if (keydata["side"] == 1 || keydata["side"] == 3 || keydata["side"] == 2) {
      for (var i = 0; i < tempA.length - 1; i++) {
        if ((tempA[i] == tempA[i + 1]) && !begin && tempA[i] != 0) {
          beginTooth = i;
          begin = true;
        }
        if ((begin && (tempA[i] != tempA[i + 1])) || (i == tempA.length - 1)) {
          endTooth = i;
          if ((endTooth * 20 - beginTooth * 20) > 600) {
            toothSA.add(
                endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 3 * 2);
            toothSA.add(endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 3);
            toothSAH.add(tempA[i]);
            toothSAH.add(tempA[i]);
          } else {
            toothSA.add(endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 2);
            toothSAH.add(tempA[i]);
          }
          if (groove && (keydata["class"] == 5)) {
            keydata["groove"] = keydata["wide"] - tempA[i] - tempB[i];
            groove = false;
          }
          begin = false;
        }
      }
      if (keydata["class"] == 0 || keydata["class"] == 1) {
        keydata["depth"] = keydata["thickness"] + 20;
      }
      //  else {
      //   if (keydata["thickness"] >= 250) {
      //    // keydata["depth"] = 110;
      //   } else {
      //   //  keydata["depth"] = 80;
      //   }
      // }
    }

    if (keydata["side"] == 0 || keydata["side"] == 3) {
      beginTooth = 0;
      begin = false;
      endTooth = 0;
      for (var i = 0; i < tempB.length - 1; i++) {
        if ((tempB[i] == tempB[i + 1]) && !begin && tempB[i] != 0) {
          beginTooth = i;
          begin = true;
        }
        if ((begin && (tempB[i] != tempB[i + 1])) || (i == tempB.length - 1)) {
          endTooth = i;
          toothSB.add(endTooth * 20 - (endTooth * 20 - beginTooth * 20) ~/ 2);
          if (groove && (keydata["class"] == 5)) {
            keydata["groove"] = keydata["wide"] - tempB[i] - tempA[i];
            groove = false;
          }
          begin = false;
          toothSBH.add(tempB[i]);
        }
      }
      if (keydata["class"] == 0 || keydata["class"] == 1) {
        keydata["depth"] = keydata["thickness"] + 20;
      }
      // else {
      //   if (keydata["thickness"] >= 250) {
      //     keydata["depth"] = 110;
      //   } else {
      //     keydata["depth"] = 80;
      //   }
      // }
    }
    if (toothSA.isEmpty) {
      toothSA = List.from(toothSB);
      toothSAH = List.from(toothSBH);
    }
    if (toothSB.isEmpty) {
      toothSB = List.from(toothSA);
      toothSBH = List.from(toothSAH);
    }

    keydata["toothSA"] = List.from(toothSA.reversed);
    keydata["toothSB"] = List.from(toothSB.reversed);
    tooth = keydata["toothSA"].length;
    if (keydata["locat"] == 0) {
      //如果是对肩膀的重新计算数据
      tempA = [];
      tempB = [];
      //print("对肩膀");
      //print(keydata["toothSA"]);
      //print(keydata["toothSB"]);
      for (var i = 0; i < tooth; i++) {
        tempA.add(keydata["length"] - keydata["toothSA"][i]);
      }
      for (var i = 0; i < tooth; i++) {
        tempB.add(keydata["length"] - keydata["toothSB"][i]);
      }
      keydata["toothSA"] = List.from(tempA);
      keydata["toothSB"] = List.from(tempB);
      //print(keydata["toothSA"]);
      //print(keydata["toothSB"]);
    }
    // "toothDepth": [],
    // "toothDepthName": [],
    // "toothSA": [],
    // "toothWideA": [],
    // "toothSB": [],
    // "toothWideB": [],
    // List<int> toothDepth = [];
    // List<int> toothDepthT = [];
    // keydata["toothDepthName"] = [];
    // toothDepthT.addAll(toothSAH);
    // toothDepthT.addAll(toothSBH);
    // toothDepthT = toothDepthT.toSet().toList();
    // for (var i = 0; i < toothDepthT.length - 1; i++) {
    //   if ((toothDepthT[i] - toothDepthT[i + 1]).abs() < 10) {
    //     toothDepthT.remove(toothDepthT[i + 1]);
    //   }
    // }
    // for (var j = 0; j < toothDepthT.length; j++) {
    //   for (var i = j + 1; i < toothDepthT.length; i++) {
    //     if ((toothDepthT[j] - toothDepthT[i]).abs() > 10) {
    //       toothDepth.add(toothDepthT[i]);
    //     }
    //   }
    // }
    // toothDepth = toothDepth.toSet().toList();

    // toothDepth.sort((left, right) => right.compareTo(left));
    // for (var i = 0; i < toothDepth.length; i++) {
    //   keydata["toothDepthName"].add("${i + 1}");
    // }
    // keydata["toothDepth"] = List.from(toothDepth);

    // //print(keydata["toothDepthName"]);
    // //print(keydata["toothDepth"]);

    // ahNum = List.from(toothSAH.reversed);
    // bhNum = List.from(toothSBH.reversed);
    // ahNums = [];
    // bhNums = [];
    // for (var i = 0; i < ahNum.length; i++) {
    //   for (var j = 0; j < keydata["toothDepth"].length; j++) {
    //     if ((ahNum[i] - keydata["toothDepth"][j]).abs() <= 10) {
    //       ahNums.add(keydata["toothDepthName"][j]);
    //     }
    //   }
    // }
    // for (var i = 0; i < bhNum.length; i++) {
    //   for (var j = 0; j < keydata["toothDepth"].length; j++) {
    //     if ((bhNum[i] - keydata["toothDepth"][j]).abs() <= 10) {
    //       bhNums.add(keydata["toothDepthName"][j]);
    //     }
    //   }
    // }

    //print("tooth:$tooth");
    _changeToooth();

    //print(keydata["toothSA"]);
    //print(keydata["toothSB"]);
  }

//更改齿数
  _changeToooth() {
    List<int> temp = [];
    int oldtooth;
    if (keydata["side"] == 3 || keydata["side"] == 1 || keydata["side"] == 2) {
      temp = List.from(keydata["toothSA"]);
      keydata["toothSA"] = [];
      oldtooth = temp.length;
      //  //print("object:$tooth");
      int diff = (temp[0] - temp[oldtooth - 1]) ~/ (tooth - 1);
      for (var i = 0; i < tooth; i++) {
        keydata["toothSA"].add(diff * (tooth - 1 - i) + temp[oldtooth - 1]);
      }
      keydata["toothSA"][0] = temp[0];
      keydata["toothSA"][tooth - 1] = temp[oldtooth - 1];
      keydata["toothWideA"] = [];

      for (var i = 0; i < tooth; i++) {
        keydata["toothWideA"].add(100);
      }
      if (keydata["side"] != 3) {
        keydata["toothWideB"] = [];
        for (var i = 0; i < tooth; i++) {
          keydata["toothWideB"].add(100);
        }
        keydata["toothSB"] = List.from(keydata["toothSA"]);
      }
      //print(keydata["toothSA"]);
    }
    if (keydata["side"] == 3 || keydata["side"] == 0) {
      temp = List.from(keydata["toothSB"]);
      // //print(keydata["toothSA"]);
      keydata["toothSB"] = [];
      oldtooth = temp.length;
      //  //print("object:$tooth");
      int difft = (temp[0] - temp[oldtooth - 1]) ~/ (tooth - 1);

      for (var i = 0; i < tooth; i++) {
        keydata["toothSB"].add(difft * (tooth - 1 - i) + temp[oldtooth - 1]);
      }
      keydata["toothSB"][0] = temp[0];
      keydata["toothSB"][tooth - 1] = temp[oldtooth - 1];
      keydata["toothWideB"] = [];

      for (var i = 0; i < tooth; i++) {
        keydata["toothWideB"].add(100);
      }
      if (keydata["side"] != 3) {
        keydata["toothWideA"] = [];
        for (var i = 0; i < tooth; i++) {
          keydata["toothWideA"].add(100);
        }
        keydata["toothSA"] = List.from(keydata["toothSB"]);
      }
      //print(keydata["toothSA"]);
    }

    ////print(keydata["toothSA"]);
    // _asyncTooth();
  }

  String getfixturepic(int keyfixture, int side) {
    int fixtruetype = 0;

    if (cncVersion.fixtureType == 21) {
      fixtruetype = 1;
    } else {
      fixtruetype = 0;
    }
    currentfixturepic = appData.keyImagePath +
        "/fixture/diykey/${fixtruetype}_$keyfixture" +
        "${keydata["class"]}_${side}_${keydata["locat"]}.png";
    return currentfixturepic;
  }

  Widget keyclassbt(index) {
    return TextButton(
      style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
      onPressed: () {
        keytitle = "";
        keytitle = keytitle + keyclasslist[index]["name"];
        currentkeypic = keyclasslist[index]["pic"];

        switch (index) {
          case 0:
            keydata["class"] = 0;
            keydata["side"] = 2;
            keydata["fixture"] = [5];
            break;
          case 1:
            keydata["class"] = 1;
            keydata["side"] = 0;
            keydata["fixture"] = [5];
            break;
          case 2:
            keydata["class"] = 2;
            keydata["fixture"] = [0];
            break;
          case 3:
            keydata["class"] = 5;
            keydata["fixture"] = [0];
            break;
          case 4:
            keydata["class"] = 3;
            keydata["fixture"] = [0];
            break;
          case 5:
            keydata["class"] = 4;
            keydata["fixture"] = [0];
            break;
          case 6:
            keydata["class"] = 3;
            keydata["fixture"] = [1];
            keydata["side"] = 0;
            break;
          case 7:
            keydata["class"] = 1;
            keydata["fixture"] = [1];
            keydata["side"] = 0;
            break;
          case 8:
            break;
          case 9:
            break;
        }
        diykeystep = 2;
        setState(() {});
      },
      child: myContainer(155.w, 126.h, 23.h, keyclasslist[index]["name"],
          keyclasslist[index]["pic"], EdgeInsets.zero),
    );
  }

  Widget keyclass(context, index) {
    //print("$index,${index * 2},${index * 2 + 1}");

    return Row(
      children: [
        SizedBox(
          width: 9.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2),
        ),
        const Expanded(child: SizedBox()),
        Padding(
          padding: EdgeInsets.only(right: 10.r, bottom: 45.r),
          child: keyclassbt(index * 2 + 1),
        ),
        SizedBox(
          width: 9.w,
        ),
      ],
    );
  }

  List<Widget> keylocate() {
    List<Widget> temp = [];
    int a = 0;
    int b = 0;
    if (keydata["fixture"][0] == 1) {
      if (keydata["class"] == 1) {
        a = 1;
      } else {
        b = 1;
      }
    }

    for (var i = a; i < keylocatelist.length - b; i++) {
      temp.add(
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            keytitle = keytitle + "-" + keylocatelist[i]["name"];
            switch (i) {
              case 0:
                if (keydata["class"] == 0 || keydata["class"] == 1) {
                  if (keydata["class"] == 0) {
                    keydata["picname"] = "GPT.png";
                  } else {
                    keydata["picname"] = "GPD.png";
                  }
                } else {
                  keydata["picname"] = "GLT.png";
                }
                debugPrint("对头");
                keydata["locat"] = 1;
                break;
              case 1:
                if (keydata["class"] == 0 || keydata["class"] == 1) {
                  if (keydata["class"] == 0) {
                    keydata["picname"] = "GPJ.png";
                  } else {
                    keydata["picname"] = "GPD.png";
                  }
                } else {
                  keydata["picname"] = "GLJ.png";
                }
                debugPrint("对肩");
                keydata["locat"] = 0;
                break;
              default:
            }

            diykeystep = 3;
            setState(() {});
          },
          child: Container(
            width: 340.w,
            height: 126.h,
            margin: EdgeInsets.only(
                left: 10.w, right: 10.w, top: 20.h, bottom: 20.h),
            decoration: BoxDecoration(
                color: const Color(0xff384c70),
                borderRadius: BorderRadius.circular(13)),
            child: Column(
              children: [
                SizedBox(
                  height: 23.h,
                  child: Text(
                    keylocatelist[i]["name"],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(
                    child: Container(
                  width: 340.w,
                  height: 103.h,
                  color: Colors.white,
                  child: Image.file(
                    File(keylocatelist[i]["pic"]),
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    }
    return temp;
  }

  List<Widget> keyfixture() {
    List<Widget> temp = [];
    // List<Widget> temp2 = [];
    //立铣外沟单边
    switch (keydata["class"]) {
      case 3: //立铣外沟单边
      case 5: //立铣内沟单边
        //侧夹类型
        if (keydata["fixture"][0] == 1) {
          temp.add(
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    getfixturepic(1, 0);
                    diykeystep = 4;
                  });
                },
                child: myContainer(340.w, 193.w, 23.w, "侧夹",
                    getfixturepic(1, 0), EdgeInsets.only(top: 10.w))),
          );
        } else {
          for (var i = 0; i < keyfixturelist3.length; i++) {
            temp.add(
              TextButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                  onPressed: () {
                    setState(() {
                      switch (i) {
                        case 0:
                          keydata["side"] = 0;
                          keydata["fixture"] = [3];
                          getfixturepic(0 > 1 ? 5 : 0, 0 % 2);
                          break;
                        case 1:
                          keydata["side"] = 1;
                          keydata["fixture"] = [4];
                          getfixturepic(1 > 1 ? 5 : 0, 1 % 2);
                          break;
                        case 2: //薄
                          keydata["side"] = 0;
                          keydata["fixture"] = [5];
                          getfixturepic(2 > 1 ? 5 : 0, 2 % 2);
                          break;

                        case 3: //薄
                          keydata["side"] = 1;
                          keydata["fixture"] = [5];
                          getfixturepic(3 > 1 ? 5 : 0, 3 % 2);
                          break;
                      }

                      diykeystep = 4;
                      //state = 0;
                    });
                  },
                  child: myContainer(
                      340.w,
                      193.w,
                      23.w,
                      keyfixturelist3[i],
                      getfixturepic(i > 1 ? 5 : 0, i % 2),
                      EdgeInsets.only(top: 10.w))),
            );
          }
        }
        break;
      case 0:
      case 1:
        temp.add(
          TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.zero)),
              onPressed: () {
                getfixturepic(
                    keydata["fixture"][0], keydata["class"] == 0 ? 2 : 0);
                setState(() {
                  diykeystep = 4;
                });
              },
              child: myContainer(
                  340.w,
                  193.w,
                  23.w,
                  keydata["fixture"][0] == 1 ? "侧夹" : keyfixturelis5[0],
                  getfixturepic(
                      keydata["fixture"][0], keydata["class"] == 0 ? 2 : 0),
                  EdgeInsets.only(top: 10.w))),
        );
        break;
      default:
        for (var i = 0; i < keyfixturelist.length; i++) {
          temp.add(
            TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero)),
                onPressed: () {
                  setState(() {
                    keydata["side"] = 3;
                    if (i == 0) {
                      keydata["fixture"] = [0];
                    } else {
                      keydata["fixture"] = [5];
                    }
                    getfixturepic(i == 0 ? 0 : 5, 2);
                    diykeystep = 4;
                    //state = 0;
                  });
                },
                child: myContainer(
                    340.w,
                    193.w,
                    23.w,
                    keyfixturelist[i],
                    getfixturepic(i == 0 ? 0 : 5, 2),
                    EdgeInsets.only(top: 10.w))),
          );
        }
        break;
    }

    return temp;
  }

//获取有效边
  String getKeySide() {
    switch (keydata["side"]) {
      case 0:
        return "上";
      case 1:
        return "下";
      case 2:
      case 3:
        return "上下";
      default:
        return "未知";
    }
  }

//获取定位方式
  String getKeylocat() {
    switch (keydata["locat"]) {
      case 0:
        return "肩";
      case 1:
        return "头";
      default:
        return "未知";
    }
  }

  String getKeyClass() {
    switch (keydata["class"]) {
      case 0:
        return "平铣双边";
      case 1:
        return "平铣单边";
      case 2:
        return "立铣内沟双边";
      case 3:
        return "立铣外沟单边";
      case 4:
        return "立铣外沟双边";
      case 5:
        return "立铣内沟单边";
      default:
        return "未知类型";
    }
  }

  List<Widget> toothList() {
    List<Widget> temp = [];
    // temp.add(TextButton(onPressed: () {}, child: Text("增加")));
    if (keydata["side"] == 3 || keydata["side"] == 1 || keydata["side"] == 2) {
      for (var i = 0; i < keydata["toothSA"].length; i++) {
        temp.add(
          SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("A${i + 1}"),
                Text("${keydata["toothSA"][i]}"),
                advancedBt
                    ? TextButton(
                        onPressed: () {
                          keydata["toothSA"][i]++;
                          setState(() {});
                        },
                        onLongPress: () {
                          keydata["toothSA"][i] = keydata["toothSA"][i] + 5;
                          setState(() {});
                        },
                        child: const Text("+"))
                    : const SizedBox(), //增加值
                advancedBt
                    ? TextButton(
                        onPressed: () {
                          keydata["toothSA"][i]--;
                          setState(() {});
                        },
                        onLongPress: () {
                          keydata["toothSA"][i] = keydata["toothSA"][i] - 5;
                          setState(() {});
                        },
                        child: const Text("-"))
                    : const SizedBox(), //减少值
              ],
            ),
          ),
        );
      }
    }
    if (keydata["side"] == 3 || keydata["side"] == 0) {
      for (var i = 0; i < keydata["toothSB"].length; i++) {
        temp.add(
          SizedBox(
            height: 30.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("B${i + 1}"),
                Text("${keydata["toothSB"][i]}"),
                advancedBt
                    ? TextButton(
                        onPressed: () {
                          keydata["toothSB"][i]++;
                          setState(() {});
                        },
                        onLongPress: () {
                          keydata["toothSB"][i] = keydata["toothSB"][i] + 5;
                          setState(() {});
                        },
                        child: const Text("+"))
                    : const SizedBox(), //增加值
                advancedBt
                    ? TextButton(
                        onPressed: () {
                          keydata["toothSB"][i]--;
                          setState(() {});
                        },
                        onLongPress: () {
                          keydata["toothSB"][i] = keydata["toothSB"][i] - 5;
                          setState(() {});
                        },
                        child: const Text("-"))
                    : const SizedBox(), //减少值
              ],
            ),
          ),
        );
      }
    }
    return temp;
  }

  Widget _toothChange() {
    return ListView(children: toothList());
  }

  List<Widget> ahNumList() {
    List<Widget> temp = [];
    // temp.add(TextButton(onPressed: () {}, child: Text("增加")));

    for (var i = 0; i < keydata["toothDepth"].length; i++) {
      temp.add(
        SizedBox(
          height: 30.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                  width: 30.w, child: Text("${keydata["toothDepthName"][i]}")),
              SizedBox(width: 30.w, child: Text("${keydata["toothDepth"][i]}")),
              advancedBt
                  ? SizedBox(
                      width: 30.w,
                      child: TextButton(
                          onPressed: () {
                            keydata["toothDepth"][i]++;
                            baseKey.toothDepth[i] = keydata["toothDepth"][i];
                            setState(() {});
                          },
                          onLongPress: () {
                            keydata["toothDepth"][i] =
                                keydata["toothDepth"][i] + 5;
                            baseKey.toothDepth[i] = keydata["toothDepth"][i];
                            setState(() {});
                          },
                          child: const Text("+")))
                  : SizedBox(
                      width: 30.w,
                    ), //增加值
              advancedBt
                  ? SizedBox(
                      width: 30.w,
                      child: TextButton(
                          onPressed: () {
                            keydata["toothDepth"][i]--;
                            baseKey.toothDepth[i] = keydata["toothDepth"][i];
                            setState(() {});
                          },
                          onLongPress: () {
                            keydata["toothDepth"][i] =
                                keydata["toothDepth"][i] - 5;
                            baseKey.toothDepth[i] = keydata["toothDepth"][i];
                            setState(() {});
                          },
                          child: const Text("-")))
                  : SizedBox(
                      width: 30.w,
                    ), //减少值
            ],
          ),
        ),
      );
    }
    return temp;
  }

  Widget _toothControl() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0))),
                  backgroundColor: MaterialStateProperty.all(
                      buttonState[0] ? Colors.red : Colors.blue)),
              child: const Text("0.01mm"),
              onPressed: () {
                gesture = false;
                diff = 1;
                buttonState[0] = true;
                buttonState[1] = false;
                buttonState[2] = false;
                setState(() {});
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0))),
                  backgroundColor: MaterialStateProperty.all(
                      buttonState[1] ? Colors.red : Colors.blue)),
              child: const Text("0.1mm"),
              onPressed: () {
                gesture = false;
                diff = 10;
                buttonState[0] = false;
                buttonState[1] = true;
                buttonState[2] = false;
                setState(() {});
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13.0))),
                  backgroundColor: MaterialStateProperty.all(
                      buttonState[2] ? Colors.red : Colors.blue)),
              child: const Text("0.2mm"),
              onPressed: () {
                diff = 20;
                gesture = false;
                buttonState[0] = false;
                buttonState[1] = false;
                buttonState[2] = true;
                setState(() {});
              },
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        SizedBox(
          width: 160.w,
          height: 30.h,
          child: Row(
            children: [
              SizedBox(
                width: 30.w,
                child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      gesture = false;
                      if (keydata["class"] == 2) {
                        if (keydata["locat"] == 1) {
                          if (baseKey.seleside == 1) {
                            keydata["toothSB"][baseKey.seleindex - 1] += diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSA"][baseKey.seleindex - 1] += diff;
                          }
                        } else {
                          if (baseKey.seleside == 1) {
                            keydata["toothSB"][baseKey.seleindex - 1] -= diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSA"][baseKey.seleindex - 1] -= diff;
                          }
                        }
                      } else {
                        if (keydata["locat"] == 1) {
                          if (baseKey.seleside == 1) {
                            keydata["toothSA"][baseKey.seleindex - 1] += diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSB"][baseKey.seleindex - 1] += diff;
                          }
                        } else {
                          if (baseKey.seleside == 1) {
                            keydata["toothSA"][baseKey.seleindex - 1] -= diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSB"][baseKey.seleindex - 1] -= diff;
                          }
                        }
                      }
                      // //print(diff);
                      ////print(keydata["toothSA"]);

                      _changeToooth();
                      setState(() {});
                    },
                    child: Image.asset("image/tank/Icon_roundleft.png")),
              ),
              const Expanded(child: SizedBox()),
              SizedBox(
                width: 30.w,
                child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      gesture = false;
                      if (keydata["class"] == 2) {
                        if (keydata["locat"] == 1) {
                          if (baseKey.seleside == 1) {
                            keydata["toothSB"][baseKey.seleindex - 1] =
                                keydata["toothSB"][baseKey.seleindex - 1] -
                                    diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSA"][baseKey.seleindex - 1] =
                                keydata["toothSA"][baseKey.seleindex - 1] -
                                    diff;
                          }
                        } else {
                          if (baseKey.seleside == 1) {
                            keydata["toothSB"][baseKey.seleindex - 1] =
                                keydata["toothSB"][baseKey.seleindex - 1] +
                                    diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSA"][baseKey.seleindex - 1] =
                                keydata["toothSA"][baseKey.seleindex - 1] +
                                    diff;
                          }
                        }
                      } else {
                        if (keydata["locat"] == 1) {
                          if (baseKey.seleside == 1) {
                            keydata["toothSA"][baseKey.seleindex - 1] =
                                keydata["toothSA"][baseKey.seleindex - 1] -
                                    diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSB"][baseKey.seleindex - 1] =
                                keydata["toothSB"][baseKey.seleindex - 1] -
                                    diff;
                          }
                        } else {
                          if (baseKey.seleside == 1) {
                            keydata["toothSA"][baseKey.seleindex - 1] =
                                keydata["toothSA"][baseKey.seleindex - 1] +
                                    diff;
                          }
                          if (baseKey.seleside == 0) {
                            keydata["toothSB"][baseKey.seleindex - 1] =
                                keydata["toothSB"][baseKey.seleindex - 1] +
                                    diff;
                          }
                        }
                      }
                      //print(diff);
                      //print(keydata["toothSA"]);
                      //print(keydata["toothSB"]);
                      _changeToooth();
                      setState(() {});
                    },
                    child: Image.asset("image/tank/Icon_roundright.png")),
              ),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
        SizedBox(
          width: 160.w,
          height: 30.h,
          child: Row(
            children: [
              SizedBox(
                  width: 30.w,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        if (tooth > 2) {
                          tooth--;
                        }
                        _changeToooth();
                        setState(() {});
                      },
                      child: Image.asset("image/tank/Icon_rounddec.png"))),
              Expanded(
                child: Text(
                  "$tooth齿",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                  width: 30.w,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        if (tooth < 12) {
                          tooth++;
                        }
                        _changeToooth();
                        setState(() {});
                      },
                      child: Image.asset("image/tank/Icon_roundadd.png"))),
            ],
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _ahNumChange() {
    return Column(
      children: [
        advancedBt
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("齿深数修改:"),
                  ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(50.r, 25.r)),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff384c70),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      if (keydata["toothDepthName"].length > 2) {
                        keydata["toothDepthName"].removeLast();
                        keydata["toothDepth"].removeLast();
                        baseKey.toothDepthName.removeLast();
                        baseKey.toothDepth.removeLast();
                        baseKey.asynctooth();
                      } else {
                        Fluttertoast.showToast(msg: "齿深数最小为2");
                      }
                      setState(() {});
                    },
                    child: const Text("-"),
                  ),
                  Text("${keydata["toothDepthName"].length}"),
                  ElevatedButton(
                    style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(Size(50.r, 25.r)),
                        backgroundColor: MaterialStateProperty.all(
                          const Color(0xff384c70),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.zero)),
                    onPressed: () {
                      int length = keydata["toothDepthName"].length;
                      keydata["toothDepthName"].add(((length + 1).toString()));
                      baseKey.toothDepthName.add(((length + 1).toString()));
                      if (length > 1) {
                        keydata["toothDepth"].add(keydata["toothDepth"]
                                [length - 1] -
                            (keydata["toothDepth"][length - 2] -
                                keydata["toothDepth"][length - 1]));
                        baseKey.toothDepth.add(keydata["toothDepth"]
                                [length - 1] -
                            (keydata["toothDepth"][length - 2] -
                                keydata["toothDepth"][length - 1]));
                      } else {
                        keydata["toothDepth"]
                            .add(keydata["toothDepth"][length - 1] - 20);
                        baseKey.toothDepth
                            .add(keydata["toothDepth"][length - 1] - 20);
                      }
                      baseKey.asynctooth();
                      setState(() {});
                    },
                    child: const Text("+"),
                  ),
                ],
              )
            : Container(),
        Expanded(child: ListView(children: ahNumList()))
      ],
    );
  }

  ///齿位控制栏标题
  List<Widget> _tabBarList() {
    List<Widget> temp = [];
    if (diykeystep == 5) {
      temp.add(
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            currentTab = 0;
            setState(() {});
          },
          child: Container(
            width: 113.w,
            height: 36.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: currentTab == 0
                  ? const Color(0xff384c70)
                  : const Color(0xffdde1ea),
            ),
            child: Center(
              child: Text(
                '齿位参数',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: currentTab == 0 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
      temp.add(
        TextButton(
          style:
              ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
          onPressed: () {
            currentTab = 1;
            setState(() {});
          },
          child: Container(
            width: 113.w,
            height: 36.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: currentTab == 1
                  ? const Color(0xff384c70)
                  : const Color(0xffdde1ea),
            ),
            child: Center(
              child: Text(
                '齿位控制',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: currentTab == 1 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (diykeystep == 6) {
      temp.add(TextButton(
        style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.zero)),
        onPressed: () {},
        child: Container(
          width: 113.w,
          height: 36.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xff384c70)),
          child: Center(
            child: Text(
              '齿深参数',
              style: TextStyle(fontSize: 13.sp, color: Colors.white),
            ),
          ),
        ),
      ));
    }
    return temp;
  }

  ///齿位控制栏内容
  List<Widget> _tabBarViewList() {
    List<Widget> temp = [];
    if (diykeystep == 5) {
      temp.add(_toothChange());
      temp.add(_toothControl());
    }
    if (diykeystep == 6) {
      temp.add(_ahNumChange());
    }
    return temp;
  }

  Widget _toolsbar() {
    return Column(
      children: [
        Container(
            width: double.maxFinite,
            height: 36.h,
            decoration: const BoxDecoration(color: Color(0xffdde1ea)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _tabBarList(),
            )),
        Expanded(
          child: Swiper(
            itemBuilder: (context, index) {
              // switch (currentTab) {
              //   case 0:
              //     return _tabBarViewList()[0];
              //   case 1:
              //     return _tabBarViewList()[1];
              //   default:
              //     return _tabBarViewList()[0];
              return _tabBarViewList()[currentTab];
            },
            index: currentTab,
            itemCount: _tabBarViewList().length,
            // pagination: SwiperPagination(
            //   alignment: Alignment.bottomCenter,
            //   margin: EdgeInsets.zero,
            //   builder: DotSwiperPaginationBuilder(
            //       color: Colors.white,
            //       activeColor: Colors.blue,
            //       size: 5.r,
            //       activeSize: 6.r),
            // ),
            onIndexChanged: (index) {
              // print(index);
              currentTab = index;
              setState(() {});
            },
            // control: new SwiperControl(),
          ),
        )
      ],
    );
  }

  // ///齿位控制栏
  // Widget _toothtoolsbar() {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: const Color(0xffdde1ea),
  //       toolbarHeight: 36.h,
  //       centerTitle: true,
  //       automaticallyImplyLeading: false,
  //       title: TabBar(
  //           controller: TabController(initialIndex: 0, length: 2, vsync: this),
  //           indicatorSize: TabBarIndicatorSize.label,
  //           labelPadding: EdgeInsets.zero,
  //           tabs: _toothtabBarList()),
  //     ),

  //     //切换tab的view
  //     body: TabBarView(
  //       controller: TabController(initialIndex: 0, length: 2, vsync: this),
  //       children: _toothtabBarViewList(),
  //     ),
  //   );
  // }

  ///齿深控制栏标题
  List<Widget> _ahnumtabBarList() {
    List<Widget> temp = [];

    temp.add(
      Tab(
        child: Container(
          width: 113.w,
          height: 36.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xff384c70)),
          child: Center(
            child: Text(
              '齿深参数',
              style: TextStyle(fontSize: 13.sp, color: Colors.white),
            ),
          ),
        ),
      ),
    );

    return temp;
  }

  ///齿深控制栏内容
  List<Widget> _ahnumtabBarViewList() {
    List<Widget> temp = [];

    temp.add(_ahNumChange());
    // temp.add(_ahNumControl());

    return temp;
  }

  ///齿深控制栏
  Widget _ahnumtoolsbar() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffdde1ea),
        toolbarHeight: 36.h,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: TabBar(
            controller: TabController(initialIndex: 0, length: 1, vsync: this),
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.zero,
            tabs: _ahnumtabBarList()),
      ),

      //切换tab的view
      body: TabBarView(
        controller: TabController(initialIndex: 0, length: 1, vsync: this),
        children: _ahnumtabBarViewList(),
      ),
    );
  }

  List<Widget> showtoothSB() {
    List<Widget> temp = [];
    temp.add(const Text("上："));
    for (var i = 0; i < tooth; i++) {
      temp.add(Text("${keydata["toothSB"][i]}"));
    }

    return temp;
  }

  List<Widget> showtoothSA() {
    List<Widget> temp = [];
    temp.add(const Text("下："));
    for (var i = 0; i < tooth; i++) {
      temp.add(Text("${keydata["toothSA"][i]}"));
    }
    return temp;
  }

  Future<void> addDiyKey() async {
    var data = {
      "userid": appData.id,
      "timer": DateTime.now().toString().substring(0, 19),
      "data": json.encode(keydata),
      "state": 0,
      "shared": "false",
      "use": "false",
    };
    try {
      var result = await Api.upUserKey(data);

      if (result["state"]) {
        data["state"] = 1;

        await appData.insertUserKey(data);
      } else {
        await appData.insertUserKey(data);
      }
    } catch (e) {
      await appData.insertUserKey(data);
    }
  }

  String getStep8Pic() {
    return appData.keyImagePath + "/key/" + keydata["picname"];
  }

  List<Widget> headPointList() {
    List<Widget> temp = [];
    int pointx1 = 0;
    int pointy1 = 0;
    int pointx2 = 0;
    int pointy2 = 0;
    if (seleside == 0) {
      pointx1 = keydata["headAx"];
      pointy1 = keydata["headAy"];
      pointx2 = keydata["headBx"];
      pointy2 = keydata["headBy"];
    } else {
      pointx1 = keydata["headCx"];
      pointy1 = keydata["headCy"];
      pointx2 = keydata["headDx"];
      pointy2 = keydata["headDy"];
    }
    temp.add(Container(
      width: 320.w,
      height: 125.h,
      margin: EdgeInsets.only(left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
      child: Center(child: Image.file(File(getStep8Pic()))),
      color: Colors.white,
    ));

    temp.add(Row(
      children: [
        const Expanded(
          child: const SizedBox(),
          flex: 1,
        ),
        const Text("AX:"),
        SizedBox(
            width: 100.r,
            child: TextField(
              controller: TextEditingController(text: pointx1.toString()),
              showCursor: true,
              enableInteractiveSelection: false,
              keyboardType: TextInputType.number,
              inputFormatters: [
                //  LengthLimitingTextInputFormatter(16),
                //  WhitelistingTextInputFormatter(accountRegExp),
                FilteringTextInputFormatter(onlynum, allow: true),
              ],
              onChanged: (value) {
                if (value != "") {
                  if (seleside == 0) {
                    keydata["headAx"] = int.parse(value);
                  } else {
                    keydata["headCx"] = int.parse(value);
                  }
                } else {
                  if (seleside == 0) {
                    keydata["headAx"] = 0;
                  } else {
                    keydata["headCX"] = 0;
                  }
                }
              },
            )),
        const Expanded(
          child: SizedBox(),
          flex: 2,
        ),
        const Text("AY:"),
        SizedBox(
          width: 100.r,
          child: TextField(
            controller: TextEditingController(text: pointy1.toString()),
            showCursor: true,
            enableInteractiveSelection: false,
            keyboardType: TextInputType.number,
            inputFormatters: [
              //  LengthLimitingTextInputFormatter(16),
              //  WhitelistingTextInputFormatter(accountRegExp),
              FilteringTextInputFormatter(onlynum, allow: true),
            ],
            onChanged: (value) {
              if (value != "") {
                if (seleside == 0) {
                  keydata["headAy"] = int.parse(value);
                } else {
                  keydata["headCy"] = int.parse(value);
                }
              } else {
                if (seleside == 0) {
                  keydata["headAy"] = 0;
                } else {
                  keydata["headCy"] = 0;
                }
              }
            },
          ),
        ),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
      ],
    ));
    if (keydata["class"] != 0 && keydata["class"] != 1) {
      temp.add(Row(
        children: [
          const Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          const Text("BX:"),
          SizedBox(
              width: 100.r,
              child: TextField(
                controller: TextEditingController(text: pointx2.toString()),
                showCursor: true,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  //  LengthLimitingTextInputFormatter(16),
                  //  WhitelistingTextInputFormatter(accountRegExp),
                  FilteringTextInputFormatter(onlynum, allow: true),
                ],
                onChanged: (value) {
                  if (value != "") {
                    if (seleside == 0) {
                      keydata["headBx"] = int.parse(value);
                    } else {
                      keydata["headDx"] = int.parse(value);
                    }
                  } else {
                    if (seleside == 0) {
                      keydata["headBx"] = 0;
                    } else {
                      keydata["headDX"] = 0;
                    }
                  }
                },
              )),

          const Expanded(
            child: SizedBox(),
            flex: 2,
          ),
          const Text("BY:"),
          SizedBox(
              width: 100.r,
              child: TextField(
                controller: TextEditingController(text: pointy2.toString()),
                showCursor: true,
                enableInteractiveSelection: false,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  //  LengthLimitingTextInputFormatter(16),
                  //  WhitelistingTextInputFormatter(accountRegExp),
                  FilteringTextInputFormatter(onlynum, allow: true),
                ],
                onChanged: (value) {
                  if (value != "") {
                    if (seleside == 0) {
                      keydata["headBy"] = int.parse(value);
                    } else {
                      keydata["headDy"] = int.parse(value);
                    }
                  } else {
                    if (seleside == 0) {
                      keydata["headBy"] = 0;
                    } else {
                      keydata["headDy"] = 0;
                    }
                  }
                },
              )),
          const Expanded(
            child: SizedBox(),
            flex: 1,
          ),
          // Text("一般Y为0即可"),
        ],
      ));
    }

    return temp;
  }

//根据state决定显示的内容
  Widget statewidget(context) {
    switch (diykeystep) {
      case 1: //选择钥匙类型
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep /8)钥匙类型",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return keyclass(context, index);
                  }),
            ),
          ],
        );
      case 2: //定位方式
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)定位方式",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: keylocate(),
              ),
            ),
          ],
        );
      case 3: //选择使用定位方式
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)夹具类型",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: keyfixture(),
              ),
            ),
          ],
        );

      case 4: //识别页面
        return Column(
          children: [
            Container(
              width: double.maxFinite,
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "$diykeystep/8识别钥匙",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                width: 340.w,
                child: Image.file(File(currentkeypic)),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(13.0),
                        bottomRight: Radius.circular(13.0))),
                width: 340.w,
                child: Center(
                  child: Image.file(
                    File(currentfixturepic),
                  ),
                ),
              ),
              flex: 2,
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: const Text("开始识别"),
                      onPressed: () {
                        if (getCncBtState()) {
                          previewstate = false;
                          //print(keydata);
                          sendCmd([cncBtSmd.openClamp, 0, 0, 0]);
                          baseKey.initdata(keydata);
                          baseKey.fixture = 5;

                          Navigator.pushNamed(context, '/openclamp',
                              arguments: {
                                "keydata": keydata,
                                "state": false,
                              }).then((value) {
                            if (value == true) {
                              List<int> temp = [];
                              temp.add(cncBtSmd.copyKeyRead);
                              temp.add(0);
                              temp.addAll(baseKey.creatkeydata(0));
                              sendCmd(temp);
                              Navigator.pushNamed(context, '/cncworking')
                                  .then((value) {
                                if (value == 1) {
                                  debugPrint("复制完成");
                                  pd.show(max: 100, msg: "获取数据中..\r\n请稍后..");
                                  currentnum = 0;

                                  sAhNum = [];
                                  sBhNum = [];
                                  sendCmd([0x9f, 10, 0]);
                                }
                              });
                            }
                          });
                        } else {
                          _autoConnectBT();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        if (previewstate) {
                          diykeystep = 5;
                          setState(() {});
                        } else {
                          showDialog(
                              context: context,
                              builder: (c) {
                                return const MyTextDialog("请先识别");
                              });
                        }
                      },
                      child: const Text("下一步"),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      case 5: // 齿位调整页面
        keytitle = getKeyClass() + "-" + getKeylocat() + "-" + getKeySide();
        return Column(
          children: [
            Container(
                height: 40.h,
                color: const Color(0xffdde1ea),
                child: Row(
                  children: [
                    Text(
                      "$diykeystep/8调整齿位",
                      style: TextStyle(
                          fontSize: 17.sp, color: const Color(0xff384c70)),
                    ),
                    const Expanded(child: SizedBox()),
                    OutlinedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                        ),
                        child: Text(
                          advancedBt ? "高级模式" : "普通模式",
                          style: const TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          advancedBt = !advancedBt;
                          setState(() {});
                        }),
                  ],
                )),
            Expanded(
                child: Stack(children: [
              Align(
                child: GestureDetector(
                  onPanDown: (details) {
                    ////print(ahNum);
                    ////print(details.localPosition);
                    gesture = true;
                    touchoffect = details.localPosition;
                    _changeToooth();
                    setState(() {});
                  },
                  onPanUpdate: (details) {
                    gesture = true;
                    touchoffect = details.localPosition;
                    _changeToooth();
                    setState(() {});
                  },
                  child: CustomPaint(
                    size: const Size(double.maxFinite, double.maxFinite),
                    painter: DiyKeyPreview(
                      keydata,
                      sAhNum,
                      sBhNum,
                      //ahNum,
                      //bhNum,
                      //ahNums,
                      //bhNums,
                      touchoffect,
                      gesture,
                      true,
                    ),
                  ),
                ),
                alignment: Alignment.center,
              ),
            ])),
            Expanded(
              child: _toolsbar(),
            ),
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: const Text("上一步"),
                      onPressed: () {
                        diykeystep = 4;

                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        baseKey.initdata(keydata);
                        baseKey.fixture = 5;
                        Navigator.pushNamed(context, '/openclamp', arguments: {
                          "keydata": keydata,
                          "state": false,
                        }).then((value) {
                          if (value == true) {
                            List<int> temp = [];
                            ////print(keydata);
                            temp.add(cncBtSmd.readKey);
                            temp.add(0);
                            temp.addAll(baseKey.creatkeydata(0));
                            ////print(temp);
                            sendCmd(temp);
                            Navigator.pushNamed(context, '/cncworking')
                                .then((value) {
                              calculationKeyToothH(); //计算齿深 以及齿号
                              debugPrint("读码完成");
                              diykeystep = 6;
                              currentTab = 0;
                              setState(() {});
                            });
                          }
                        });
                      },
                      child: const Text("下一步"),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      case 6: //齿深调整页面
        return Column(
          children: [
            Container(
                height: 40.h,
                color: const Color(0xffdde1ea),
                child: Row(
                  children: [
                    Text(
                      "$diykeystep/8齿深调整",
                      style: TextStyle(
                          fontSize: 17.sp, color: const Color(0xff384c70)),
                    ),
                    const Expanded(child: SizedBox()),
                    OutlinedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                        ),
                        child: Text(
                          advancedBt ? "高级模式" : "普通模式",
                          style: const TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          advancedBt = !advancedBt;
                          setState(() {});
                        }),
                  ],
                )),
            Expanded(
                child: Stack(children: [
              Align(
                child: CustomPaint(
                  size: const Size(double.maxFinite, double.maxFinite),
                  painter: FlutterPainter(
                    cutsindex,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ])),
            Expanded(child: _ahnumtoolsbar()),
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: const Text("上一步"),
                      onPressed: () {
                        //print("上一步");
                        diykeystep = 5;

                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      onPressed: () {
                        diykeystep = 7;

                        setState(() {});
                      },
                      child: const Text("下一步"),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      case 7: //确认数据页面
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)确认数据",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    width: 320.w,
                    height: 125.h,
                    margin: EdgeInsets.only(
                        left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                    child: Center(
                      child: Image.file(File(
                          appData.keyImagePath + "/key/" + keydata["picname"])),
                    ),
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      const Text("钥匙宽度:"),
                      TextButton(
                          onPressed: () {}, child: Text("${keydata["wide"]}"))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      const Text("钥匙厚度:"),
                      TextButton(
                          onPressed: () {},
                          child: Text("${keydata["thickness"]}"))
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 21.w,
                      ),
                      const Text("切削深度:"),
                      TextButton(
                          onPressed: () {}, child: Text("${keydata["depth"]}"))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 48.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150.w,
                    height: 40.h,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color(0xff384c70)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13.0))),
                          // backgroundColor:
                          //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero)),
                      child: const Text("上一步"),
                      onPressed: () {
                        diykeystep = 6;
                        setState(() {});
                      },
                    ),
                  ),
                  previewstate
                      ? SizedBox(
                          width: 150.w,
                          height: 40.h,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xff384c70)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(13.0))),
                                // backgroundColor:
                                //     MaterialStateProperty.all(const Color(0xffeeeeee)),
                                padding:
                                    MaterialStateProperty.all(EdgeInsets.zero)),
                            onPressed: () {
                              diykeystep = 8;

                              setState(() {});
                            },
                            child: const Text("下一步"),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        );
      case 8: //头部处理
        return Column(children: [
          Container(
            height: 40.h,
            color: const Color(0xffdde1ea),
            child: Center(
              child: Text(
                "($diykeystep/9)头部处理",
                style:
                    TextStyle(fontSize: 17.sp, color: const Color(0xff384c70)),
              ),
            ),
          ),
          keydata["class"] != 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                seleside == 0
                                    ? Colors.red
                                    : const Color(0xff384c70))),
                        onPressed: () {
                          seleside = 0;
                          setState(() {});
                        },
                        child: const Text("A")),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                seleside == 1
                                    ? Colors.red
                                    : const Color(0xff384c70))),
                        onPressed: () {
                          seleside = 1;
                          setState(() {});
                        },
                        child: const Text("B")),
                  ],
                )
              : const SizedBox(),
          Expanded(
              child: ListView(
            children: headPointList(),
          )),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                margin: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                height: 40.h,
                width: 150.w,
                decoration: BoxDecoration(
                    color: const Color(0xff384c70),
                    borderRadius: BorderRadius.circular(13.0)),
                child: TextButton(
                  child: Text(
                    S.of(context).nextstep,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    diykeystep = 9;
                    setState(() {});
                  },
                ))
          ])
        ]);
      case 9: //输入品牌数据
        return Column(
          children: [
            Container(
              height: 40.h,
              color: const Color(0xffdde1ea),
              child: Center(
                child: Text(
                  "($diykeystep/8)钥匙名称",
                  style: TextStyle(
                      fontSize: 17.sp, color: const Color(0xff384c70)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(children: [
                Container(
                  width: 320.w,
                  height: 125.h,
                  margin: EdgeInsets.only(
                      left: 21.w, right: 21.w, top: 15.h, bottom: 15.h),
                  child: Center(child: Image.file(File(getStep8Pic()))),
                  color: Colors.white,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).keyname),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //  keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(hintText: "必填"),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            //WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            keydata["cnname"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).modelbrand),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //   keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(hintText: "必填"),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            //WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["carname"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).brandcar),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          //  keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            keydata["carmodel"] = value;
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      const Text("钥匙胚号"),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          // keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["keynumbet"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40.h,
                  color: const Color(0xffdde1ea),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 22.w,
                      ),
                      Text(S.of(context).note),
                      SizedBox(
                        width: 22.w,
                      ),
                      Expanded(
                        child: TextField(
                          // keyboardType: TextInputType.phone,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(16),
                            //Pattern x
                            //FilteringTextInputFormatter.allow(RegExp(r'([1-9][0-9]{0,3})')),
                            // WhitelistingTextInputFormatter(accountRegExp),
                          ],
                          onChanged: (value) {
                            setState(() {
                              keydata["chnote"] = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 22.w,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin:
                      EdgeInsets.only(left: 10.w, right: 10.w, bottom: 10.h),
                  height: 40.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                      color: const Color(0xff384c70),
                      borderRadius: BorderRadius.circular(13.0)),
                  child: TextButton(
                    child: const Text(
                      "完成",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (keydata["carname"] == "") {
                        Fluttertoast.showToast(msg: "请输入品牌名称");
                      } else if (keydata["cnname"] == "") {
                        Fluttertoast.showToast(msg: "请输入钥匙名称");
                      } else {
                        // if (keydata["side"] != 3) {
                        //   if (keydata["locat"] == 1) {
                        //     keydata["toothSA"] =
                        //         List.from(keydata["toothSA"].reversed);
                        //   }
                        //   keydata["toothSB"] = List.from(keydata["toothSA"]);
                        //   keydata["toothWideB"] =
                        //       List.from(keydata["toothWideA"]);
                        // }
                        // print(keydata["toothSB"]);
                        // print(keydata["toothWideB"]);

                        await addDiyKey();
                        showDialog(
                            context: context,
                            builder: (c) {
                              return const MyTextDialog("是否立即使用?");
                            }).then((value) {
                          if (value) {
                            ////print(keydata);
                            baseKey.initdata(keydata);
                            Navigator.pushNamed(context, '/openclamp',
                                arguments: {"keydata": keydata, "state": 0});
                            //  Navigator.pushNamed(context,);
                          } else {
                            Navigator.pop(context);
                          }
                        });
                      }
                    },
                  ))
            ])
          ],
        );
      default:
        return const SizedBox(
          child: Center(
            child: Text("状态丢失"),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (diykeystep == 1) {
          return true;
        } else {
          diykeystep--;
          switch (keydata["class"]) {
            case 0:
            case 2:
            case 4:
            case 1:
              if (diykeystep == 2) {
                diykeystep = 1;
              }
              break;
          }
          setState(() {});
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 32.r,
          elevation: 0.0,
          title: SizedBox(
            width: 97.r,
            height: 18.r,
            child: Image.asset(
              "image/tank/Icon_tankbar.png",
              // fit: BoxFit.cover,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              if (diykeystep == 1) {
                Navigator.pop(context);
              } else {
                diykeystep--;
                switch (keydata["class"]) {
                  case 0:
                  case 2:
                  case 4:
                  case 1:
                    if (diykeystep == 2) {
                      diykeystep = 1;
                    }
                    break;
                }
                setState(() {});
              }
            },
            color: Colors.black,
            icon: SizedBox(
                width: 24.r,
                height: 20.r,
                child: Image.asset("image/share/Icon_back.png",
                    fit: BoxFit.cover)),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                  return const Tips4Page();
                }), (route) => false);
              },
              color: Colors.black,
              icon: SizedBox(
                  width: 24.r,
                  height: 20.r,
                  child: Image.asset("image/share/Icon_home.png",
                      fit: BoxFit.cover)),
            )
          ],
        ),
        body: statewidget(context),
      ),
    );
  }
}

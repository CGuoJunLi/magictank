//钥匙 钥匙数据生成 list int
//根据钥匙数据创建 数据包

import 'package:flutter/foundation.dart';
import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/convers/convers.dart';

BaseKey baseKey = BaseKey();

class BaseKey {
  ///钥匙读码状态
  bool readstate = false;

  ///更换铣刀状态false
  bool needChangeXD = false;

  ///手动更更换了铣刀
  bool manualChangeXD = false;

  ///是否隐藏数据
  bool hide = false;
  bool _smartkey = false; //智能卡属性
  ///非导电属性 true 非导电类
  bool _nonconductive = false;
  List<String> axhNums = []; //钥匙A轴的齿号  用于钥匙切换
  List<String> bxhNums = []; //钥匙B轴的齿号
  List<String> cxhNums = []; //钥匙C轴的齿号
  Map cKeyData = {}; //临时记录钥匙数据 非导电夹钥匙提示currentKeyData 当前钥匙数据
  List<int> charkeydata = []; //需要发送的钥匙数据
  int sideAtooth = 0;
  int sideBtooth = 0;
  int ver = 273;

  ///钥匙总类
  ///!SB0 平齿双边      TOY43
  ///!SB1 平齿单边
  ///!SB2 立铣内沟双边  TOY48 (两边切两边)
  ///!SB3 立铣内沟单边
  ///!SB4 立铣外沟双边
  ///!SB5 立铣内沟单边-2 HU66 (单边)
  ///!SB7 TIBBE
  ///!SB9 LDV
  int keyClass = 0;

  ///对头方式 {1:钥匙头尖部 ,0: 钥匙肩}
  int locat = 0;

  ///夹取方式{正夹：1，反夹：0}
  int dir = 0;

  ///{0:A面, 1:B面, 2:AB面, 3:A面,B面}   sb0:2 sb1:0,1 sb2:3 sb3: 0,1 sb4:3 sb5:0,1 sb7:2 sb9:2
  int side = 0;
  //钥匙处理的夹具类型
  int fixture = 0;

  /// 钥匙宽度
  int wide = 0;

  ///钥匙厚度
  int thickness = 0;
  int thick = 0; // Thick(3)
  int length = 0; //有效长度
  int depth = 0; //切削深度

  int x = 0; //未知值
  int nose = 0; //齿尖开口
  int groove = 0; //路直径

  int cuts = 0; //齿数
  int dan = 0; //段数
  ///钥匙胚序列号
  int keySerNum = 0;

//		const uint16_t X_Diff;
//		const uint16_t Y_Diff;

  int pzR = 50;
  int xdR = 100; //定义碰针和铣刀的半径

  int lipsA = 0;
  int lipsAX = 0;
  int lipsB = 0;
  int lipsBX = 0; //开口数据
  int topX = 0;
  int topY = 0; //落点数据
  List<int> toothSA = []; //A齿位置
  List<int> toothSB = []; //B齿位置
  List<int> toothWideSA = []; //A齿宽度
  List<int> toothWideSB = []; //B齿宽度
  ///标准齿深
  List<int> ahNum = [];

  ///标准齿深
  List<int> bhNum = []; //标准齿深
  List<int> sAhNum = []; //实际值
  List<int> sBhNum = []; //实际值
  ///显示的齿号
  List<String> ahNums = []; //显示的齿号
  ///显示的齿号
  List<String> bhNums = []; //显示的齿号
  ///钥匙是否有错误
  bool errorkey = false;
  List<String> toothDepthName = []; //齿号列表类似 ["1","2",,,,]
  List<int> toothDepth = []; //齿深列表[110,200,300,,,,]
  int cutDiff = 0;
  int headDiff = 0;
  int seleindex = 0; //选中的齿位;
  int seleside = 0; //选中的边
  ///缺齿查询时候使用的汽车名称
  String _carname = "";
  List<Map> otherAxis = [];
  //开口数据
  int headAx = 0;
  int headAy = 0;
  int headBx = 0;
  int headBy = 0;
  int headCx = 0;
  int headCy = 0;
  int headDx = 0;
  int headDy = 0;

  ///自定义钥匙属性
  Map diykeysqlid = {};
  //初始化钥匙基本数据
  void initdata(
    Map keydata, {
    bool isKeyModel = false, //是否是模型数据
    bool isSmartKey = false, //是否是智能卡数据
    bool isNonConductiveKey = false, //是否是非导电钥匙数据
    bool initcKeydata = true, //是否初始化轴钥匙数据
  }) {
    cleardata();

    if (initcKeydata) {
      axhNums = [];
      bxhNums = [];
      cxhNums = [];
      cKeyData = Map.from(keydata);
    }
    // print(cKeyData);
    if (!isKeyModel) //标准钥匙数据
    {
      debugPrint("初始化basekey");
      if (keydata["hide"] == "" || keydata["hide"] == null) {
        hide = false;
      } else {
        hide = keydata["hide"];
      }
      if (keydata["headAx"] != null) headAx = keydata["headAx"];
      if (keydata["headAy"] != null) headAy = keydata["headAy"];
      if (keydata["headBx"] != null) headBx = keydata["headBx"];
      if (keydata["headBy"] != null) headBy = keydata["headBy"];
      if (keydata["headCx"] != null) headCx = keydata["headCx"];
      if (keydata["headCy"] != null) headCy = keydata["headCy"];
      if (keydata["headDx"] != null) headDx = keydata["headDx"];
      if (keydata["headDy"] != null) headDy = keydata["headDy"];
      keyClass = keydata["class"];
      locat = keydata["locat"]; //对头方式 {1:钥匙头尖部 ,0: 钥匙肩}
      side = keydata[
          "side"]; //{0:A面, 1:B面, 2:AB面, 3:A面,B面}   sb0:2 sb1:0,1 sb2:3 sb3: 0,1 sb4:3 sb5:0,1 sb7:2 sb9:2
      fixture = keydata["fixture"][0]; //钥匙处理的夹具类型

      wide = keydata["wide"]; // 钥匙宽度
      thickness = keydata["thickness"]; //钥匙厚度
      length = keydata["length"]; //有效长度
      depth = keydata["depth"]; //切削深度
      groove = keydata["groove"]; //路直径

      sideAtooth = keydata["toothSA"].length;
      sideBtooth = keydata["toothSB"].length;
      toothSA = List.from(keydata["toothSA"]); //A齿位置
      toothSB = List.from(keydata["toothSB"]); //B齿位置
      toothWideSA = List.from(keydata["toothWideA"]); //A齿宽度
      toothWideSB = List.from(keydata["toothWideB"]); //B齿宽度
      if (sideAtooth > 0 && sideBtooth > 0) {
        if (sideAtooth == sideBtooth) {
          cuts = sideAtooth;
          List<int> temp = List.from(toothSA);
          sideAtooth = temp.toSet().toList().length;
          temp = List.from(toothSB);
          sideBtooth = temp.toSet().toList().length;
        } else {
          cuts = sideAtooth > sideBtooth ? sideAtooth : sideBtooth;
          for (var i = 0; i < (sideAtooth - sideBtooth).abs(); i++) {
            if (sideAtooth < sideBtooth) {
              toothSA.add(toothSA[sideAtooth - 1]);
              toothWideSA.add(toothWideSA[sideAtooth - 1]);
            }
            if (sideAtooth > sideBtooth) {
              toothSB.add(toothSB[sideBtooth - 1]);
              toothWideSB.add(toothWideSB[sideBtooth - 1]);
            }
          }
        }
      }
      keySerNum = keydata["id"]; //钥匙胚序列号
      lipsA = keydata["A"];
      lipsAX = keydata["AX"];
      lipsB = keydata["B"];
      lipsBX = keydata["BX"]; //开口数据
      toothDepth = List.from(keydata["toothDepth"]);
      toothDepthName = List.from(keydata["toothDepthName"]);
      if (toothDepth.isNotEmpty && toothDepthName.isNotEmpty) {
        for (var i = 0; i < cuts; i++) {
          if (keyClass == 13) {
            ahNum.add(toothDepth[0]);
          } else {
            ahNum.add(toothDepth[0]);
          }
          ahNums.add("?");
          sAhNum.add(0);
        }
        for (var i = 0; i < cuts; i++) {
          if (keyClass == 13) {
            bhNum.add(toothDepth[5]);
          } else {
            bhNum.add(toothDepth[0]);
          }

          bhNums.add("?");
          sBhNum.add(0);
        }
      }
      if (initcKeydata) {
        otherAxis = List.from(keydata["moreside"]);
      }
      if (cncVersion.fixtureType == 21) {
        switch (baseKey.keySerNum) {
          case 70:
          case 177:
          case 178:
            baseKey.fixture = 4;
            break;
          case 73: //VA2-1125
          case 341: //va2-1126
            baseKey.fixture = 5;
            break;
          default:
        }
      }
    } else //模型数据
    {
      cuts = 11; //模型数据的值为11
      for (var i = 0; i < cuts; i++) {
        toothSA.add(0);
        toothSB.add(0);
        toothWideSA.add(0);
        toothWideSB.add(0);
        ahNum.add(0);
        bhNum.add(0);
      }
      keySerNum = keydata["id"];
      fixture = keydata["fixture"];
      keyClass = keydata["class"];
      wide = keydata["modelwide"];
      thickness = keydata["modelthickness"];
      toothWideSA[0] = keydata["keywide"];
      toothWideSA[1] = keydata["keythickness"];
      thick = keydata["alltype"];
      locat = keydata["locat"];
      toothSA[2] = keydata["locatlength"];
      toothWideSA[2] = keydata["locatwide"];
      toothWideSA[3] = keydata["locathill"];
      toothSA[4] = keydata["headtype"];
      toothSA[5] = keydata["headlength"];
      toothSA[6] = keydata["headwide"];
      side = keydata["groovetype"];
      length = keydata["mgroovelength"];
      depth = keydata["mgroovedepth"];
      x = keydata["mgroovewide"];
      nose = keydata["mgroovedistance"];
      toothSA[1] = keydata["ugroovedepth"];
      toothSA[0] = keydata["ugroovewide"];
      toothSA[3] = keydata["ugroovelength"];
      toothWideSA[4] = keydata["lgroovewide"];
      toothWideSA[5] = keydata["lgroovedepth"];
      toothWideSA[6] = keydata["lgroovelength"];
      toothWideSA[7] = keydata["v2groovedepth"];
      toothWideSA[8] = keydata["v2groovelength"];
      toothWideSA[9] = keydata["v2groovewide"];
      toothWideSA[10] = keydata["v2groovedistance"];
      toothSA[7] = keydata["hu71depth"];
      toothSA[8] = keydata["hu71length"];
      toothSA[9] = keydata["hu71hill"];
    }
    _smartkey = isSmartKey;
    _nonconductive = isNonConductiveKey;
  }

  setcarname(String carname) {
    _carname = carname;
  }

  String get getcarname => _carname;

  ///true 智能卡
  bool get issmart => _smartkey;

  ///true 非导电
  bool get isnonconductive => _nonconductive;

  void cleardata() {
    errorkey = false;
    readstate = false;
    needChangeXD = false; //更换铣刀
    manualChangeXD = false; //手动更换铣刀
    keyClass = 0;
    locat = 0; //对头方式 {1:钥匙头尖部 ,0: 钥匙肩}

    dir = 0; //夹取方式{正夹：1，反夹：0}
    side =
        0; //{0:A面, 1:B面, 2:AB面, 3:A面,B面}   sb0:2 sb1:0,1 sb2:3 sb3: 0,1 sb4:3 sb5:0,1 sb7:2 sb9:2
    fixture = 0; //钥匙处理的夹具类型

    wide = 0; // 钥匙宽度
    thickness = 0; //钥匙厚度
    thick = 0; // Thick(3)
    length = 0; //有效长度
    depth = 0; //切削深度

    x = 0; //未知值
    nose = 0; //齿尖开口
    groove = 0; //路直径

    cuts = 0; //齿数
    dan = 0; //段数

    keySerNum = 0; //钥匙胚序列号

//		const uint16_t X_Diff;
//		const uint16_t Y_Diff;

    pzR = 50;
    xdR = 100; //定义碰针和铣刀的半径

    lipsA = 0;
    lipsAX = 0;
    lipsB = 0;
    lipsBX = 0; //开口数据
    topX = 0;
    topY = 0; //落点数据
    toothSA = []; //A齿位置
    toothSB = []; //B齿位置
    toothWideSA = []; //A齿宽度
    toothWideSB = []; //B齿宽度
    ahNum = []; //标准齿深
    bhNum = []; //标准齿深
    sAhNum = []; //实际值
    sBhNum = []; //实际值
    ahNums = []; //显示的齿号
    bhNums = []; //显示的齿号
    toothDepthName = []; //齿号列表类似 ["1","2",,,,]
    toothDepth = []; //齿深列表[110,200,300,,,,]
    cutDiff = 0;
    headDiff = 0;
    headAx = 0;
    headAy = 0;
    headBx = 0;
    headBy = 0;
    headCx = 0;
    headCy = 0;
    headDx = 0;
    headDy = 0;
  }

//检查齿号的完整性
//全丢不能超过4个
//切削必须全部输入
  bool checkkeydata(int lessnum) {
    int num = 0;
    ////print(ahNums);
    ////print(bhNums);
    if (side == 0 || side == 3) {
      for (var element in ahNums) {
        if (element == "?") {
          num++;
        }
      }
      if (num > lessnum) {
        return false;
      }
    }
    num = 0;
    if (side == 1 || side == 2 || side == 3) {
      for (var element in bhNums) {
        if (element == "?") {
          num++;
        }
      }
      if (num > lessnum) {
        return false;
      }
    }
    return true;
  }

  ///mode=0 读码
  ///mode=1 切削
  ///mode=2 非导电切削
  ///mode=3 模型加工
  ///model=4 查找钥匙 需要将齿深添加到齿位上面
  ///model=5 实际值切削
  List<int> creatkeydata(int model) {
    charkeydata.clear();

    charkeydata.addAll(intToFormatHex(ver, 4));
    charkeydata.addAll(intToFormatHex(keyClass, 2));
    charkeydata.addAll(intToFormatHex(locat, 2));
    charkeydata.addAll(intToFormatHex(dir, 2));
    charkeydata.addAll(intToFormatHex(side, 2));
    switch (model) {
      case 3:
        charkeydata.addAll(intToFormatHex(13, 4));
        break;
      case 2:
        charkeydata.addAll(intToFormatHex(13, 4));
        break;
      default:
        charkeydata.addAll(intToFormatHex(fixture, 4));
        break;
    }

    charkeydata.addAll(intToFormatHex(wide, 4));
    charkeydata.addAll(intToFormatHex(thickness, 4));
    charkeydata.addAll(intToFormatHex(thick, 4));
    charkeydata.addAll(intToFormatHex(length, 4));
    charkeydata.addAll(intToFormatHex(depth, 4));
    charkeydata.addAll(intToFormatHex(x, 4));
    charkeydata.addAll(intToFormatHex(nose, 4));
    charkeydata.addAll(intToFormatHex(groove, 4));
    charkeydata.addAll(intToFormatHex(cuts, 4));
    charkeydata.addAll(intToFormatHex(dan, 4));
    charkeydata.addAll(intToFormatHex(keySerNum, 4));
    charkeydata.addAll(intToFormatHex(pzR, 4));
    charkeydata.addAll(intToFormatHex(xdR, 4));
    charkeydata.addAll(intToFormatHex(lipsA, 4));
    charkeydata.addAll(intToFormatHex(lipsAX, 4));
    charkeydata.addAll(intToFormatHex(lipsB, 4));
    charkeydata.addAll(intToFormatHex(lipsBX, 4));
    charkeydata.addAll(intToFormatHex(topX, 4));
    charkeydata.addAll(intToFormatHex(topY, 4));
    switch (side) {
      case 0:
      case 1:
      case 2:
        int len = charkeydata.length;
        if (len < 56) {
          for (var i = 0; i < 56 - len; i++) {
            debugPrint("添加数据");
            charkeydata.add(0);
          }
        }
        charkeydata.addAll(intToFormatHex(cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex(cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex((cuts * 2) + cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex((cuts * 2) + cuts * 2, 4));
        break;
      case 3:
        debugPrint("双边");
        ////print(charkeydata.length);
        int len = charkeydata.length;
        if (len < 52) {
          for (var i = 0; i < 52 - len; i++) {
            debugPrint("添加数据");
            charkeydata.add(0);
          }
        }
        charkeydata.addAll(intToFormatHex(cuts * 3 * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex(cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex((cuts * 3 * 2) + cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata.addAll(intToFormatHex((cuts * 2) + cuts * 2, 4));
        charkeydata.add(0);
        charkeydata.add(0);
        charkeydata
            .addAll(intToFormatHex(cuts * 3 * 2 + cuts * 2 + cuts * 2, 4));
        break;
    }
    int len = charkeydata.length;
    if (len < 120) {
      for (var i = 0; i < 120 - len; i++) {
        charkeydata.add(0);
      }
    }
    //添加齿位
    for (var i = 0; i < cuts; i++) {
      switch (model) {
        case 0:
          charkeydata.addAll(intToFormatHex(toothSA[i] - headDiff, 4));
          break;
        default:
          charkeydata.addAll(intToFormatHex(toothSA[i], 4));
          break;
      }
    }
    for (var i = 0; i < cuts; i++) {
      charkeydata.addAll(intToFormatHex(toothWideSA[i], 4));
    }
    //添加A边的齿深
    for (var i = 0; i < cuts; i++) {
      switch (model) {
        case 0:
          charkeydata.addAll(intToFormatHex(0, 4));
          break;
        case 4:
          charkeydata
              .addAll(intToFormatHex(toothDepth[i % (toothDepth.length)], 4));
          break;
        case 5:
          if (readstate && sAhNum.isNotEmpty) {
            charkeydata.addAll(intToFormatHex(sAhNum[i], 4));
          } else {
            charkeydata.addAll(intToFormatHex(ahNum[i], 4));
          }
          break;
        default:
          charkeydata.addAll(intToFormatHex(ahNum[i], 4));
          break;
      }
    }
    if (side == 3) {
      for (var i = 0; i < cuts; i++) {
        if (model == 0) {
          charkeydata.addAll(intToFormatHex(toothSB[i] - headDiff, 4));
        } else {
          charkeydata.addAll(intToFormatHex(toothSB[i], 4));
        }
      }
      for (var i = 0; i < cuts; i++) {
        charkeydata.addAll(intToFormatHex(toothWideSB[i], 4));
      }
      for (var i = 0; i < cuts; i++) {
        switch (model) {
          case 0:
            charkeydata.addAll(intToFormatHex(0, 4));
            break;
          case 4:
            charkeydata
                .addAll(intToFormatHex(toothDepth[i % (toothDepth.length)], 4));
            break;
          case 5:
            if (readstate && sBhNum.isNotEmpty) {
              charkeydata.addAll(intToFormatHex(sBhNum[i], 4));
            } else {
              charkeydata.addAll(intToFormatHex(bhNum[i], 4));
            }
            break;
          default:
            charkeydata.addAll(intToFormatHex(bhNum[i], 4));
            break;
        }
      }
    }

    for (var i = 0; i < cuts * 2 * 2 + 7; i++) {
      charkeydata.add(0);
    }
    if (cncVersion.version >= 2022101201) {
      // charkeydata.addAll(intToFormatHex(ax, 4));
      // charkeydata.addAll(intToFormatHex(ay, 4));
      // charkeydata.addAll(intToFormatHex(bx, 4));
      // charkeydata.addAll(intToFormatHex(by, 4));
      // charkeydata.addAll(intToFormatHex(cx, 4));
      // charkeydata.addAll(intToFormatHex(cy, 4));
      // charkeydata.addAll(intToFormatHex(dx, 4));
      // charkeydata.addAll(intToFormatHex(dy, 4));

      charkeydata.addAll(intToFormatHex(headAx, 4));
      charkeydata.addAll(intToFormatHex(headAy, 4));
      charkeydata.addAll(intToFormatHex(headBx, 4));
      charkeydata.addAll(intToFormatHex(headBy, 4));
      charkeydata.addAll(intToFormatHex(headCx, 4));
      charkeydata.addAll(intToFormatHex(headCy, 4));
      charkeydata.addAll(intToFormatHex(headDx, 4));
      charkeydata.addAll(intToFormatHex(headDy, 4));
    }
    ////print(charkeydata);
    return charkeydata;
  }

//根据实际齿深换算标准齿深
//根据标准齿深获得齿号
//根据蓝牙返回的数据同步  齿深 和齿号数据
  void asynctooth() {
    int base = 4;
    // if (appData.readmodel) {
    //   base = 5;
    // } else {
    //   base = 4;
    // }
    if (ahNum.isEmpty && bhNum.isEmpty) {
      for (var i = 0; i < cuts; i++) {
        ahNum.add(0);
        bhNum.add(0);
        ahNums.add("1");
        bhNums.add("1");
      }
    }
    //A边
    if (keyClass == 13) {
      for (var i = 0; i < cuts; i++) {
        for (var j = 5; j < toothDepth.length; j++) {
          if (j == 5) {
            if (sAhNum[i] >=
                toothDepth[j] -
                    (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
              ////print(toothDepthName[j]);
              if ((sAhNum[i] - toothDepth[j]).abs() <
                  (sBhNum[i] - toothDepth[j - 5]).abs()) {
                ahNum[i] = toothDepth[j];

                bhNum[i] = wide - groove - ahNum[i];
                toothWideSA[i] = 100;
                toothWideSB[i] = 50;
                ahNums[i] = toothDepthName[j];
                bhNums[i] = toothDepthName[j];
              } else {
                bhNum[i] = toothDepth[j - 5];
                ahNum[i] = wide - groove - bhNum[i];
                toothWideSB[i] = 100;
                toothWideSA[i] = 50;
                ahNums[i] = toothDepthName[j - 5];
                bhNums[i] = toothDepthName[j - 5];
              }
              // print("");
            }
          } else if (j == toothDepth.length - 1) {
            if (sAhNum[i] <=
                toothDepth[j] +
                    (toothDepth[j - 1] - toothDepth[j]) * (8 - base) / 8) {
              ////print(toothDepthName[j]);
              if ((sAhNum[i] - toothDepth[j]).abs() <
                  (sBhNum[i] - toothDepth[j - 5]).abs()) {
                ahNum[i] = toothDepth[j];
                bhNum[i] = wide - groove - ahNum[i];
                toothWideSA[i] = 100;
                toothWideSB[i] = 50;
                ahNums[i] = toothDepthName[j];
                bhNums[i] = toothDepthName[j];
              } else {
                bhNum[i] = toothDepth[j - 5];
                ahNum[i] = wide - groove - bhNum[i];
                toothWideSB[i] = 100;
                toothWideSA[i] = 50;
                ahNums[i] = toothDepthName[j - 5];
                bhNums[i] = toothDepthName[j - 5];
              }
            }
          } else {
            if (sAhNum[i] <
                    toothDepth[j] +
                        (toothDepth[j] - toothDepth[j + 1]) * (8 - base) / 8 &&
                sAhNum[i] >=
                    toothDepth[j] -
                        (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
              if ((sAhNum[i] - toothDepth[j]).abs() <
                  (sBhNum[i] - toothDepth[j - 5]).abs()) {
                ahNum[i] = toothDepth[j];
                bhNum[i] = wide - groove - ahNum[i];
                toothWideSA[i] = 100;
                toothWideSB[i] = 50;
                ahNums[i] = toothDepthName[j];
                bhNums[i] = toothDepthName[j];
              } else {
                bhNum[i] = toothDepth[j - 5];
                ahNum[i] = wide - groove - bhNum[i];
                toothWideSB[i] = 100;
                toothWideSA[i] = 50;
                ahNums[i] = toothDepthName[j - 5];
                bhNums[i] = toothDepthName[j - 5];
              }
            }
          }
        }
      }
    }
    //标准
    else {
      if (side == 0 || side == 3) {
        // //debugPrint("处理A边的数据");
        // ////print(sAhNum);
        // ////print(toothDepth);
        // ////print(toothDepthName);
        for (var i = 0; i < cuts; i++) {
          //debugPrint("i:${SAhNum[i]}");
          for (var j = 0; j < toothDepth.length; j++) {
            if (j == 0) {
              if (sAhNum[i] >=
                  toothDepth[j] -
                      (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                ahNum[i] = toothDepth[j];
                ahNums[i] = toothDepthName[j];
                ////print(toothDepthName[j]);
              }
            } else if (j == toothDepth.length - 1) {
              debugPrint("最后一个齿");
              if (sAhNum[i] <=
                  toothDepth[j] +
                      (toothDepth[j - 1] - toothDepth[j]) * (8 - base) / 8) {
                ////print(toothDepthName[j]);
                ahNum[i] = toothDepth[j];
                ahNums[i] = toothDepthName[j];
              }
            } else {
              if (sAhNum[i] <
                      toothDepth[j] +
                          (toothDepth[j] - toothDepth[j + 1]) *
                              (8 - base) /
                              8 &&
                  sAhNum[i] >=
                      toothDepth[j] -
                          (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                ahNum[i] = toothDepth[j];
                ahNums[i] = toothDepthName[j];
                ////print(toothDepthName[j]);
              }
            }
          }
        }
        if (side == 0) {
          bhNum = List.from(ahNum);
          bhNums = List.from(ahNums);
        }
      }
      if (side == 1 || side == 2 || side == 3) {
        debugPrint("处理B边的数据");
        ////print(toothDepth);
        ////print(toothDepthName);
        for (var i = 0; i < cuts; i++) {
          for (var j = 0; j < toothDepth.length; j++) {
            if (j == 0) {
              if (sBhNum[i] >=
                  toothDepth[j] -
                      (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                bhNum[i] = toothDepth[j];
                bhNums[i] = toothDepthName[j];
              }
            } else if (j == toothDepth.length - 1) {
              if (sBhNum[i] <=
                  toothDepth[j] +
                      (toothDepth[j - 1] - toothDepth[j]) * (8 - base) / 8) {
                bhNum[i] = toothDepth[j];
                bhNums[i] = toothDepthName[j];
              }
            } else {
              if (sBhNum[i] <
                      toothDepth[j] +
                          (toothDepth[j] - toothDepth[j + 1]) *
                              (8 - base) /
                              8 &&
                  sBhNum[i] >=
                      toothDepth[j] -
                          (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                bhNum[i] = toothDepth[j];
                bhNums[i] = toothDepthName[j];
              }
            }
          }
        }
        if (side == 1 || side == 2) {
          ahNum = List.from(bhNum);
          ahNums = List.from(bhNums);
        }
      }
    }
    //平铣双边齿号齿深重新计算 读双边
    if (keyClass == 0 && side == 3) {
      //如果双边的数据不相同
      if (!(listEquals(ahNum, bhNum) && listEquals(ahNums, bhNums))) {
        List<int> sChNum = []; //中心的实际齿深
        List<int> chNum = []; //中心的标准齿深
        List<String> chNums = [];
        for (var i = 0; i < cuts; i++) {
          chNum.add(0);

          chNums.add("1");
        }

        for (var i = 0; i < ahNum.length; i++) {
          sChNum.add((sAhNum[i] + sBhNum[i]) ~/ 2);
        }
        for (var i = 0; i < cuts; i++) {
          for (var j = 0; j < toothDepth.length; j++) {
            if (j == 0) {
              if (sChNum[i] >=
                  toothDepth[j] -
                      (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                chNum[i] = toothDepth[j];
                chNums[i] = toothDepthName[j];
              }
            } else if (j == toothDepth.length - 1) {
              if (sChNum[i] <=
                  toothDepth[j] +
                      (toothDepth[j - 1] - toothDepth[j]) * (8 - base) / 8) {
                chNum[i] = toothDepth[j];
                chNums[i] = toothDepthName[j];
              }
            } else {
              if (sChNum[i] <
                      toothDepth[j] +
                          (toothDepth[j] - toothDepth[j + 1]) *
                              (8 - base) /
                              8 &&
                  sChNum[i] >=
                      toothDepth[j] -
                          (toothDepth[j] - toothDepth[j + 1]) * base / 8) {
                chNum[i] = toothDepth[j];
                chNums[i] = toothDepthName[j];
              }
            }
          }
        }

        if (listEquals(ahNum, chNum) || listEquals(bhNum, chNum)) {
          ahNums = List.from(chNums);
          bhNums = List.from(chNums);
          ahNum = List.from(chNum);
          bhNum = List.from(chNum);
        } else {
          //如果 中心线也不相同 那么当前钥匙可能有问题
          errorkey = true;
          ahNums = List.from(bhNums);
          ahNum = List.from(bhNum);
        }
      } else {
        debugPrint("数据正常");
      }
    }
    // print(ahNum);
    // print(bhNum);
  }

//根据齿深获得齿号 数据来源于蓝牙 蓝牙返回的数据为 实际深度
//需要换算成 标准齿深
//钥匙显示的图像为实际齿深
  void getkeynum(List<int> data) {
    if (sAhNum.isEmpty && sBhNum.isEmpty) {
      for (var i = 0; i < cuts; i++) {
        sAhNum.add(0);
        sBhNum.add(0);
      }
    }
    for (var i = 0; i < cuts; i++) {
      sAhNum[i] = 0;
      sBhNum[i] = 0;
    }
    switch (side) {
      case 0:
        for (var i = 0; i < cuts; i++) {
          sAhNum[i] = hexToInt(data.sublist(4 + i * 2, 6 + i * 2));
        }
        break;
      case 1:
        for (var i = 0; i < cuts; i++) {
          sBhNum[i] = hexToInt(data.sublist(6 + i * 2, 8 + i * 2));
        }
        break;
      case 2:
      case 3:
        for (var i = 0; i < cuts; i++) {
          sAhNum[i] = hexToInt(data.sublist(4 + i * 2, 6 + i * 2));
        }
        for (var i = 0; i < cuts; i++) {
          sBhNum[i] = hexToInt(
              data.sublist(4 + cuts * 2 + 2 + i * 2, 8 + cuts * 2 + i * 2));
        }
        break;
    }
    // //print(sAhNum);
    // //print(sBhNum);
    if (toothDepth.isNotEmpty && toothDepthName.isNotEmpty) {
      asynctooth();
    }
  }
}

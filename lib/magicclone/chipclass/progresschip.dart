// Map chip46data = {
//   "防盗类型": "未知",
//   "ID": "未知",
//   "具体芯片": "未知",
//   "锁定位": "未知",
//   "是否可拷贝": "未知",
//   "加密模式": "未知",
//   "编码模式": "未知",
// };

//整形数组转字符串

// import 'dart:convert';
// import 'dart:ffi';
// import 'dart:typed_data';
// import 'package:event_bus/event_bus.dart';
// import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:magictank/appdata.dart';

import '../../alleventbus.dart';
import '../../convers/convers.dart';
import '../bluetooth/sendcmd.dart';
import '../network.dart';

class CMD {
  int readChip = 0xff; //芯片识别
  int inCollectPage = 0x01; //进入采集页面
  int collectData = 0x02; //判断是否采集到数据 每秒发送
  int collectDataOK = 0x03; //采集完成  //或者网路解码
  int inputOriginlKey = 0x04; //确定插入原钥匙
  int getVersion = 0x10; //获取版本
  int getBTMAC = 0x12; //获取蓝牙MAC//D4A99F2F936D
}

CMD cmds = CMD();

//识别芯片过程中的状态

class ProgressChip {
  String magicCloneVer = "";
  // List<Map> supportchiplist = [
  //   {
  //     "name": "46在线计算",
  //     "id": 1,
  //     "chipnamebyte": [0x46, 0x00],
  //     "picname": "image/mcclone/Icon_Chip46.png"
  //   },
  //   {
  //     "name": "48(96位)在线计算",
  //     "id": 2,
  //     "chipnamebyte": [0x48, 0x00],
  //     "picname": "image/mcclone/Icon_Chip48.png"
  //   },
  //   {
  //     "name": "4D在线计算",
  //     "id": 3,
  //     "chipnamebyte": [0x4d, 0x00],
  //     "picname": "image/mcclone/Icon_Chip4D.png"
  //   },
  //   {
  //     "name": "4E在线计算",
  //     "id": 4,
  //     "chipnamebyte": [0x4e, 0x00],
  //     "picname": "image/mcclone/Icon_Chip4E.png"
  //   },
  //   {
  //     "name": "70/83在线计算",
  //     "id": 5,
  //     "chipnamebyte": [0x4d, 0x70],
  //     "picname": "image/mcclone/Icon_Chip70.png"
  //   },
  //   {
  //     "name": "丰田8A/H在线计算",
  //     "id": 6,
  //     "chipnamebyte": [0x8a, 0x00],
  //     "picname": "image/mcclone/Icon_Chip8A.png"
  //   },
  //   {
  //     "name": "丰田/大发G芯片拷贝",
  //     "id": 7,
  //     "chipnamebyte": [0x72, 0x00],
  //     "picname": "image/mcclone/Icon_ChipG.png"
  //   },
  //   {
  //     "name": "铃木启悦折叠钥匙拷贝",
  //     "id": 8,
  //     "chipnamebyte": [0x46, 0x00],
  //     "picname": "image/mcclone/Icon_ChipSu.png"
  //   },
  //   {
  //     "name": "11/12/13/4C芯片拷贝",
  //     "id": 9,
  //     "chipnamebyte": [0x11, 0x00],
  //     "picname": "image/mcclone/Icon_Chip4D.png"
  //   },
  //   {
  //     "name": "42芯片拷贝",
  //     "id": 10,
  //     "chipnamebyte": [0x42, 0x00],
  //     "picname": "image/mcclone/Icon_Chip42.png"
  //   },
  //   {
  //     "name": "33芯片拷贝",
  //     "id": 11,
  //     "chipnamebyte": [0x33, 0x00],
  //     "picname": "image/mcclone/Icon_Chip33.png"
  //   },
  // ];
  List<Map> supportchiplist = [
    {
      "name": "46在线计算",
      "id": 1,
      "chipnamebyte": [0x46, 0x00],
      "picname": "image/mcclone/Icon_Chip46.png",
      "needcheck": true
    },
    {
      "name": "4D在线计算",
      "id": 3,
      "chipnamebyte": [0x4d, 0x00],
      "picname": "image/mcclone/Icon_Chip4D.png",
      "needcheck": true
    },
  ];
  String mcbtmac = ""; //eclone蓝牙地址
  int _progressDataState = 0; //状态 标记 收到数据后如何处理
  String chipname = ""; //芯片名称
  List<int> chipnamebyte = []; //芯片的byte数组
  //Map temp = {};
  List<Map> chipdata = [];
  List<dynamic> chipPageData = []; //芯片页数据
  List<List<int>> signdata = []; //签名数据 用于网络破解  4D共计4组  46 6组
  List<int> password = []; //服务器返回的密码
  int chipid = 0;
  int receivePage = 0; //需要接收的页数 用于计数 4D 破解返回的数据
  final List<int> default46pw = [0x4F, 0x4E, 0x4D, 0x49, 0x4B, 0x52];
  int _currentPage = 0;
  int _icreadpage = 0; //当前读取的IC块
  String old4DPW = ""; //记录识别时旧4D密码,用在生成步骤
  bool copy = false; //是否可拷贝  识别46如果 返回了密码 那么就可以直接拷贝
  int servertimer = 120;
  List<int> p172g = []; //72G生成时候客户选择的钥匙胚
  List<int> defaulticpw = [0XFF, 0XFF, 0XFF, 0XFF, 0XFF, 0XFF];
  List<int> icdata = [];
  Map sign4dData = {
    "crack_type": "4d_dst40",
    "dst40_signatures": {"sig1": [], "sig2": [], "sig3": [], "sig4": []}
  };
  Map sign46Data = {
    "crack_type": "46",
    "signature_46": {
      "sig1": [],
      "sig2": [],
      "sig3": [],
      "sig4": [],
      "sig5": [],
      "sig6": []
    },
  };

  void setResState(int state) {
    //设置接收数据的处理方式
    _progressDataState = state;
  }

  int getResState() {
    //设置接收数据的处理方式
    return _progressDataState;
  }

  int getCurrenPageState() {
    //设置接收数据的处理方式
    return _currentPage;
  }

//识别芯片
  void discernChip() async {
    _progressDataState = 0;
    sendcmd([], cmds.readChip, []);

    // await dataCallsendBle([0XA5, 0xff, 0X03, 0XFF, 0XFF, 0XA5]);
  }

  Future<void> getver() async {
//  debugPrint("获得版本号");
    _progressDataState = 6;
    senddata([], cmds.getVersion, []);
    // await dataCallsendBle([0xA6, 0xFF, 0x02, 0x10, 0xB7]);
  }

  Future<void> getbtmac() async {
//  debugPrint("获得版本号");
    _progressDataState = 6;
    senddata([], cmds.getBTMAC, []);
    // await dataCallsendBle([0xA6, 0xFF, 0x02, 0x10, 0xB7]);
  }

  String default46pw2 = "4F4E4D494B52";

  void progressChipData(List<int> data) {
    {
      debugPrint("识别芯片");
      Map temp = {};
      chipname = intToFormatStringHex(data[3]) + intToFormatStringHex(data[4]);
      chipnamebyte = data.sublist(3, 5);
      temp.clear();
      chipdata.clear();
      chipPageData.clear();
      debugPrint(chipname);
      copy = false;
      switch (chipnamebyte[0]) {
        case 0x1c:
          temp.addAll({"防盗类型": "IC"});
          switch (data[5]) {
            case 0x04:
              temp.addAll({"IC类型": "Mifare_One(S50)"});
              for (var i = 0; i < 64; i++) {
                if ((i + 1) % 4 == 0) {
                  chipPageData.add("FFFFFFFFFFFFFF078069FFFFFFFFFFFF");
                } else {
                  chipPageData.add("00000000000000000000000000000000");
                }
              }
              break;
            case 0x44:
              switch (data[6]) {
                case 0x00:
                  temp.addAll({"IC类型": "Mifare_UltraLight"});
                  break;
                case 0x03:
                  temp.addAll({"IC类型": "Mifare_DESFire"});
                  break;
              }
              break;
            case 0x02:
              temp.addAll({"IC类型": "Mifare_One(S70)"});
              break;
            case 0x08:
              temp.addAll({"IC类型": "Mifare_One(Pro)"});
              break;
          }
          temp.addAll(
              {"UID": intlisttohexstring(data.sublist(7, data.length - 1))});
          chipdata.add(temp);
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x11:
        case 0x12:
        case 0x13:
        case 0xd5:
          temp.addAll({"防盗类型": chipname});
          temp.addAll(
              {"ID": intlisttohexstring(data.sublist(5, data.length - 1))});
          chipdata.add(temp);
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x33: //44
        case 0x40:
        case 0x41: //44
        case 0x42:
        case 0x43:
        case 0x44: //44
          temp.addAll({"防盗类型": chipname});
          temp.addAll({"ID": intlisttohexstring(data.sublist(5, 13))});
          chipdata.add(temp);
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x4c:
          temp.addAll({"防盗类型": chipname});
          temp.addAll(
              {"ID": intlisttohexstring(data.sublist(5, data.length - 1))});
          temp.addAll({"拷贝": "可拷贝"});
          copy = true;
          chipdata.add(temp);
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x46: //
        case 0x47:
          chipid = 1;
          temp.addAll({"防盗类型": chipname});
          switch (intToFormatStringHex(data[9])[0]) {
            case "1":
              if (chipnamebyte[0] == 0x47) {
                temp.addAll({"具体芯片": "PCF7938"});
              } else {
                temp.addAll({"具体芯片": "PCF7936"});
              }
              break;
            case "b":
            case "B":
              temp.addAll({"具体芯片": "PCF7937"});
              break;
            case "2":
              temp.addAll({"具体芯片": "PCF7941"});
              break;
            case "4":
              temp.addAll({"具体芯片": "PCF7961"});
              break;
          }
          temp.addAll({"ID": intlisttohexstring(data.sublist(6, 10))});

          if (data[10] == 1 && data[15] == 1) {
            chipPageData.add(
                intlisttohexstring(data.sublist(6 + 5 * 2 + 2, 6 + 5 * 2 + 4)) +
                    intlisttohexstring(data.sublist(6 + 5 * 1, 6 + 5 * 1 + 4)));
            copy = true;
          } else {
            chipPageData.add(default46pw2);
          }
          temp.addAll({"拷贝": copy ? "可拷贝" : "需要解码"});
          chipdata.add(Map.from(temp));
          temp.clear();
          for (var i = 0; i < 8; i++) {
            if (data[5 + i * 5] == 1) {
              chipPageData.add(
                  intlisttohexstring(data.sublist(6 + 5 * i, 6 + 5 * i + 4)));
            } else {
              chipPageData.add("00000000");
            }
          }
          debugPrint("$chipPageData");
          chipdata.add(Map.from(temp));
          temp.clear();
          ////print("识别OK");
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x4d:
          chipid = 3;
          temp.addAll({"防盗类型": chipname});
          temp.addAll({
            "id": intlisttohexstring(data.sublist(6, 7)) +
                intlisttohexstring(data.sublist(9, 10)) +
                intlisttohexstring(data.sublist(12, 16))
          });

          if (data[5] == 1) {
            if (data[8] == 1) {
              temp.addAll({
                "汽车品牌": getcarname(intlisttohexstring(data.sublist(6, 8)),
                    intlisttohexstring(data.sublist(9, 11)))
              });
            } else {
              temp.addAll({
                "汽车品牌":
                    getcarname(intlisttohexstring(data.sublist(6, 8)), "0001")
              });
            }
          } else {
            temp.addAll({"汽车品牌": "未知"});
          }

          // temp.addAll({"车型": chipname});
          if (chipname == "4d67" || chipname == "4d68" || chipname == "4d72") {
            copy = true;
            temp.addAll({"复制": "可拷贝"});
          } else {
            temp.addAll({"复制": data[data.length - 1] == 1 ? "可拷贝" : "需解码"});
          }
          chipdata.add(Map.from(temp));
          // temp.clear();
          // temp.addAll({
          //   "P1": intlisttohexstring(data.sublist(6, 7)),
          //   "state": data[7] == 1 ? true : false
          // });
          // temp.addAll({
          //   "P2": intlisttohexstring(data.sublist(9, 10)),
          //   "state": data[10] == 1 ? true : false
          // });
          // temp.addAll({
          //   "P3": intlisttohexstring(data.sublist(12, 16)),
          //   "state": data[16] == 1 ? true : false
          // });
          // temp.addAll({
          //   "P4": intlisttohexstring(data.sublist(18, 23)),
          //   "state": data[23] == 1 ? true : false
          // });
          // chipdata.add(Map.from(temp));

          //P1
          if (data[5] == 1) {
            chipPageData.add(intlisttohexstring(data.sublist(6, 8)));
            old4DPW = intlisttohexstring(data.sublist(6, 8));
          } else {
            chipPageData.add("0001");
            old4DPW = "0000";
          }
          //P2
          if (data[8] == 1) {
            chipPageData.add(intlisttohexstring(data.sublist(9, 11)));
          } else {
            chipPageData.add("0001");
          }
          //P3
          if (data[11] == 1) {
            chipPageData.add(intlisttohexstring(data.sublist(12, 17)));
          } else {
            chipPageData.add("0000000001");
          }
          //P4
          if (data[17] == 1) {
            chipPageData.add(intlisttohexstring(data.sublist(18, 24)));
          } else {
            chipPageData.add("000000000000");
          }

          chipPageData.add("000000000000"); //P8
          chipPageData.add("000000000000"); //P9
          chipPageData.add("000000000000"); //10
          chipPageData.add("000000000000"); //11
          chipPageData.add("000000000000"); //12
          chipPageData.add("000000000000"); //13
          chipPageData.add("000000000000"); //14
          chipPageData.add("000000000000"); //15
          chipPageData.add("0000"); //18
          chipPageData.add("000000000000"); //29
          //P30需要倒序
          if (data[24] == 1) {
            List<int> relist = [];
            relist = List.from(data.sublist(25, 27));
            relist = List.from(relist.reversed);
            relist.add(data[27]);
            debugPrint("$relist");
            chipPageData.add(intlisttohexstring(relist));
          } else {
            chipPageData.add("000000");
          }
          debugPrint("识别成功");
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x48:
//         [e5, ff, 29, 48, 00,
// 01, 2a, d8, 89, e2,
// 01, af, dd, 87, 65,
// 01, aa, aa, aa, aa, aa, aa, aa, aa,
// 00, 00, 00, 00, 00,
// 01, aa, aa, aa, aa, aa, aa, aa, aa, aa, aa, aa, aa,
// 01, 87]
          temp.addAll({"防盗类型": chipname});
          temp.addAll({"id": intlisttohexstring(data.sublist(6, 10))});
          if (data[data.length - 2] == 0x01) {
            copy = true;
            temp.addAll({"复制": "可拷贝"});
          } else {
            temp.addAll({"复制": "需解码"});
          }
          temp.addAll({"复制": data[data.length - 2] == 0x01 ? "可拷贝" : "需解码"});
          chipdata.add(Map.from(temp));
          temp.clear();
          if (data[5] == 1) {
            //id
            chipPageData.add(intlisttohexstring(data.sublist(6, 10)));
          } else {
            chipPageData.add("00000000");
          }
          if (data[15] == 1) {
            //ums2
            chipPageData.add(intlisttohexstring(data.sublist(16, 18)));
            chipPageData.add(intlisttohexstring(data.sublist(18, 20)));
            chipPageData.add(intlisttohexstring(data.sublist(20, 22)));
            chipPageData.add(intlisttohexstring(data.sublist(22, 24)));
          } else {
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
          }
          if (data[10] == 1) {
            //page
            chipPageData.add(intlisttohexstring(data.sublist(11, 13)));
            chipPageData.add(intlisttohexstring(data.sublist(13, 15)));
          } else {
            chipPageData.add("0000");
            chipPageData.add("0000");
          }
          if (data[29] == 1) {
            //key
            chipPageData.add(intlisttohexstring(data.sublist(30, 32)));
            chipPageData.add(intlisttohexstring(data.sublist(32, 34)));
            chipPageData.add(intlisttohexstring(data.sublist(34, 36)));
            chipPageData.add(intlisttohexstring(data.sublist(36, 38)));
            chipPageData.add(intlisttohexstring(data.sublist(38, 40)));
            chipPageData.add(intlisttohexstring(data.sublist(40, 42)));
          } else {
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
            chipPageData.add("0000");
          }
          if (data[24] == 1) {
            chipPageData.add(intlisttohexstring(data.sublist(25, 29)));
          } else {
            chipPageData.add("00000000");
          }

          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x8a:
          temp.addAll({"防盗类型": chipname});

          temp.addAll({"id": intlisttohexstring(data.sublist(6, 10))});
          temp.addAll({"车型": "丰田 凯美瑞 雷凌等"});
          temp.addAll({"复制": "可拷贝"});
          copy = true;
          chipdata.add(Map.from(temp));
          temp.clear();
          for (var i = 0; i < 16; i++) {
            chipPageData.add("0000000000");
          }
          ////print(chipPageData);
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0x8c:
          temp.addAll({"防盗类型": chipname});
          temp.addAll({"id": intlisttohexstring(data.sublist(5, 15))});
          temp.addAll({"复制": "不可拷贝"});
          chipdata.add(Map.from(temp));
          eventBus.fire(ChipReadEvent(true));
          break;
        case 0xff:
          temp.addAll({"防盗类型": chipname});
          eventBus.fire(ChipReadEvent(false));
          break;

        default:
          //解码失败
          temp.addAll({"防盗类型": chipname});
          eventBus.fire(ChipReadEvent(true));
          break;
      }
    }
  }

//数据处理状态数据处理模式
  void progressbtchipdata(List<int> data) {
    debugPrint(
        "_progressDataState:$_progressDataState,data:${intListToHexStringList(data)}");
    switch (_progressDataState) {
      case 0: //识别状态
        progressChipData(data);
        break;
      case 1: //4D 46 网络破解的数据 4D 共计4组 46共计6组
        debugPrint("收到签名");
        debugPrint("$data");
        switch (chipnamebyte[0]) {
          case 0x4d:
            if (data[2] == 0x04) {
              signdata.add(List.from((data.sublist(3, 6))));
              if (signdata.length == 4) {
                //通知进行下一步
                for (var i = 0; i < 4; i++) {
                  sign4dData["dst40_signatures"]["sig${i + 1}"]
                      .addAll(List.from(signdata[i]));
                }
                eventBus.fire(ChipReadEvent(true));
              } else {
                print(signdata.length);
              }
            } else {
              eventBus.fire(ChipReadEvent(false));
            }
            break;
          case 0x46:
            if (data[2] == 0x06) {
              eventBus.fire(ChipReadEvent(false));
            } else {
              signdata.add(List.from(data.sublist(3, 15)));
              if (signdata.length == 6) {
                //通知进行下一步
                for (var i = 0; i < 6; i++) {
                  sign46Data["signature_46"]["sig${i + 1}"]
                      .addAll(List.from(signdata[i]));
                }
                ////print(sign46Data);
                eventBus.fire(ChipReadEvent(true));
              }
            }
            break;
        }
        break;
      case 2: //4D 解码
        debugPrint("解码数据"); //如果能收到 解码  那就证明解码失败
        debugPrint("$data");
        eventBus.fire(ChipReadEvent(false));
        break;
      case 3: //拷贝命令
        if (data[7] == 0x00) {
          eventBus.fire(ChipReadEvent(false)); //拷贝成功
        } else {
          eventBus.fire(ChipReadEvent(true)); //拷贝失败
        }
        break;
      case 4: //间接处理数据 写入读取状态 页面处理数据 读取芯片数据处理
        if (data[4] != _currentPage) {
          eventBus.fire(ChipReadEvent(false));
        } else {
          switch (chipnamebyte[0]) {
            case 0x46:
              switch (_currentPage) {
                case 0x12:
                case 0x22:
                  chipPageData[2] = intlisttohexstring(data.sublist(5, 9));
                  chipPageData[3] = intlisttohexstring(data.sublist(9, 13));
                  eventBus.fire(ChipReadEvent(true));
                  break;
                case 0x10:
                case 0x20:
                  chipPageData[4] = intlisttohexstring(data.sublist(5, 9));
                  eventBus.fire(ChipReadEvent(true));
                  break;
                case 0x11:
                case 0x21:
                  chipPageData[5] = intlisttohexstring(data.sublist(5, 9));
                  chipPageData[6] = intlisttohexstring(data.sublist(9, 13));
                  chipPageData[7] = intlisttohexstring(data.sublist(13, 17));
                  chipPageData[8] = intlisttohexstring(data.sublist(17, 21));
                  eventBus.fire(ChipReadEvent(true));
                  break;
                default:
              }
              break;
            case 0x48:
              switch (_currentPage) {
                case 0x01:
                  chipPageData[6] = intlisttohexstring(data.sublist(7, 9));
                  chipPageData[5] = intlisttohexstring(data.sublist(5, 7));
                  eventBus.fire(ChipReadEvent(true));
                  break;
                case 0x02: //ID
                  chipPageData[0] = intlisttohexstring(data.sublist(5, 9));
                  eventBus.fire(ChipReadEvent(true));
                  break;
                case 0x03: //um2
                  chipPageData[1] = intlisttohexstring(data.sublist(5, 7));
                  chipPageData[2] = intlisttohexstring(data.sublist(7, 9));
                  chipPageData[3] = intlisttohexstring(data.sublist(9, 11));
                  chipPageData[4] = intlisttohexstring(data.sublist(11, 13));
                  eventBus.fire(ChipReadEvent(true));
                  break;
              }
              break;
            case 0x4d:
              switch (data[data.length - 2]) {
                case 1:
                  chipPageData[0] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 2:
                  chipPageData[1] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 3:
                  List<int> rlist = [];
                  rlist = List.from(data.sublist(5, data.length - 3));
                  rlist = List.from(rlist.reversed);
                  rlist.add(data[data.length - 3]);
                  chipPageData[2] = intlisttohexstring(rlist);
                  // chipPageData[2] =
                  //     intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 4:
                  chipPageData[3] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 8:
                  chipPageData[4] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 9:
                  chipPageData[5] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 10:
                  chipPageData[6] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 11:
                  chipPageData[7] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 12:
                  chipPageData[8] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 13:
                  chipPageData[9] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 14:
                  chipPageData[10] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 15:
                  chipPageData[11] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 18:
                  chipPageData[12] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 29:
                  chipPageData[13] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
                case 30:
                  chipPageData[14] =
                      intlisttohexstring(data.sublist(5, data.length - 2));
                  break;
              }

              debugPrint("收到第${data[data.length - 2]}页数据");
              eventBus.fire(ChipReadEvent(true));
              break;
            case 0x1c:
              debugPrint("收到IC,block$_icreadpage页数据$data");
              chipPageData[_icreadpage] =
                  intlisttohexstring(data.sublist(6, data.length - 1));
              eventBus.fire(ChipReadEvent(true));
              break;
            case 0x8a:
              print("8a 页数据");
              chipPageData[data[5]] =
                  intlisttohexstring(data.sublist(6, data.length - 1));
              print(chipPageData[data[5]]);
              eventBus.fire(ChipReadEvent(true));
              break;
          }
        }
        break;
      case 6: //标准命令状态 比如 获取版本号
        switch (data[3]) {
          case 0x10:
            var temp = data.sublist(4, data.length - 1);
            appData.mcVer = intToAscii(temp);
            progressChip.getbtmac();
            eventBus.fire(MCGetVerEvent(true));
            break;
          case 0x12: //D4A99F2F936D
            var temp = data.sublist(4, data.length - 1);
            mcbtmac = intlisttohexstring(temp);
            print(mcbtmac);
            //mqttManage.serverConnect();
            break;
          default:
            var temp = data.sublist(5, 10);
            appData.mcVer = intToAscii(temp);
            appData.mcVer = appData.mcVer.replaceAll(".", "");
            progressChip.getbtmac();
            eventBus.fire(MCGetVerEvent(true));

            break;
        }
        print("appData.mcVer:${appData.mcVer}");
        break;
      case 7: //直接处理数据  判断状态

        if (data[7] == 1) {
          eventBus.fire(ChipReadEvent(true));
        } else {
          eventBus.fire(ChipReadEvent(false));
        }

        break;
      case 8: //解码
        if (data[0] == 0xa5 && data[1] == 0xff) {
          //解码状态

          eventBus.fire(ChipReadEvent(false));
        } else {
          debugPrint("解码成功");
          progressChipData(data); //解析芯片数据
          eventBus.fire(ChipReadEvent(true));
        }
        break;
      case 9: //无需处理数据

        if (data[4] == _currentPage) {
          ////print("成功");

          eventBus.fire(ChipReadEvent(true));
        } else {
          eventBus.fire(ChipReadEvent(false));
        }
        _progressDataState = 100;
        break;
      case 10: //拷贝状态
        switch (chipnamebyte[0]) {
          case 0x4c:
          case 0x8a:
          case 0x13:
          case 0x12:
          case 0x11:
          case 0xd5:
            _progressDataState = 11;
            break;
          default:
        }
        if (data[7] == _currentPage) {
          //  appData.speakText("成功!");

          eventBus.fire(ChipReadEvent(true));
        } else {
          // appData.speakText("失败,请检查后再试吧!");
          eventBus.fire(ChipReadEvent(false));
        }
        break;
      case 11: //IC全读
        if (data[4] != _currentPage) {
          if (data[2] == _currentPage && _icreadpage == 64) {
            if (data[4] != 0) {
              eventBus.fire(ChipReadEvent(false));
            } else {
              eventBus.fire(ChipReadEvent(true));
            }
          } else {
            eventBus.fire(ChipReadEvent(false));
          }
        } else {
          for (var i = 0; i < data[5]; i++) {
            chipPageData[_icreadpage] =
                intlisttohexstring(data.sublist(8 + i * 18, 8 + i * 18 + 16));
            _icreadpage++;
          }
        }
        break;
      case 12: //IC扇区读

        if (data[4] != _currentPage) {
          eventBus.fire(ChipReadEvent(false));
        } else {
          if (data.length <= 6) {
            eventBus.fire(ChipReadEvent(true));
          } else {
            for (var i = 0; i < 4; i++) {
              if (data[7] == 0x01) {
                chipPageData[_icreadpage * 4 + i] = intlisttohexstring(
                    data.sublist(8 + 16 * i, 8 + 16 * (i + 1)));
              }
            }
            eventBus.fire(ChipReadEvent(true));
          }
        }
        _progressDataState = 100;
        break;

      default:
        debugPrint("未知的数据处理状态$_progressDataState:");
        debugPrint("data");
        break;
    }
  }

//处理网络解码的数据
  void progressNetChipData(Map data) {
    switch (chipnamebyte[0]) {
      case 0x4d:
        if (data["queue_length"] != null) {
          servertimer = data["queue_length"] * 20 + 50;
          eventBus.fire(ChipReadEvent(true));
        } else {
          if (data["crack_status"] != null) {
            if (data["crack_status"]) {
              chipPageData[0] = intlisttohexstring(List.from(data["key"]));
              password = List.from(data["key"]);
              mqttManage.serverDisconent();
              eventBus.fire(ChipReadEvent(true));
            } else {
              mqttManage.serverDisconent();
              eventBus.fire(ChipReadEvent(false));
            }
          }
        }
        break;
      case 0x46:
        if (data["queue_length"] != null) {
          servertimer = data["queue_length"] * 10 + 20;
          eventBus.fire(ChipReadEvent(true));
        }
        if (data["crack_status"] != null) {
          if (data["crack_status"]) {
            chipPageData[0] =
                intlisttohexstring(List.from(data["encryption_key"]));
            password = List.from(data["encryption_key"]);
            mqttManage.serverDisconent();
            eventBus.fire(ChipReadEvent(true));
          } else {
            mqttManage.serverDisconent();
            eventBus.fire(ChipReadEvent(false));
          }
        }
        break;
    }
  }

//获取签名
  void getsign() {
    //获取当前芯片的签名
    _progressDataState = 1; //将状态标记为 接收签名

    if (chipname != "4600") {
      //46自动 返回签名 不需要发送命令
      signdata.clear();
      signdata = [];
      sign4dData = {
        "crack_type": "4d_dst40",
        "dst40_signatures": {"sig1": [], "sig2": [], "sig3": [], "sig4": []}
      };
      sendcmd(chipnamebyte, cmds.collectDataOK, []);
    }
  }

//进入采集页面
  void chipCollection() {
    _progressDataState = 7; //接收的数据为 进入数据采集页面
    sendcmd(chipnamebyte, cmds.inCollectPage, []);
  }

//采集状态
  void collectionChipState() {
    _progressDataState = 7;
    sendcmd(chipnamebyte, cmds.collectData, []);
  }

//采集完成
  void collectionChipOk() {
    _progressDataState = 7;
    sendcmd(chipnamebyte, cmds.collectDataOK, []);
  }

//插入原来的钥匙
  void inoriginal() {
    _progressDataState = 7;
    sendcmd(chipnamebyte, cmds.inputOriginlKey, []);
  }

//拷贝当前芯片
  void copyCurrentChip() {
    debugPrint("即将拷贝的芯片$chipnamebyte");
    _progressDataState = 10;
    switch (chipnamebyte[0]) {
      case 0x46:
        _currentPage = 0x07;
        sendcmd(chipnamebyte, 0x07, []);
        break;
      case 0x4d:
        _currentPage = 0x02;
        sendcmd(chipnamebyte, 0x02, []);
        break;
      case 0x8a:
        _currentPage = 0x01;
        sendcmd(chipnamebyte, 0x01, []);
        break;
      case 0x4c:
        _currentPage = 0x01;
        sendcmd(chipnamebyte, 0x01, []);
        break;
      case 0x13:
      case 0x11:
      case 0x12:
        _currentPage = 0x01;
        sendcmd([0xd5, 0x01], 0x01, []);
        break;
      case 0x48:
        _progressDataState = 9;
        _currentPage = 0xa0;
        senddata([0x48], _currentPage, []);
        break;
      default:
        sendcmd(chipnamebyte, 2, []);
        break;
    }
  }

//写入当前数据  writemodel 写入的模式  默认明文 model生成(true)还是编辑(false)

  void writeChipData(int page,
      {bool writemodel = false,
      bool model = false,
      int icwritemodel = 0}) async {
    _progressDataState = 9;
    List<int> temp = [];
    debugPrint("$chipname写入第$page页");
    switch (chipnamebyte[0]) {
      case 0x8a:
        _currentPage = 0x04;
        temp.add(page);
        temp.addAll(stringHexToIntList(chipPageData[page]));
        await senddata([0x06], _currentPage, temp);

        // _progressDataState = 10;
        // if (chipPageData.isEmpty) {
        //   _currentPage = 0x03;
        //   await sendcmd(chipnamebyte, 0x03, []);
        // } else {
        //   _currentPage = 0x02;
        //   temp.addAll(stringHexToIntList(chipPageData[0]));
        //   await sendcmd(chipnamebyte, 0x02, temp);
        // }
        break;
      case 0x46:
        switch (page) {
          case 0: //写入第0页ID
            break;
          case 1: //写入第一页
            if (model) {
              //如果是生成模式
              temp.addAll([0x4D, 0x49, 0x4B, 0x52]);
              temp.addAll(stringHexToIntList(chipPageData[2]));
              _currentPage = 0x15;
            } else {
              if (writemodel) {
                temp.addAll(stringHexToIntList(chipPageData[0]));
                temp.addAll(stringHexToIntList(chipPageData[2]));
                _currentPage = 0x25;
              } else {
                temp.addAll(stringHexToIntList(chipPageData[0]).sublist(2));
                temp.addAll(stringHexToIntList(chipPageData[2]));
                _currentPage = 0x15;
              }
            }
            await senddata(chipnamebyte.sublist(0, 1), _currentPage, temp);
            break;
          case 2: //写入第二页
            if (writemodel) {
              temp.addAll(stringHexToIntList(chipPageData[0]));
              temp.addAll(stringHexToIntList(chipPageData[3]));
              _currentPage = 0x26;
            } else {
              temp.addAll(stringHexToIntList(chipPageData[0]).sublist(2));
              temp.addAll(stringHexToIntList(chipPageData[3]));
              _currentPage = 0x16;
            }
            await senddata(chipnamebyte.sublist(0, 1), _currentPage, temp);
            break;
          case 3: //写入第三页
            if (writemodel) {
              temp.addAll(stringHexToIntList(chipPageData[0]));
              temp.addAll(stringHexToIntList(chipPageData[4]));
              _currentPage = 0x27;
            } else {
              temp.addAll(stringHexToIntList(chipPageData[0]).sublist(2));
              temp.addAll(stringHexToIntList(chipPageData[4]));
              _currentPage = 0x17;
            }
            await senddata(chipnamebyte.sublist(0, 1), _currentPage, temp);
            break;
          case 4: //写入第四页
          case 5: //写入第五页
          case 6: //写入第六页
          case 7: //写入第七页
            if (writemodel) {
              temp.addAll(stringHexToIntList(chipPageData[0]));
              temp.addAll(stringHexToIntList(chipPageData[5]));
              temp.addAll(stringHexToIntList(chipPageData[6]));
              temp.addAll(stringHexToIntList(chipPageData[7]));
              temp.addAll(stringHexToIntList(chipPageData[8]));
              _currentPage = 0x23;
            } else {
              temp.addAll(stringHexToIntList(chipPageData[0]).sublist(2));
              temp.addAll(stringHexToIntList(chipPageData[5]));
              temp.addAll(stringHexToIntList(chipPageData[6]));
              temp.addAll(stringHexToIntList(chipPageData[7]));
              temp.addAll(stringHexToIntList(chipPageData[8]));
              _currentPage = 0x13;
            }
            await senddata(chipnamebyte.sublist(0, 1), _currentPage, temp);
            break;
        }
        break;
      case 0x48:
        _progressDataState = 9;
        _currentPage = 0x10 + page;
        debugPrint("chipPageData:$chipPageData");
        if (model) {
          temp.addAll(stringHexToIntList(chipPageData[page]));
        } else {
          switch (page) {
            case 0:
              temp.addAll(stringHexToIntList(chipPageData[6]));
              break;
            case 1:
              temp.addAll(stringHexToIntList(chipPageData[5]));
              break;
            case 2:
              String tedsa;
              temp.addAll(stringHexToIntList(chipPageData[0].substring(4)));
              print("temp:$temp");
              break;
            case 3:
              temp.addAll(stringHexToIntList(chipPageData[0].substring(0, 4)));
              print("temp:$temp");
              break;
            case 4:
              temp.addAll(stringHexToIntList(chipPageData[12]));
              break;
            case 5:
              temp.addAll(stringHexToIntList(chipPageData[11]));
              break;
            case 6:
              temp.addAll(stringHexToIntList(chipPageData[10]));
              break;
            case 7:
              temp.addAll(stringHexToIntList(chipPageData[9]));
              break;
            case 8:
              temp.addAll(stringHexToIntList(chipPageData[8]));
              break;
            case 9:
              temp.addAll(stringHexToIntList(chipPageData[7]));
              break;
            case 10:
              temp.addAll(stringHexToIntList(chipPageData[13].substring(4)));
              break;
            case 11:
              temp.addAll(stringHexToIntList(chipPageData[13].substring(0, 4)));
              break;
            case 12:
              temp.addAll(stringHexToIntList(chipPageData[4]));
              break;
            case 13:
              temp.addAll(stringHexToIntList(chipPageData[3]));
              break;
            case 14:
              temp.addAll(stringHexToIntList(chipPageData[2]));
              break;
            case 15:
              temp.addAll(stringHexToIntList(chipPageData[1]));
              break;
            case 16: //全写
              _currentPage = 0XA1;
              temp.addAll(stringHexToIntList(chipPageData[6]));
              temp.addAll(stringHexToIntList(chipPageData[5]));
              temp.addAll(stringHexToIntList(chipPageData[0].substring(4)));
              temp.addAll(stringHexToIntList(chipPageData[0].substring(0, 4)));
              temp.addAll(stringHexToIntList(chipPageData[12]));
              temp.addAll(stringHexToIntList(chipPageData[11]));
              temp.addAll(stringHexToIntList(chipPageData[10]));
              temp.addAll(stringHexToIntList(chipPageData[9]));
              temp.addAll(stringHexToIntList(chipPageData[8]));
              temp.addAll(stringHexToIntList(chipPageData[7]));
              temp.addAll(stringHexToIntList(chipPageData[13].substring(4)));
              temp.addAll(stringHexToIntList(chipPageData[13].substring(0, 4)));
              temp.addAll(stringHexToIntList(chipPageData[4]));
              temp.addAll(stringHexToIntList(chipPageData[3]));
              temp.addAll(stringHexToIntList(chipPageData[2]));
              temp.addAll(stringHexToIntList(chipPageData[1]));
              break;
          }
        }
        debugPrint("temp:$temp");
        await senddata(chipnamebyte.sublist(0, 1), _currentPage, temp);
        break;
      case 0x4d:
        if (writemodel) {
          //72G生成模式
          temp.addAll(p172g);
          var rng = Random(); //随机数生成类
          List<int> rlist = [];
          rlist = List.from(stringHexToIntList(
              chipPageData[1].substring(0, chipPageData[1].length - 1)));

          while (rlist[0] == 0x00 || rlist[0] == 0xff) {
            rlist[0] = rng.nextInt(0xfe);
          }
          // rlist = List.from(stringHexToIntList(
          // chipPageData[2].substring(0, chipPageData[2].length - 1)));
          // rlist = List.from(rlist.reversed);
          temp.addAll(rlist);
          // print(rlist);
          _currentPage = 0x06;
          _progressDataState = 10;
          await sendcmd([0x4d, 0x72], 0x06, temp);
        } else {
          temp.add(page);
          debugPrint("${chipPageData[14].substring(0, 4)}");
          if (model == true) {
            temp.addAll(
                stringHexToIntList(old4DPW.substring(0, old4DPW.length - 1)));
          } else {
            temp.addAll(stringHexToIntList(
                chipPageData[0].substring(0, chipPageData[0].length - 1)));
          }
          if (chipPageData[14].substring(0, 4) == "4600" ||
              chipPageData[14].substring(0, 4) == "0046") {
            temp.add(1);
          } else {
            temp.add(0);
          }
          switch (page) {
            case 1:
              temp.addAll(stringHexToIntList(
                  chipPageData[0].substring(0, chipPageData[0].length - 1)));
              break;
            case 2:
              temp.addAll(stringHexToIntList(
                  chipPageData[1].substring(0, chipPageData[1].length - 1)));
              break;
            case 3:
              List<int> rlist = [];
              rlist = List.from(stringHexToIntList(
                  chipPageData[2].substring(0, chipPageData[2].length - 1)));
              rlist = List.from(rlist.reversed);
              temp.addAll(rlist);
              // temp.addAll(stringHexToIntList(
              //     chipPageData[2].substring(0, chipPageData[2].length - 1)));
              break;
            case 4:
              List<int> rlist = [];
              rlist = List.from(stringHexToIntList(
                  chipPageData[3].substring(0, chipPageData[3].length - 1)));
              rlist = List.from(rlist.reversed);
              temp.addAll(rlist);
              // temp.addAll(stringHexToIntList(
              //  chipPageData[3].substring(0, chipPageData[3].length - 1)));
              break;
            case 8:
              temp.addAll(stringHexToIntList(
                  chipPageData[4].substring(0, chipPageData[4].length - 1)));
              break;
            case 9:
              temp.addAll(stringHexToIntList(
                  chipPageData[5].substring(0, chipPageData[5].length - 1)));
              break;
            case 10:
              temp.addAll(stringHexToIntList(
                  chipPageData[6].substring(0, chipPageData[6].length - 1)));
              break;
            case 11:
              temp.addAll(stringHexToIntList(
                  chipPageData[7].substring(0, chipPageData[7].length - 1)));
              break;
            case 12:
              temp.addAll(stringHexToIntList(
                  chipPageData[8].substring(0, chipPageData[8].length - 1)));
              break;
            case 13:
              temp.addAll(stringHexToIntList(
                  chipPageData[9].substring(0, chipPageData[9].length - 1)));
              break;
            case 14:
              temp.addAll(stringHexToIntList(
                  chipPageData[10].substring(0, chipPageData[10].length - 1)));
              break;
            case 15:
              temp.addAll(stringHexToIntList(
                  chipPageData[11].substring(0, chipPageData[11].length - 1)));
              break;
            case 18:
              temp.addAll(stringHexToIntList(
                  chipPageData[12].substring(0, chipPageData[12].length - 1)));
              break;
            case 29:
              temp.addAll(stringHexToIntList(
                  chipPageData[13].substring(0, chipPageData[13].length - 1)));
              break;
            case 30:
              // List<int> rlist = [];
              // rlist = List.from(stringHexToIntList(
              //     chipPageData[14].substring(0, chipPageData[14].length - 1)));
              // rlist = List.from(rlist.reversed);
              // debugPrint("rlist:${intListToHexStringList(rlist)}");
              // temp.addAll(rlist);
              debugPrint("temp:${intListToHexStringList(temp)}");
              debugPrint("temp:${intListToHexStringList(temp)}");
              temp.addAll(stringHexToIntList(
                  chipPageData[14].substring(0, chipPageData[14].length - 1)));
              break;
          }
          debugPrint("temp:${intListToHexStringList(temp)}");
          _currentPage = 0x07;
          // eventBus.fire(ChipReadEvent(true));
          await senddata([0x60], _currentPage, temp);
        }
        break;
      case 0x1c:
        switch (icwritemodel) {
          case 1:
            _currentPage = 0x02;
            temp.add(page);
            temp.addAll(
                stringHexToIntList(chipPageData[(page ~/ 4 + 1) * 4 - 1])
                    .sublist(0, 6));
            temp.addAll(stringHexToIntList(chipPageData[page]));
            await senddata([0x22], _currentPage, temp);
            break;
          case 2: //仅写当前扇区

            _currentPage = 0x06;
            _icreadpage = page;
            temp.add(0x01);
            temp.add(page); //扇区号
            temp.add(0x01); //密码A 0x00 密码B 0x01
            temp.addAll(stringHexToIntList(chipPageData[_icreadpage * 4 + 3])
                .sublist(10));
            for (var i = 0; i < 4; i++) {
              temp.addAll(
                  stringHexToIntList(chipPageData[_icreadpage * 4 + i]));
            }
            // print(intListToHexStringList(temp));
            await senddata([0x22], _currentPage, temp);
            break;
          case 3: //全写
            _currentPage = 0x04;
            for (var num = 0; num < 1; num++) {
              temp.addAll([8, 8 * 17]);
              for (var i = 0; i < 8; i++) {
                temp.add(i + num * 8);
                temp.addAll(stringHexToIntList(chipPageData[i + num * 8]));
              }
              temp.add(0);
              await senddata([0x22], _currentPage, temp);
              //   await Future.delayed(const Duration(seconds: 2)); //等待两秒继续发送
            }

            break;
        }

        break;
      default:
        EasyLoading.showError("写入未知芯片:$chipname");
        break;
    }
  }

//读取数据 readmodel 读取模式明文(false) 加密(true)
//page 读取的页 ic代表读取的块
//读芯片
  void readChipData2(int page, {bool readmodel = false, int icreadmodel = 0}) {
    _progressDataState = 4;
    debugPrint("readPage:$page");
    debugPrint("readmodel:$readmodel");
    switch (chipnamebyte[0]) {
      case 0x46:
        switch (page) {
          case 0:
            if (readmodel) {
              _currentPage = 0x22;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]));
            } else {
              _currentPage = 0x12;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]).sublist(2));
            }
            break;
          case 1:
          case 2:
            if (readmodel) {
              _currentPage = 0x22;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]));
            } else {
              _currentPage = 0x12;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]).sublist(2));
            }
            break;
          case 3:
            if (readmodel) {
              _currentPage = 0x20;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]));
            } else {
              _currentPage = 0x10;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]).sublist(2));
            }
            break;
          case 4:
          case 5:
          case 6:
          case 7:
            if (readmodel) {
              _currentPage = 0x21;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]));
            } else {
              _currentPage = 0x11;
              senddata(chipnamebyte.sublist(0, 1), _currentPage,
                  stringHexToIntList(chipPageData[0]).sublist(2));
            }
            break;
        }
        break;
      case 0x48:
        switch (page) {
          case 1:
            _currentPage = 0x02;
            senddata(chipnamebyte.sublist(0, 1), _currentPage, []);
            break;
          case 2:
            _currentPage = 0x01;
            senddata(chipnamebyte.sublist(0, 1), _currentPage, []);
            break;
          case 3:
            _currentPage = 0x03;
            senddata(chipnamebyte.sublist(0, 1), _currentPage, []);
            break;

          default:
        }
        break;
      case 0x4d:
        _currentPage = 0x06;
        senddata([0x60], _currentPage, [page]);
        break;
      case 0x1c:
        switch (icreadmodel) {
          case 1: //全读
            _progressDataState = 11;
            _currentPage = 0x03; //全包命令0x03
            _icreadpage = page;
            senddata([0x22], _currentPage, []); //全读
            break;
          case 2: //按扇区读
            _progressDataState = 12;
            _currentPage = 0x05;
            _icreadpage = page;
            List<int> temp = [];
            temp.add(1); //扇区个数

            temp.add(_icreadpage);
            temp.addAll([0x01]); //密码选择A 0x00,密码选择B:0x01
            temp.addAll(stringHexToIntList(chipPageData[_icreadpage * 4 + 3])
                .sublist(10));

            senddata([0x22], _currentPage, temp); //全读
            break;
          case 3: //按页读

            _currentPage = 0x01;
            _icreadpage = page;
            List<int> temp = [];
            temp.add(page);
            temp.addAll(
                stringHexToIntList(chipPageData[(page ~/ 4 + 1) * 4 - 1])
                    .sublist(0, 6));
            temp.addAll(
                stringHexToIntList(chipPageData[(page ~/ 4 + 1) * 4 - 1])
                    .sublist(11));
            senddata([0x22], _currentPage, temp); //分块读
            break;
          case 4: //按扇区读 传入的是扇区
            _progressDataState = 12;
            _currentPage = 0x05;
            _icreadpage = page;
            List<int> temp = [];
            temp.add(1); //扇区个数

            temp.add(_icreadpage);
            temp.addAll([0x01]); //密码选择A 0x00,密码选择B:0x01
            temp.addAll(stringHexToIntList(chipPageData[_icreadpage * 4 + 3])
                .sublist(10));

            senddata([0x22], _currentPage, temp); //全读
            break;
        }

        break;
      case 0x8a:
        _currentPage = 0x03;
        senddata([0x06], _currentPage, [page]);
        break;
      default:
    }
  }

  void chipUnlock(int page) async {
    List<int> temp = [];
    _progressDataState = 9;

    switch (chipnamebyte[0]) {
      case 0x48:
// 手机发送 A6-FF-07-48-21-AA-AA-AA-AA-BD
// 设备回应 E5-FF-03-48-21-50  解锁成功
        _currentPage = 0x21;
        if (chipPageData[13] == "00000000") {
          debugPrint("尝试默认解锁");
          await senddata(
              chipnamebyte.sublist(0, 1), 0X21, [0xaa, 0xaa, 0xaa, 0xaa]);
        } else {
          await senddata(chipnamebyte.sublist(0, 1), _currentPage,
              stringHexToIntList(chipPageData[13]));
        }
        break;
      case 0x4d:
        _currentPage = 0x05;
        await senddata([0x60], 0x05, temp);
        break;
    }
  }

  void chipLock(int page) async {
    List<int> temp = [];
    _progressDataState = 9;
    switch (chipnamebyte[0]) {
      case 0x4d:
        temp.add(page);
        _currentPage = 0x08;
        temp.addAll(stringHexToIntList(
            chipPageData[0].substring(0, chipPageData[0].length - 1)));
        await senddata([0x60], _currentPage, temp);
        break;
      case 0x8a:
        _currentPage = 0x05;
        temp.add(page);
        await senddata([0x06], _currentPage, temp);
        break;
    }
  }

//生成芯片数据加载
  void creatChipLoadData(Map data, {int seleindex = 0}) {
    chipnamebyte = List.from(data["chipnamebyte"]);
    chipname = data["chipname"];
    chipPageData = []; //清除旧数据  加载生成的数据
    switch (chipnamebyte[0]) {
      case 0x4d:
        var rng = Random(); //随机数生成类
        int index = 0;
        switch (data["id"]) {
          case 50:
            index = rng.nextInt(data["data"][0].length);
            chipPageData.add(data["data"][0][index]); //pw
            chipPageData.add(data["data"][1]); //用户
            chipPageData.add(data["data2"][index]); //ID
            chipPageData.add(data["data"][2][index]); //密码
            for (var i = 3; i < data["data"].length; i++) {
              chipPageData.add(data["data"][i]);
            }
            break;
          case 51:
          case 52:
            chipPageData.add(data["keylist"][seleindex]);
            chipPageData.add(data["data"][1]);
            chipPageData
                .add(data["data2"][rng.nextInt(data["data2"].length - 1)]);
            for (var i = 2; i < data["data"].length; i++) {
              chipPageData.add(data["data"][i]);
            }
            break;
          case 73: //72G 芯片
            p172g.clear();
            p172g.addAll(stringHexToIntList(data["keylist"][seleindex]));
            break;
          default:
            debugPrint("${data["data"]}");
            for (var i = 0; i < 2; i++) {
              chipPageData.add(data["data"][i]);
            }
            chipPageData
                .add(data["data2"][rng.nextInt(data["data2"].length - 1)]);
            for (var i = 2; i < data["data"].length; i++) {
              chipPageData.add(data["data"][i]);
            }
            break;
        }
        break;
      default:
        chipPageData.clear();
        for (var i = 0; i < data["data"].length; i++) {
          chipPageData.add(data["data"][i]);
        }
        break;
    }
  }

  void initstep({bool needclearchip = true}) {
    //初始化识别流程
    _progressDataState = 0;

    if (needclearchip) {
      chipname = "";
      chipnamebyte = [];
    }
    chipdata = [];
    chipPageData = [];
    signdata = [];
    password = [];
    copy = false;
    sign4dData = {
      "crack_type": "4d_dst40",
      "dst40_signatures": {"sig1": [], "sig2": [], "sig3": [], "sig4": []}
    };
    sign46Data = {
      "crack_type": "46",
      "signature_46": {
        "sig1": [],
        "sig2": [],
        "sig3": [],
        "sig4": [],
        "sig5": [],
        "sig6": []
      },
    };
  }

  void sendcmdtoserver() async //发送签名数据到服务器
  {
    switch (chipnamebyte[0]) {
      case 0x4d:
        mqttManage.serverSendData(sign4dData);
        break;
      case 0x46:
        mqttManage.serverSendData(sign46Data);
        break;
      default:
        debugPrint("未知芯片类型");
        break;
    }
  }

//解码芯片 服务返回数据后 发送到拷贝机进行解码
  void encodeChip() {
    //解码后服务器返回的是芯片数据
    _progressDataState = 7;
    switch (chipnamebyte[0]) {
      case 0x4d:
        sendcmd(chipnamebyte, 0x04, password);
        break;
      case 0x46:
        _progressDataState = 0;
        sendcmd(chipnamebyte, 0x0a, password);
        break;
      default:
    }
  }

  //关闭网络解码
  void netcloss() {
    socketManage.socketClose();
  }

//修改芯片数据(芯片编辑页面的数据)
  Future<void> changeChipData(var data) async {
    _progressDataState = 4;
    switch (chipnamebyte[0]) {
      case 0x48:
        await senddata(chipnamebyte.sublist(0, 1), data["word"], data["data"]);
        break;
      case 0x4d:
        await senddata(chipnamebyte.sublist(0, 1), data["word"], data["data"]);
        break;
    }
  }

//读取芯片数据 编辑页面
  // Future<void> readChipData(var data) async {
  //   _progressDataState = 4;
  //   switch (chipnamebyte[0]) {
  //     case 0x48:
  //       await senddata(chipnamebyte.sublist(0, 1), data["word"], data["data"]);
  //       break;
  //     case 0x46:
  //       await senddata(chipnamebyte.sublist(0, 1), data["word"], data["data"]);
  //       break;
  //     case 0x1c:
  //       await senddata(chipnamebyte.sublist(0, 1), data["word"], data["data"]);
  //       break;
  //   }
  // }

//48解锁
//   Future<void> unlockChipData() async {
//     _progressDataState = 9;
//     switch (chipnamebyte[0]) {
//       case 0x48:
// // 手机发送 A6-FF-07-48-21-AA-AA-AA-AA-BD
// // 设备回应 E5-FF-03-48-21-50  解锁成功
//         if (chipPageData[13]["PIN"] == "00000000") {
//           debugPrint("尝试默认解锁");
//           await senddata(
//               chipnamebyte.sublist(0, 1), 0X21, [0xaa, 0xaa, 0xaa, 0xaa]);
//         } else {
//           await senddata(chipnamebyte.sublist(0, 1), 21,
//               stringHexToIntList(chipPageData[13]["PIN"]));
//         }
//         break;
//     }
//   }
  String getcarname(String pw, String name) {
    for (var i = 0; i < appData.chipData.length; i++) {
      if (appData.chipData[i]["chipnamebyte"][0] == 0x4d) {
        if (appData.chipData[i]["data"][0] is List) {
          if (appData.chipData[i]["data"][0].indexOf(pw.toUpperCase()) > -1 &&
              appData.chipData[i]["data"][1].toString().toUpperCase() ==
                  name.toUpperCase()) {
            for (var j = 0; j < appData.chipCarList.length; j++) {
              for (var k = 0; k < appData.chipCarList[j]["sub"].length; k++) {
                for (var l = 0;
                    l < appData.chipCarList[j]["sub"][k]["content"].length;
                    l++) {
                  if (appData.chipCarList[j]["sub"][k]["content"][l]["id"] ==
                      appData.chipData[i]["id"]) {
                    return appData.chipCarList[j]["sub"][k]["content"][l]
                        ["name"];
                  }
                }
              }
            }
          }
        } else {
          if (appData.chipData[i]["data"][0].toString().toUpperCase() ==
                  pw.toUpperCase() &&
              appData.chipData[i]["data"][1].toString().toUpperCase() ==
                  name.toUpperCase()) {
            for (var j = 0; j < appData.chipCarList.length; j++) {
              for (var k = 0; k < appData.chipCarList[j]["sub"].length; k++) {
                for (var l = 0;
                    l < appData.chipCarList[j]["sub"][k]["content"].length;
                    l++) {
                  if (appData.chipCarList[j]["sub"][k]["content"][l]["id"] ==
                      appData.chipData[i]["id"]) {
                    return appData.chipCarList[j]["sub"][k]["content"][l]
                        ["name"];
                  }
                }
              }
            }
          }
        }
      }
    }
    if (chipname == "4D72" || chipname == "4d72") {
      return "丰田凌志";
    }
    return "未知";
  }

  setSuperChip(int model) {
    _progressDataState = 9;
    _currentPage = 1;
    senddata([0X75], 0X01, [model]);
  }
}

ProgressChip progressChip = ProgressChip();

import 'package:flutter/material.dart';
import 'package:magictank/appdata.dart';
import 'package:magictank/cncpage/basekey.dart';

import 'package:magictank/cncpage/bluecmd/sendcmd.dart';
import 'package:magictank/convers/convers.dart';

import '../../alleventbus.dart';
import '../../generated/l10n.dart';

List<int> receivedata = [];
// 自定义事件

class CNCversion {
  int version = 0;
  int verPCB = 0;
  int verJG = 0;
  int appversion = 0;
  int sn = 0;
  int lcdVersion = 0;
  int lcdPCB = 0;
  int lcdJG = 0;
  String ran = "";
  String binbase64 = "";
  String w = "";
  String ranbase64 = "";
  int state = 0; //数控机当前状态
  String iapSn = "";
  int fixtureType = 21;
  int bldcSpeed = 0;
  int cutSpeed = 0;
  int xdr = 0;
  int beepSwitch = 0;
  int processstate = 0;

  clear() {
    version = 0;
    verPCB = 0;
    verJG = 0;
    appversion = 0;
    sn = 0;
    lcdVersion = 0;
    lcdPCB = 0;
    lcdJG = 0;
    ran = "";
    binbase64 = "";
    w = "";
    ranbase64 = "";
    state = 0; //数控机当前状态
    iapSn = "";
    fixtureType = 21;
    bldcSpeed = 0;
    cutSpeed = 0;
    xdr = 0;
    beepSwitch = 0;
    processstate = 0;
  }
}

class Iapack {
  bool state = false; //是否收到ACK
  List<int> data = []; //ACK携带的数据
}

class Iapcmd {}

class Rframe {
  late int crc = 0;
  late int size = 0;
  late int iid = 0;
  late int total = 0;
  late int no = 0;
  late List<int> data = [];
}

class Sframe {
  late int crc = 0;
  late int size = 0;
  late int iid = 0;
  late int total = 0;
  late int no = 0;
  late List<int> data = [];
}

class Ack {
  //应答数据的参数
  late int crc = 0;
  late int size = 0;
  late int iid = -1;
  late int total = 0;
  late int no = 0;
}

List<int> sendAck = List.filled(127, 0);

Iapack iapack = Iapack();
Ack ack = Ack();
Rframe rfram = Rframe();
Sframe sfram = Sframe();
CNCversion cncVersion = CNCversion();
List<int> allframe = [];
int cTotal = 0; //
int cNol = 0;

// void prossdata(List<int> rd) {
//   receivedata.addAll(rd);
//   // if (receivedata.length > 4) {
//   //  ////print(receivedata);
//   for (var i = 0; i < receivedata.length; i++) {
//     if (receivedata[i] == 37 && i >= 21) {
//       //crc +size +iid+tail+iid+0+size+89+25=4+4+4+2+2+1+4
//       if (receivedata[i - 1] == 137 &&
//           receivedata[i - 3] == 0) //数据尾部格式： 0  size  89  25
//       {
//         debugPrint("收到帧数据");
//         // ////print(receivedata);
//         int size = receivedata[i - 2];
//         //////print(size);
//         if (size <= 126 + 4) {
//           List<int> fram = [];
//           int index = i - size + 1;
//           fram.addAll(receivedata.sublist(index, index + size - 4));
//           prossfram(fram);
//         }
//         receivedata.clear();
//         break;
//       }
//     } else if (receivedata[i] == 143 && i >= 14) {
//       if (receivedata[i - 1] == 19) //数据尾部格式： 0  size  89  25
//       {
//         debugPrint("应答数据数据");
//         List<int> ack = [];
//         int index = i - 14;
//         ack.addAll(receivedata.sublist(index, index + 14));
//         prossack(receivedata);
//         receivedata.clear();
//         break;
//       }
//     }
//   }

//   if (receivedata.length == 126) {
//     //数据
//     debugPrint("收到IAP数据");
//     receivedata.clear();
//   } else if (receivedata.length == 126 + 1) {
//     //命令
//     debugPrint("收到IAP命令");
//     ////print(receivedata);
//     if (receivedata[0] == 0xc0) {
//       //收到数据
//       ////print(receivedata[1]);
//       switch (receivedata[1]) {
//         case 0x10: //收到命令
//           cncVersion.version = hexToInt(receivedata.sublist(2, 6));
//           ////print(cncVersion.version);
//           cncVersion.verPCB = hexToInt(receivedata.sublist(6, 10));
//           ////print(cncVersion.verPCB);
//           cncVersion.verJG = hexToInt(receivedata.sublist(10, 14));
//           ////print(cncVersion.verJG);
//           cncVersion.sn = hexToInt(receivedata.sublist(14, 18));
//           ////print(cncVersion.sn);
//           debugPrint("发送应答信息");
//           updataack(receivedata.sublist(0, 126));
//           break;
//         case 11:
//         case 12:
//           break;
//         case 0x15: //非授权操作
//           break;
//       }
//       receivedata.clear();
//     } else if (receivedata[0] == 0x40) {
//       debugPrint("iap 应答数据");
//       ////print(receivedata);
//       iapack.state = true;
//       // receivedata.clear();
//     }
//   } else {
//     if (receivedata.length > 256) {
//       ////print(receivedata);
//       ////print(receivedata.length);
//       receivedata.clear();
//     }
//   }
//   // }
// }
//处理升级数据
void procesData(List<int> rd) {
  // print("命令模式:${cncVersion.processstate}");
  // print("命令数据:${rd}");
  procesCMDData(rd);
  // switch (cncVersion.processstate) {
  //   case 0:
  //     print("标准命令");
  //     procesCMDData(rd);
  //     break;
  //   case 1:
  //     print("升级命令");
  //     procesUpgradeData(rd);
  //     break;
  //   case 2:
  //     print("Ymodel命令");
  //     procesYmodeData(rd);
  //     break;
  //   default:
  // }
}

void procesUpgradeData(List<int> rd) {
  for (var i = 0; i < rd.length; i++) {
    if (rd[i] == 0XFF) {
      if (i - 126 >= 0 && rd[i - 126] == 0xc0) {
        debugPrint("收到IAP命令${rd[1]}");
        switch (rd[1]) {
          case 0x00:
            break;
          case 0x10: //收到命令
            cncVersion.version = hexToInt(rd.sublist(2, 6));
            ////print(cncVersion.version);
            cncVersion.verPCB = hexToInt(rd.sublist(6, 10));
            ////print(cncVersion.verPCB);
            cncVersion.verJG = hexToInt(rd.sublist(10, 14));
            ////print(cncVersion.verJG);
            cncVersion.sn = hexToInt(rd.sublist(14, 18));
            ////print(cncVersion.sn);
            debugPrint("发送应答信息");
            updataack(rd.sublist(0, 126));
            eventBus.fire(CNCConnectEvent(true));
            break;
          case 0x11:
            eventBus.fire(UpdatEvent(0));
            updataack(rd.sublist(0, 126));
            break;
          case 0x12:
            print("升级成功");
            eventBus.fire(UpdatEvent(1));
            updataack(rd.sublist(0, 126));
            break;
          case 0x13:
            // print(rd);
            cncVersion.iapSn = "";
            if (rd[2] == 96) {
              for (var i = 0; i < 12; i++) {
                cncVersion.iapSn =
                    cncVersion.iapSn + intToFormatStringHex(rd[3 + i]);
              }
            } else {
              for (var i = 0; i < 4; i++) {
                cncVersion.iapSn =
                    cncVersion.iapSn + intToFormatStringHex(rd[3 + i]);
              }
            }
            ////print(cncVersion.iapSn);
            eventBus.fire(ActivtEvent(0x13));
            updataack(rd.sublist(0, 126));
            break;
          case 0x14:
            //print("收到0x14");
            eventBus.fire(ActivtEvent(0x14));
            updataack(rd.sublist(0, 126));
            break;

          case 0x15: //非授权操作
            eventBus.fire(UpdatEvent(0));
            updataack(rd.sublist(0, 126));
            break;
          case 0x40:
            eventBus.fire(ActivtEvent(0x40));
            updataack(rd.sublist(0, 126));
            break;
        }
      }
      if (i - 126 >= 0 && rd[i - 126] == 0x40) {
        debugPrint("iap 应答数据$rd");

        iapack.state = true;
        // receivedata.clear();
      }
    }
  }
}

void procesYmodeData(List<int> rd) {
  if (rd.length == 1 && cncVersion.state == 5) //如果直收到1位并且 数控机的状态 5
  {
    eventBus.fire(YmodelEvent(rd[0]));
  }
}

List<int> receivecncbtdata = [];
void procesCMDData(List<int> rd) {
  // if (receivedata.length > 4) {
  //////print(receivedata);
  ////print(rd.length);

  if (rd.length == 1 && cncVersion.state == 5) //如果直收到1位并且 数控机的状态 5
  {
    eventBus.fire(YmodelEvent(rd[0]));
  }
  for (var i = 0; i < rd.length; i++) {
    if (rd[i] == 37 && i >= 21) {
      //crc +size +iid+tail+iid+0+size+89+25=4+4+4+2+2+1+4
      if (rd[i - 1] == 137 && rd[i - 3] == 0) //数据尾部格式： 0  size  89  25
      {
        int size = rd[i - 2];
        debugPrint("收到帧数据:$size");
        if (size <= 126 + 4) {
          List<int> fram = [];
          int index = i - size + 1;
          fram.addAll(rd.sublist(index, index + size - 4));
          prossfram(fram);
          //  return;
        } else {
          debugPrint("长度超标");
        }
        // rd.clear();
        //   break;
      }
    }
    if (rd[i] == 143 && i >= 13) {
      if (rd[i - 1] == 19) //数据尾部格式： 0  size  89  25
      {
        debugPrint("应答数据数据");
        List<int> ack = [];
        int index = i - 13;
        ack.addAll(rd.sublist(index, index + 13));
        prossack(ack);
        //   return;
        // rd.clear();
        //  break;
      }
    }

    if (rd[i] == 0XFF) {
      if (i - 126 >= 0 && rd[i - 126] == 0xc0) {
        debugPrint("收到IAP命令${rd[1]}");
        switch (rd[1]) {
          case 0x00:
            break;
          case 0x10: //收到命令
            cncVersion.version = hexToInt(rd.sublist(2, 6));
            ////print(cncVersion.version);
            cncVersion.verPCB = hexToInt(rd.sublist(6, 10));
            ////print(cncVersion.verPCB);
            cncVersion.verJG = hexToInt(rd.sublist(10, 14));
            ////print(cncVersion.verJG);
            cncVersion.sn = hexToInt(rd.sublist(14, 18));
            print("sn:${cncVersion.sn}");
            debugPrint("发送应答信息");
            updataack(rd.sublist(0, 126));
            eventBus.fire(CNCConnectEvent(true));
            break;
          case 0x11:
            eventBus.fire(UpdatEvent(0));
            updataack(rd.sublist(0, 126));
            break;
          case 0x12:
            eventBus.fire(UpdatEvent(1));
            updataack(rd.sublist(0, 126));
            break;
          case 0x13:
            // print(rd);
            cncVersion.iapSn = "";
            if (rd[2] == 96) {
              for (var i = 0; i < 12; i++) {
                cncVersion.iapSn =
                    cncVersion.iapSn + intToFormatStringHex(rd[3 + i]);
              }
            } else {
              for (var i = 0; i < 4; i++) {
                cncVersion.iapSn =
                    cncVersion.iapSn + intToFormatStringHex(rd[3 + i]);
              }
            }
            ////print(cncVersion.iapSn);
            eventBus.fire(ActivtEvent(0x13));
            updataack(rd.sublist(0, 126));
            break;
          case 0x14:
            //print("收到0x14");
            eventBus.fire(ActivtEvent(0x14));
            updataack(rd.sublist(0, 126));
            break;

          case 0x15: //非授权操作
            eventBus.fire(UpdatEvent(0));
            updataack(rd.sublist(0, 126));
            break;
          case 0x40:
            eventBus.fire(ActivtEvent(0x40));
            updataack(rd.sublist(0, 126));
            break;
        }
      }
      if (i - 126 >= 0 && rd[i - 126] == 0x40) {
        debugPrint("iap 应答数据$rd");

        iapack.state = true;
        // receivedata.clear();
      }
    }
    //  procesUpgradeData(rd);
  }
}

//处理一帧数据
void prossfram(List<int> rd) {
  ////print(rd);
  rfram.crc = hexToInt(rd.sublist(0, 4));
  rfram.size = hexToInt(rd.sublist(4, 8));
  rfram.iid = hexToInt(rd.sublist(8, 12));
  rfram.total = hexToInt(rd.sublist(12, 14));
  rfram.no = hexToInt(rd.sublist(14, 16));
  rfram.data = [];
  rfram.data.addAll(rd.sublist(4));

  if (rfram.size <= 128 && rfram.crc == getcrc32char(rfram.data)) {
    debugPrint("校验通过");
    if (rfram.total == 1) {
      //1帧即可传输完成所有数据
      //处理1帧数据;
      prosscmd(rfram.data.sublist(12));
      //prosscmd(rfram.data);
      debugPrint("处理一帧数据");
    } else {
      //多帧数据拼接
      debugPrint("处理多帧数据");
      allframe.addAll(rfram.data);
      if (rfram.total == rfram.no) {
        //接收完所有数据
        allframe.clear();
      }
    }
  } else {
    debugPrint("数据错误");
    //258145546
    ////print(rfram.data);
    ////print(rfram.crc);
    ////print(rfram.size);
    ////print(getcrc32char(rfram.data));
  }
}

//处理命令
void prosscmd(List<int> pack) {
  int cmd = pack[0];
  ////print(pack);
  debugPrint("收到命令:" + cmd.toString());
  switch (cmd) {
    case 0: //切削完成
      eventBus.fire(UpPageEvent(2));
      break;
    case 0X01:
      break;
    case 0X02: //读码返回的数据
      //      u16 A[8]= {200,320,320,380,260,200,320,200};
      //  u16 B[8]= {200,320,320,380,260,200,320,200};
      // eventBus.fire(ErroEvent(
      //   showmessage(1, pack.sublist(3)),
      //   pack[1],
      // ));

      baseKey.getkeynum(pack);
      eventBus.fire(UpPageEvent(1));
      break;
    case 0X03:
      if (pack[2] == 0) {
        eventBus.fire(CNCStateEvent(false));
      } else {
        eventBus.fire(CNCStateEvent(true));
      }
      break;
    case 0X05: //提示报错信息
      ////print(pack);
      if (pack[2] == 0) {
        //提示信息
        ////print(hexToInt(pack.sublist(3)));
        eventBus.fire(TipEvent(showmessage(0, pack.sublist(3))[0], pack[1],
            hexToInt(pack.sublist(3))));
      } else if (pack[2] == 1) {
        eventBus.fire(ErroEvent(
          showmessage(1, pack.sublist(3)),
          pack[1],
        ));
      }
      break;
    case 0x06: //模型加工换面 非导电装夹钥匙
      eventBus.fire(ChangeSideEvent(pack[2], pack[1], pack[3]));
      break;

    case 0x21:
      eventBus.fire(UpPageEvent(pack[1]));
      break;
    case 0x2a:
      ////print(pack.sublist(1, 5));
      appData.xDX = hexToInt(pack.sublist(1, 5)) ~/ 4;
      ////print(pack.sublist(5, 9));
      appData.xDY = ((hexToInt(pack.sublist(5, 9))) & 0xffff) ~/ 20;
      eventBus.fire(UpPageEvent(1));
      break; //af ff ff ff E8z
    case 0x8a: //复制完成
      eventBus.fire(UpPageEvent(1));
      break;
    case 0x8B: //切削完成
      eventBus.fire(UpPageEvent(1));
      break;
    case 0x85:
      if (pack[1] == 1) {
        eventBus.fire(SearchKeyEvent(false));
      } else {
        baseKey.getkeynum(pack);
        eventBus.fire(SearchKeyEvent(true));
      }
      break;
    case 0x9f: //预览复制的图形
      ////print(hexToInt(pack.sublist(4, 6)));
      if (pack[1] == 10) {
        eventBus.fire(PreViewEvent(
          pack[2], //side
          hexToInt(pack.sublist(3, 5)), //宽度
          hexToInt(pack.sublist(5, 7)), //厚度
          hexToInt(pack.sublist(7, 9)), //齿数
          hexToInt(pack.sublist(9, 11)), //长度
          hexToInt(pack.sublist(11, 13)), //深度
          hexListToIntList(pack.sublist(13), model: 2), //齿深
        ));
      } else {
        // eventBus.fire(PreViewEvent(pack[1], hexToInt(pack.sublist(2, 4)),
        //     hexToInt(pack.sublist(4, 6)), 0, 0, 0));

        eventBus.fire(PreViewEvent(pack[1], 0, 0, hexToInt(pack.sublist(2, 4)),
            0, 0, hexListToIntList(pack.sublist(4), model: 2)));
      }
      break;
    case 0x71:
    case 0x07:
      if (pack.length == 33) {
        debugPrint("有屏幕");
        cncVersion.version = hexToInt(pack.sublist(1, 5));
        cncVersion.verPCB = hexToInt(pack.sublist(5, 9));
        cncVersion.verJG = hexToInt(pack.sublist(9, 13));
        cncVersion.sn = hexToInt(pack.sublist(13, 17));
        cncVersion.lcdVersion = hexToInt(pack.sublist(17, 21));
        cncVersion.lcdPCB = hexToInt(pack.sublist(21, 25));
        cncVersion.lcdJG = hexToInt(pack.sublist(25, 29));

        int allType = hexToInt(pack.sublist(29));
        debugPrint("$allType");
        cncVersion.fixtureType = allType;
        print("sn:${cncVersion.sn}");
      } else {
        debugPrint("没屏幕");
        cncVersion.version = hexToInt(pack.sublist(1, 5));
        cncVersion.verPCB = hexToInt(pack.sublist(5, 9));
        cncVersion.verJG = hexToInt(pack.sublist(9, 13));
        cncVersion.sn = hexToInt(pack.sublist(13, 17));
        print("sn:${cncVersion.sn}");
        int allType = hexToInt(pack.sublist(17));
        debugPrint("$allType");
        cncVersion.fixtureType = allType;
      }
      // cncVersion.fixtureType = allType ~/ 10000;
      // cncVersion.bldcSpeed = allType % 10000 ~/ 1000;
      // cncVersion.cutSpeed = allType % 10000 % 1000 ~/ 100;
      // cncVersion.xdr = allType % 10000 % 1000 % 100 ~/ 10;
      // cncVersion.beepSwitch = allType % 10000 % 1000 % 100 % 10;
      ////print(cncVersion.fixtureType);
      ////print(cncVersion.sn);

      eventBus.fire(CNCGetVerEvent(true));
      break;
    case 0x73:
      eventBus.fire(PowerStateEvent(pack[1], pack[2]));
      break;
    case 0x7d:
      eventBus.fire(LcdUpBinStateEvent(pack[1]));
      break;
    case 0x7c:
      eventBus.fire(LcdUpKeyStateEvent(pack[1]));
      break;
  }
}

//处理收到的ACK
void prossack(List<int> pack) {
  debugPrint("ack");
  ////print(pack);
  ack.crc = hexToInt(pack.sublist(0, 4));
  ack.iid = hexToInt(pack.sublist(4, 6));
  debugPrint("iid:${ack.iid}");
  ack.no = hexToInt(pack.sublist(6, 8));
}

//弹窗信息提示
List<String> showmessage(int type, List<int> message) {
  List<String> temp = [];
  if (type == 0) {
    switch (hexToInt(message)) {
      case 1:
        break;
      case 2:
        temp.add('2');
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        temp.add('7');
        break;
      case 8:
        break;
      case 9:
        temp.add('9');
        break;
      case 10:
        break;
      case 11:
        break;
      case 12:
        temp.add('12');
        break;
      case 13:
        break;
      case 14:
        break;
      case 15:
        break;
      case 16:
        break;
      case 17:
        break;
      case 18:
        break;
      case 19:
        break;
      case 20:
        break;
      case 21:
        break;
      case 22:
        break;
      case 23:
        break;
      case 24:
        break;
      case 25:
        break;
      case 26:
        break;
      case 27:
        break;
      case 28:
        break;
      case 29:
        break;
      case 30:
        break;
      case 31:
        break;
      case 32:
        break;
      case 33:
        break;
      case 34:
        break;
      case 35:
        break;
      case 36:
        break;
      case 37:
        break;
      case 38:
        break;
    }
  } else if (type == 1) {
    debugPrint("报错信息:${hexToInt(message)}}");
    switch ((hexToInt(message) & 0xF0000000)) {
      case 0x10000000:
        temp.add(S.current.errcode1);
        break;
      case 0x20000000:
        temp.add(S.current.errcode2);
        break;
      case 0x30000000:
        temp.add(S.current.errcode3);
        break;
      case 0x40000000:
        temp.add(S.current.errcode4);
        break;
      case 0x50000000:
        temp.add(S.current.errcode5);
        break;
      case 0x60000000:
        temp.add(S.current.errcode6);
        break;
      case 0x70000000:
        temp.add(S.current.errcode7);
        break;
      case 0x80000000:
        temp.add(S.current.errcode8);
        break;
      case 0x90000000:
        temp.add(S.current.errcode9);
        break;
      case 0xa0000000:
        temp.add(S.current.errcode10);
        break;
      case 0xb0000000:
        temp.add(S.current.errcode11);
        break;
      case 0xc0000000:
        temp.add(S.current.errcode12);
        break;
      default:
        temp.add("${(hexToInt(message) & 0xF0000000)}");
        break;
    }
    switch ((hexToInt(message) & 0xF000000)) {
      case 0x01000000:
        temp.add(S.current.errcode13);
        break;
      case 0x02000000:
        temp.add(S.current.errcode14);
        break;
      case 0x03000000:
        temp.add(S.current.errcode15);
        break;
      default:
        temp.add("${(hexToInt(message) & 0xF000000)}");
        break;
    }
    switch ((hexToInt(message) & 0xF0000)) {
      case 0x010000:
        temp.add(S.current.errcode16);
        break;
      case 0x020000:
        temp.add(S.current.errcode17);
        break;
      case 0x040000:
        temp.add(S.current.errcode18);
        break;
      case 0x030000:
        temp.add(S.current.errcode19);
        break;
      default:
        temp.add("${(hexToInt(message) & 0xF0000)}");
        break;
    }
    switch ((hexToInt(message) & 0xFF)) {
      case 0:
        temp.add("");
        break;
      case 0x01:
        temp.add(S.current.errcode20);
        break;
      case 0x02:
        temp.add(S.current.errcode21);
        break;
      case 0x03:
        temp.add(S.current.errcode22);
        break;
      case 0x04:
        temp.add(S.current.errcode23);
        break;
      case 0x05:
        temp.add(S.current.errcode24);
        break;
      case 0x06:
        temp.add(S.current.errcode25);
        break;
      case 0x07:
        temp.add(S.current.errcode26);
        break;
      case 0x08:
        temp.add(S.current.errcode27);
        break;
      case 0x09:
        temp.add(S.current.errcode28);
        break;
      case 0x0A:
        temp.add(S.current.errcode29);
        break;
      case 0X0B:
        temp.add(S.current.errcode30);
        break;
      case 0X0C:
        temp.add(S.current.errcode31);
        break;
      case 0X0D:
        temp.add(S.current.errcode32);
        break;
      case 0X0E:
        temp.add(S.current.errcode33);
        break;
      case 0X0F:
        temp.add(S.current.errcode34);
        break;
      case 0X10:
        temp.add(S.current.errcode35);
        break;
      case 0X11:
        temp.add(S.current.errcode36);
        break;
      case 0X12:
        temp.add(S.current.errcode37);
        break;
      case 0X13:
        temp.add(S.current.errcode38);
        break;
      case 0X14:
        temp.add(S.current.errcode39);
        break;
      case 0X15:
        temp.add(S.current.errcode40);
        break;
      case 0X16:
        temp.add(S.current.errcode41);
        break;
      case 0X17:
        temp.add(S.current.errcode42);
        break;
      case 0X18:
        temp.add(S.current.errcode43);
        break;
      case 0X19:
        temp.add(S.current.errcode44);
        break;
      case 0X1A:
        temp.add(S.current.errcode45);
        break;
      case 0X1B:
        temp.add(S.current.errcode46);
        break;
      case 0X1C:
        temp.add(S.current.errcode47);
        break;
      case 0X1D:
        temp.add(S.current.errcode48);
        break;
      case 0X1E:
        temp.add(S.current.errcode49);
        break;
      case 0X1F:
        temp.add("READ_KEY");
        break;
      case 0X20:
        temp.add("CLAMP_KEY");
        break;
      default:
        temp.add("未知错误${hexToInt(message)}");
        break;
    }
  }
  return temp;
}

Future<bool> getakc() async {
  //
  if (ack.iid == rfram.iid) {
    return true;
  }
  return false;
}

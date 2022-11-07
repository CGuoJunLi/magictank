// late int crc;
// late int size;
// late int iid;
// late int Total;
// late int No;
// late List<int> data;

import 'package:flutter/widgets.dart';
import 'package:magictank/appdata.dart';

import 'package:magictank/cncpage/bluecmd/cncbt4_manganger.dart';

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/convers/convers.dart';

//包结构
//4位CRC +4位size+ 4位iid +2位total+ 2位no +data+ 0 +包大小(1位)+0x89+0x25
//
//传入是char
Future<bool> sendCmd(List<int> data, {bool answer = false}) async {
  Duration duration = const Duration(seconds: 5);
  int len = data.length;
  int times = 0;
  sfram.no = 0;
  sfram.total = (len + 127) ~/ 128;
  debugPrint("发送数据长度:$len");
  debugPrint("发送数据Total:${sfram.total}");

  while (len > 0) {
    List<int> sendpck = [];
    List<int> pack = [];
    int size = 128;

    if (len <= size) {
      size = len;
    }

    pack.addAll(intToFormatHex(size, 8)); //大小
    pack.addAll(intToFormatHex(sfram.iid, 8));
    pack.addAll(intToFormatHex(sfram.total, 4));
    pack.addAll(intToFormatHex(sfram.no++, 4));
    pack.addAll(data.sublist(0, size));
    debugPrint("$pack");
    ////print(getcrcchar(pack));
    sendpck.addAll(intToFormatHex(getcrc32char(pack), 8)); //
    sendpck.addAll(pack);
    sendpck.add(0);
    sendpck.add(size + 20);
    sendpck.add(137); //0x89
    sendpck.add(37); //0x25

    len = len - size;
    data.removeRange(0, size);
    debugPrint("len:$len");

    debugPrint("${intListToHexStringList(sendpck)}");

    await cncbt4model.senddata(sendpck);

    sendpck.clear();
    if (answer) {
      while (ack.iid != sfram.iid) {
        await Future.delayed(duration);

        await cncbt4model.senddata(sendpck);

        times++;
        debugPrint("等待标准ACK,times:$times");
        if (times >= 3) {
          debugPrint("返回");
          return false;
        }
      }
    }
  }
  sfram.iid++;
  return true;
}
// Future<bool> sendCmd(List<int> data, {bool answer = false}) async {
//   Duration duration = const Duration(seconds: 5);
//   int len = data.length;
//   int times = 0;
//   sfram.No = 0;
//   sfram.Total = (len + 127) ~/ 128;
//   debugPrint("发送标准数据长度:$len");
//   //debugPrint("发送数据Total:${sfram.Total}");
//   // ////print(data);
//   while (len > 0) {
//     List<int> sendpck = [];
//     List<int> pack = [];
//     int size = 128;
//     if (len <= size) {
//       size = len;
//     }
//     debugPrint("size:$size");
//     pack.addAll(intToFormatHex(size, 8)); //大小
//     pack.addAll(intToFormatHex(sfram.iid, 8));
//     pack.addAll(intToFormatHex(sfram.Total, 4));
//     pack.addAll(intToFormatHex(sfram.No++, 4));
//     debugPrint("data:$data");
//     pack.addAll(data.sublist(0, size));
//     ////print(pack);
//     //////print(getcrcchar(pack));
//     sendpck.addAll(pack);
//     sendpck.add(0);
//     sendpck.add(size + 20);
//     sendpck.add(137); //0x89
//     sendpck.add(37); //0x25

//     len = len - size;
//     data.removeRange(0, size);
//     // debugPrint("len:$len");
//     debugPrint("标准数据包:$sendpck");
//     await sendMessage(sendpck);
//     sendpck.clear();
//     if (answer) {
//       while (ack.iid != sfram.iid) {
//         await Future.delayed(duration);
//         await sendMessage(sendpck);
//         times++;
//         debugPrint("等待标准ACK,times:$times");
//         if (times >= 3) {
//           debugPrint("返回");
//           return false;
//         }
//       }
//     }
//   }
//   sfram.iid++;
//   return true;
// }

//在IAP中 根据数据的长度来决定是命令还是数据
//如果是数据数据包的长度为126
void updatapack(List<int> data) {
  cncbt4model.senddata(data);
}

//如果是命令 那么数据包的长度为127
Future<bool> updatacmd(List<int> data, bool answer) async {
  //int len = data.length;
  int times = 0;
  debugPrint("发送升级命令长度:${data.length}");
  Duration duration = const Duration(seconds: 2);
  List<int> sendpck = List.filled(127, 0, growable: true);
  sendpck[0] = 0xc0;
  for (var i = 0; i < data.length; i++) {
    sendpck[1 + i] = data[i];
  }
  sendpck[126] = 0xff;
  sendpck[125] = getcrc8char(sendpck);
  // ////print(sendpck.length);
  debugPrint("发送的iap命令:$sendpck");
  iapack.state = false;

  await cncbt4model.senddata(sendpck);

  // await Future.delayed(duration);
  if (answer == true) {
    debugPrint("等待接受ACK");
    while (!iapack.state) {
      await Future.delayed(duration);
      debugPrint("等待ACK");

      await cncbt4model.senddata(sendpck);

      times++;
      debugPrint("等待ACK,times:$times");
      if (times > 5) {
        debugPrint("返回");
        return false;
      }
    }
  }
  // debugPrint("收到ACK");
  return true;
}

//发送ack 127位
void updataack(List<int> data) {
  //int len = data.length;
  ////print(data.length);
  List<int> sendpck = List.filled(127, 0, growable: true);
  sendpck[0] = 0x40;
  for (var i = 0; i < data.length; i++) {
    sendpck[1 + i] = data[i];
  }
  sendpck[126] = 0xff;
  sendpck[125] = getcrc8char(sendpck);
  ////print(sendpck.length);
  ////print(sendpck);

  cncbt4model.senddata(sendpck);
}

Future<bool> ymodelSendCmd(List<int> data, {bool answer = false}) async {
  await cncbt4model.senddata(data);

  if (answer) {}
  return true;
}

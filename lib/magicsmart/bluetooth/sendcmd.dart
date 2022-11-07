import 'package:flutter/widgets.dart';

import 'package:magictank/convers/convers.dart';
import 'package:magictank/magicsmart/bluetooth/msclonebt_mananger.dart';

//发送给命令
//Packet + Type	Station + Num	Length	Command+Code	Command+Data	......	Command+Data	Command+Data	Checksum

Future<void> sendcmd(List<int> data, int cmd, List<int> cmddata) async {
  List<int> sendpack = [];
  int temp = 0;
  //await dataCallsendBle([0XA5, 0xff, 0X03, 0XFF, 0XFF, 0XA5]);
  sendpack.add(0xA5);
  sendpack.add(0xFF);
  sendpack.add(data.length + 3 + cmddata.length);
  sendpack.addAll(data);
  sendpack.add(0xff);
  sendpack.add(cmd);
  sendpack.addAll(cmddata);
  for (var i = 0; i < sendpack.length; i++) {
    temp = sendpack[i] + temp;
  }
  sendpack.add(temp & 0xff);
  debugPrint("发送的蓝牙数据包${intListToHexStringList(sendpack)}");
//  debugPrint("发送的蓝牙数据包$sendpack");
  //debugPrint(sendpack);
  await mssendMessage(sendpack);
}

//发送数据
Future<void> senddata(List<int> data, int cmd, List<int> cmddata,
    {int head = 0xA6}) async {
  List<int> sendpack = [];
  int temp = 0;
  sendpack.add(head);
  sendpack.add(0xFF);
  sendpack.add(data.length + 2 + cmddata.length);
  sendpack.addAll(data);
  sendpack.add(cmd);
  sendpack.addAll(cmddata);
  for (var i = 0; i < sendpack.length; i++) {
    temp = sendpack[i] + temp;
  }
  sendpack.add(temp & 0xff);
  debugPrint("发送的蓝牙数据包${intListToHexStringList(sendpack)}");
  //debugPrint(sendpack);
  await mssendMessage(sendpack);
}

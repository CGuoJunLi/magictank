//初始化CNC数据

import 'dart:async';

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';
import 'package:magictank/cncpage/bluecmd/sendcmd.dart';

void intcnc() async {}

//蓝牙发送的命令
CNCBTSCMD cncBtSmd = CNCBTSCMD();

class CNCBTSCMD {
  int getVer = 0X71; //获得版本
  int openClamp = 0x15; //打开夹具
  int replaceXd = 0x24; //更换铣刀
  int replaceFix = 0x22; //更换夹具
  int checkXd = 0x21; //铣刀导针 通电性检测
  int correct = 0x27; //校准2.0
  int answer = 0x86; //应答
  int getData = 0x2a; //获取校准数据
  int motorTest = 0x20; //电机测试
  int out = 0x29; //退出y
  int cuttingKey = 0x83; //切削
  int newCuttingKey = 0x80; //新版本切削尾部附带数据
  int cuttingoneKey = 0x88; //单齿切削
  int readKey = 0x82; //读码
  int pause = 0x10; //暂停
  int resume = 0x14; //继续
  int stop = 0x11; //停止
  int cncState = 0x84; //获取机器状态
  int checkPower = 0x73; //检测电量
  int upgrade = 0x70; //升级 跳转到iap
  int copyKeyRead = 0x8a; //通用复制读码
  int copyKeyCut = 0x8b; //通用复制切削
  int copyKeyPre = 0x9f; //通用复制预览
  int cutKeyModel = 0x50; //切削模型
  int answer2 = 0x9a; //应答
  int checkKey = 0x85; //查询钥匙数据
}

void getver() async {
  cncVersion.verPCB = 0;
  cncVersion.verJG = 0;
  cncVersion.version = 0;

  // var value = await updatacmd(data, true);
  // if (!value) {
  //   await sendCmd(data, answer: true);
  // }
  // debugPrint("询问完毕");

  // if (cncVersion.verPCB == 0 && cncVersion.verJG == 0) {
  //   eventBus.fire(ConnectEvent(0));
  // }
  cncVersion.processstate = 1;
  await Future.delayed(const Duration(seconds: 1));
  await updatacmd([0x71, 0, 0, 0, 0, 0], false);
  await Future.delayed(const Duration(seconds: 1));
  cncVersion.processstate = 0;
  await sendCmd([0x71], answer: false);
}

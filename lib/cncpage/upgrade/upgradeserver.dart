//数控机升级服务
//113 104 使用Ymodel升级协议
//200 106 使用标准的升级协议
//升级流程 1. 如果当前的版本号不为0 发送0x70 跳转到IAP
//2. 等待 1s后  发送 0x12 检测机器专题

import 'package:magictank/cncpage/bluecmd/receivecmd.dart';

import 'package:magictank/convers/convers.dart';

class UpgradeServer {
  int filelength = 0; //升级的文件长度
  int progress = 0; //进度
  int senddatalen = 0; //已经发送的长度
  List<int> sendcmdpack = [];
  List<int> senddatapack = [];
  startupgrade() {
    //开始升级
    if (cncVersion.verPCB == 113) {
      //使用ymodel升级
    } else {
      //使用标准升级
      //1. 先发送0x12 擦除芯片
      sendcmdpack[0] = 0x12;
      sendcmdpack.addAll(intToFormatHex(stringHexToInt(cncVersion.w), 8));
      sendcmdpack.addAll(intToFormatHex(stringHexToInt(cncVersion.w), 8));
      ////print(sendcmdpack);

      //updatacmd(sendcmdpack, false);
    }
  }
}

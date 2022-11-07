import 'package:flutter/material.dart';
import 'package:magictank/convers/convers.dart';

import '../chipclass/progresschip.dart';
import 'crc.dart';

// late EventBus eventBus;

// class ChipReadEvent {
//   //消息监听  用于数控机返回数据等
//   // 当前的索引
//   String chipname;
//   List<int> chipnamebyte;
//   List<int> data;
//   // 重写构造方法
//   ChipReadEvent(this.chipnamebyte, this.chipname, this.data);
// }

class Chip4D80Event {
  int state = 0;
  List<int> sign = [];
}

void processingChipData(List<int> data) {
  List<int> temp = [];

  temp = List.from(data);
  if ((data[0] == 0xe5 &&
          data[1] == 0xff &&
          checkdata(data) == data[data.length - 1]) ||
      (data[0] == 0xa5 &&
          data[1] == 0xff &&
          checkdata(data) == data[data.length - 1])) {
    debugPrint("bt校验通过");
    debugPrint("${intListToHexStringList(temp)}");
    progressChip.progressbtchipdata(data);
    // debugPrint(intToFormatStringHex(data[3]) + intToFormatStringHex(data[4]));
    // eventBus.fire(ChipReadEvent(
    //     data.sublist(2, 3),
    //     intToFormatStringHex(data[3]) + intToFormatStringHex(data[4]),
    //     data.sublist(4, data.length - 1)));
    //如果校验通过
  } else {
    debugPrint("bt校验失败");
    debugPrint("$temp");
  }
  temp.clear();
}
